# omg_image

[![RailsJazz](https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/my_other.svg?raw=true)](https://www.railsjazz.com)

Let's start with sample of what this gem can do (below are the images of generated previews):

Demo: [https://www.youtube.com/watch?v=Lso-B_fayhw](https://www.youtube.com/watch?v=Lso-B_fayhw)

[![Sample](https://github.com/igorkasyanchuk/omg_image/blob/master/docs/sample2.png?raw=true)](https://github.com/igorkasyanchuk/omg_image/blob/master/docs/sample2.png?raw=true)

If you need to generate complex images, previews, charts or basically represent any HTML snippet - this gem could help.

It's using a Chrome(headless) to convert any HTML to PNG. 

If you want to try, you just need a 5 min to see how it works. Gem is comming with an examples which you can modify and use in your real app.

## Usage

- add this gem to Gemfile - `gem "omg_image"`
- make sure you have chrome installed (`google-chrome --version`)
- execute `rails g omg` in app
- execute `rake db:migrate`
- edit sample template `app/omg/simple.html.erb`
- open any view, for example you have `app/views/home/index.html.erb` and put:

```erb
  <%= image_tag OmgImage::Processor.new('entity', key: 'xxx', title: "OMG,<br/>this looks interesting!", tags: ['This', 'is', 'a', 'sample'], description: "Change me please", size: '600,300').cached_or_new %>
  <br/>
  <%= image_tag OmgImage::Processor.new('entity', title: "OMG,<br/>this looks interesting!", description: "Small version", size: '400,200').cached_or_new(regenerate: true) %>
  <br/>
  <%= image_tag OmgImage::Processor.new('square', title: "Real-time generation", size: '200,200').cached_or_new %>
```
- refresh page and see images
- edit/create new previews and use them in any place of your app.

Also, for example you can do it on generate images directly in the models:

```ruby
class Post < ApplicationRecord
  has_one_attached :preview
  # just an example
  def Post.create_new_preview
    processor = ::OmgImage::Processor.new('entity', title: "OMG,<br/>this is created from model", description: "Small version", size: '400,200')
    processor.with_screenshot do |screenshot|
      post = Post.new
      post.preview.attach(io: File.open(screenshot.path), filename: "image.png", content_type: "image/png")
      post.save!
    end
  end
end
```

To create a new template - basically create a new file in `app/omg/<name>.html.erb`. Put any HTML/CSS into it. And use as described above.

## Requirements

- Rails App 5+ and Active Storage
- Google chrome (headless)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omg_image'
```

And then execute:
```bash
$ bundle
```

## Features

- you can generate images with any complexity (you just need to know html/css)
- store cached versions of preview by `key` and you can obtain them by `OmgImage::Image.find_by(key: key)`
- generate images in background jobs or console applications
- caching for previews by `key`
- ability to refresh preview by `key`

# Options

- `.cached_or_new(regenerate: true)` pass this option with true value if you want to regenerate image

## Google Chrome Installation

- `sudo apt install gdebi-core`
- `wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb`
- `sudo gdebi google-chrome-stable_current_amd64.deb`
- verify chrome is installed `google-chrome --version`

## More about Chrome

- https://linuxize.com/post/how-to-install-google-chrome-web-browser-on-ubuntu-18-04/

## Issues

- if you process too many requests and because of timeouts dead processes may appear. To kill them `parents_of_dead_kids=$(ps -ef | grep [d]efunct | awk '{print $3}' | sort | uniq | egrep -v '^1$'); echo "$parents_of_dead_kids" | xargs kill`

## TODO

- ability to configure app (path to chrome for example)
- more samples (with layout)
- wiki pages with documentation and samples
- ability to preview templates directly by URL
- tests/specs
- options to delay rendering (could be useful if use JS libraries or external assets)
- support remote URL's to render (so it would possible to capture screenshots for example)

## Contributing

You are welcome to contribute.

## Inspirations

I've noticed that in a past that articles on dev.to site  without images when you sending a link in skype or sharing in FB have have nice preview, so I've implemented similar solution :)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


[<img src="https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/more_gems.png?raw=true"
/>](https://www.railsjazz.com/)
