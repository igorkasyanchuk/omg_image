require 'uri'
require 'tempfile'
require 'open3'
require 'timeout'
require "open4"

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
        file = BetterTempfile.new("image.png")

        options = {
          file: file,
          size: options[:size],
          url: omg_image.preview_url(omg: options)
        }

        binding.pry

        input = ApplicationController.render file: "og_image/previews/show"

        command = build_chrome_command(options)
        Rails.logger.debug "  ====>> executing: #{command}"

        #Timeout::timeout(5) {
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
            pid = process.pid
            Rails.logger.info "==========="
            Rails.logger.info process
            Rails.logger.info process.pid
            Rails.logger.info "==========="
          rescue Timeout::Error
            Rails.logger.info "++++++++#{process}+++++#{pid}++++"
            Process.kill('KILL', process.pid)
            Rails.logger.info "++++++++"
          end
        #}

        image = OmgImage::Image.find_or_create_by(key: options[:key])

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
