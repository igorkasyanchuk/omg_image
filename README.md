# omg_image

Generate preview images on the fly for your HTML snippets.

## Usage

## Requirements

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

Or install it yourself as:
```bash
$ gem install omg_image
```

## Google Chrome Installation

- sudo apt install gdebi-core
- wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
- sudo gdebi google-chrome-stable_current_amd64.deb
- verify chrome is installed `google-chrome --version`

## Development

- install chrome headless
- add to `/etc/hosts` new host `127.0.0.0     site.com`
- in `puma.rb` put `workers ENV.fetch("WEB_CONCURRENCY") { 3 }` (required because screenshot is made from another request)
-

## More about Chrome

- https://linuxize.com/post/how-to-install-google-chrome-web-browser-on-ubuntu-18-04/

## Issues

- if you process too many requests and because of timeouts dead processes may appear. To kill them `parents_of_dead_kids=$(ps -ef | grep [d]efunct | awk '{print $3}' | sort | uniq | egrep -v '^1$'); echo "$parents_of_dead_kids" | xargs kill`

## Contributing

You are welcome to contribute.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
