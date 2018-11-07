module OmgImage
  class Processor
    attr_reader :template, :options

    def initialize(template, options)
      template.downcase!
      options        ||= {}
      options[:size] ||= '800,400'
      options[:key]  ||= options.to_s
      template         = "#{template}.html.erb" unless template.ends_with?(".html.erb")
      @template        = template
      @options         = options
    end

    def cached_or_new(regenerate: false)
      reset_cache if regenerate
      cached&.file || generate_new&.file
    end

    def generate_new(cache: true)
      output = create_screenshot
      if cache
        image = save_to_cache(output)
        output&.close
        image
      else
        output
      end
    end

    def generate(&block)
      create_screenshot(&block)
    end

    private

    def create_screenshot
      begin
        start = Time.now
        body  = OmgImage::Renderer.render(template, locals: options)
        log_smt "  to_html: #{(Time.now - start).round(2)}"

        input = BetterTempfile.new("input.html")
        input.write(body)
        input.flush

        output = BetterTempfile.new("image.png")

        command = Shell.command({ file: output, size: options[:size], path: input.path })
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

        yield(output) if block_given?

        output
      ensure
        #output&.close!
        input&.close!
      end
    end

    def log_smt(str)
      Rails.logger.debug(str)
    end

    def reset_cache
       OmgImage::Image.where(key: options[:key]).destroy_all
    end

    def cached
      image = OmgImage::Image.find_by(key: options[:key])
      if image && !image.file.attached?
        image.destroy
        image = nil
      end
      image
    end

    def save_to_cache(output)
      image   = OmgImage::Image.find_by(key: options[:key])
      image ||= OmgImage::Image.new(key: options[:key])
      if !image.file.attached?
        image.file.attach(io: File.open(output.path), filename: "image.png", content_type: "image/png")
        image.save!
      end
      image
    end

  end
end
