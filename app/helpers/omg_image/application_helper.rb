require 'uri'
require 'tempfile'
require 'open3'

class BetterTempfile < Tempfile
  # ensures the Tempfile's filename always keeps its extension
  def initialize(filename, temp_dir = nil)
    temp_dir ||= Dir.tmpdir
    extension = File.extname(filename)
    basename  = File.basename(filename, extension)
    super([basename, extension], temp_dir)
  end
end

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
        file = BetterTempfile.new("image.png")

        options = {
          file: file,
          size: omg[:size],
          url: omg_image.preview_url(omg: omg)
        }

        command = build_chrome_command(options)
        Rails.logger.debug "  ====>> executing: #{command}"

        err = Open3.popen3(*command) do |_stdin, _stdout, stderr|
          puts "stdout: #{_stdout.read}"
          stderr.read
        end

        if err.present?
          Rails.logger.debug "  ===>> error: #{err}"
        end

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
