module OmgImage
  class Shell
    def Shell.command(options)
      size_opts = options[:size] == :auto ? nil : "--window-size=#{options[:size]}"
      "#{chrome} --headless --disable-gpu --no-sandbox --ignore-certificate-errors --screenshot=#{options[:file].path} #{size_opts} \"file://#{options[:path]}\""
    end

    private

    def self.chrome
      if OS.windows?
        "chrome"
      elsif OS.mac?
        "\"/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome\""
      else
        "google-chrome"
      end
    end
  end
end
