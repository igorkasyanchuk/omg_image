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

      image = OmgImage::Image.find_by(key: options[:key])
      if image && !image.file.attached?
        image.destroy
        image = nil
      end

      file = image&.file || create_screenshot(options)
      file ? url_for(file) : "something-went-wrong.png"
    end

    private

    def create_screenshot(options)
      begin
        start = Time.now
        body  = OmgImage::Renderer.render('entity.html.erb', locals: options)
        Rails.logger.debug "  to_html: #{(Time.now - start).round(2)}"

        input = BetterTempfile.new("input.html")
        input.write(body)
        input.flush

        output = BetterTempfile.new("image.png")

        options = { file: output, size: options[:size], path: input.path }
        command = build_chrome_command(options)
        Rails.logger.debug "  ====>> executing: #{command}"

        start = Time.now
        begin
          process = open4.spawn(command, timeout: 10)
        rescue Timeout::Error
          Process.kill('KILL', process.pid) rescue nil
        end
        Rails.logger.debug "  to_image: #{(Time.now - start).round(2)}"

        image = OmgImage::Image.find_or_create_by(key: options[:key])
        if !image.file.attached?
          image.file.attach(io: File.open(output.path), filename: "image.png", content_type: "image/png")
          image.save
        end

        image.file
      ensure
        output&.close!
        input&.close!
      end
    end

    def build_chrome_command(options)
      "google-chrome --headless --disable-gpu --no-sandbox --ignore-certificate-errors --screenshot=#{options[:file].path} --window-size=#{options[:size]} \"file://#{options[:path]}\""
    end

  end
end
