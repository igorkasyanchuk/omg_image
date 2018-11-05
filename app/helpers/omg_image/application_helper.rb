require 'uri'
require 'tempfile'
require 'timeout'
require 'open4'

module OmgImage
  module ApplicationHelper
    include OmgHelper

    def omg_image_preview(template, options)
      options        ||= {}
      options[:size] ||= '800,400'
      options[:key]  ||= options.to_s

      image = OmgImage::Image.find_by(key: options[:key])
      if image && !image.file.attached?
        image.destroy
        image = nil
      end

      file = image&.file || create_screenshot(template, options)

      url_for(file) if file
    end

    private

    def create_screenshot(template, options)
      begin
        start = Time.now
        body  = OmgImage::Renderer.render(template, locals: options)
        log_smt "  to_html: #{(Time.now - start).round(2)}"

        input = BetterTempfile.new("input.html")
        input.write(body)
        input.flush

        output = BetterTempfile.new("image.png")

        cli_options = { file: output, size: options[:size], path: input.path }
        command = build_chrome_command(cli_options)
        log_smt "  => #{command}"

        start = Time.now
        begin
          process = open4.spawn(command, timeout: 10)
        rescue Timeout::Error
          Process.kill('KILL', process.pid) rescue nil
          log_smt "omg error: please retry. options: #{options}"
          return nil
        end
        log_smt "  to_image: #{(Time.now - start).round(2)}"

        image   = OmgImage::Image.find_by(key: options[:key])
        image ||= OmgImage::Image.new(key: options[:key])
        if !image.file.attached?
          image.file.attach(io: File.open(output.path), filename: "image.png", content_type: "image/png")
          image.save!
        end

        image.file
      ensure
        output&.close!
        input&.close!
      end
    end

    def build_chrome_command(options)
      size_opts = options[:size] == :auto ? nil : "--window-size=#{options[:size]}"
      "google-chrome --headless --disable-gpu --no-sandbox --ignore-certificate-errors --screenshot=#{options[:file].path} #{size_opts} \"file://#{options[:path]}\""
    end

    def log_smt(str)
      Rails.logger.debug(str)
    end

  end
end
