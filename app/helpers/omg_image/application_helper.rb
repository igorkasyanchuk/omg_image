require 'uri'

module OmgImage
  module ApplicationHelper
    include OmgHelper

    # apt-get update
    # apt-get install firefox
    # firefox -headless -screenshot file.png --window-size=800,400 http://192.168.243.128:3000/omg_image/preview

    def omg_image_preview(omg: {}, size: '800,400')
      # screenshot = Gastly.screenshot(omg_image.preview_url(options))
      # screenshot.browser_width     = 800
      # screenshot.browser_height    = 400
      # screenshot.timeout           = 3000
      # screenshot.phantomjs_options = '--ignore-ssl-errors=true'
      # image                        = screenshot.capture
      # image.save('public/output.png')
      file_name = "file-#{rand(10000000)}.png"
      url       = omg_image.preview_url(omg: omg.presence || {})
      command   = "google-chrome --headless --disable-gpu --screenshot=public/preview/#{file_name} --no-sandbox --window-size=#{size} \"#{url}\""
      Rails.logger.debug "executing: #{command}"
      `#{command}`
      "/preview/#{file_name}"
    end

  end
end
