require 'uri'
require 'tempfile'
require 'open3'
require 'timeout'
require "open4"

module OmgImage
  module ApplicationHelper
    include OmgHelper

    def omg_image_preview(options)
      options        ||= {}
      options[:size] ||= '800,400'  
      options[:key]  ||= options.to_s

      image       = OmgImage::Image.find_by(key: options[:key])

      if image && !image.file.attached?
        image.destroy
        image = nil
      end

      file = image&.file || create_screenshot(options)
      file ?  url_for(file) : "something-went-wrong.png"
    end

    private

    def create_screenshot(options)
      begin
        body  = OmgImage::Renderer.render('entity.html.erb', locals: options)

        input = BetterTempfile.new("input.html")
        input.write(body)
        input.flush

        output = BetterTempfile.new("image.png")

        options = {
          file: output,
          size: options[:size],
          path: input.path
        }

        command = build_chrome_command(options)
        Rails.logger.debug "  ====>> executing: #{command}"

        # err = Open3.popen3(*command) do |_stdin, _stdout, stderr|
        #   puts "stdout: #{_stdout.read}"
        #   stderr.read
        # end
        # if err.present?
        #   Rails.logger.debug "  ===>> error: #{err}"
        # else
        #   Rails.logger.debug "Attaching ...."
        # end
        # err = Open4::popen4(command) do |pid, stdin, stdout, stderr|
        #   Rails.logger.info "pid: #{pid}"
        #   stderr.read
        # end

        begin
          process = open4.spawn command, timeout: 5
        rescue Timeout::Error
          Process.kill('KILL', process.pid) rescue nil
        end

        image = OmgImage::Image.find_or_create_by(key: options[:key])

        if !image.file.attached?
          image.file.attach(io: File.open(output.path), filename: "image.png", content_type: "image/png")
          image.save
        end

        image.file
      ensure
        output.close! if output
        input.close! if input
      end
    end

    def build_chrome_command(options)
      "google-chrome --headless --disable-gpu --no-sandbox --ignore-certificate-errors --screenshot=#{options[:file].path} --window-size=#{options[:size]} \"file://#{options[:path]}\""
    end

  end
end
