require 'uri'
require 'tempfile'

module OmgImage
  module ApplicationHelper
    include OmgHelper

    def omg_image_preview(omg: {})
      omg        ||= {}
      omg[:size] ||= '800,400'  
      omg[:key]  ||= omg.to_s

      image       = OmgImage::Image.find_by(key: omg[:key])

      if image && !image.file.attached?
        image.destroy
        image = nil
      end

      file = image&.file || create_screenshot(omg)
      file ?  url_for(file) : "something-went-wrong.png"
    end

    private

    def create_screenshot(omg)
      begin
        file = Tempfile.new("image.png")

        options = {
          file: file,
          size: omg[:size],
          url: omg_image.preview_url(omg: omg)
        }

        command = build_chrome_command(options)
        Rails.logger.debug "  ====>> executing: #{command}"
        `#{command}`

        image = OmgImage::Image.find_or_create_by(key: omg[:key])

        if !image.file.attached?
          image.file.attach(io: File.open(file.path), filename: "image.png", content_type: "image/png")
          image.save
        end

        image.file
      ensure
        file.close!
      end
    end

    def build_chrome_command(options)
      "google-chrome --headless --disable-gpu --no-sandbox --ignore-certificate-errors --screenshot=#{options[:file].path} --window-size=#{options[:size]} \"#{options[:url]}\""
    end

  end
end
