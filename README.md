# OmgImage
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

- sudo apt install gdebi-core
- wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
- sudo gdebi google-chrome-stable_current_amd64.deb

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

## Development

- install chrome headless
- add to `/etc/hosts` new host `127.0.0.0     site.com`
- in `puma.rb` put `workers ENV.fetch("WEB_CONCURRENCY") { 3 }` (required because screenshot is made from another request)
-

## Chrome headless

### Ubuntu (Linux)

"Chrome"

### Mac

Config:

"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --no-sandbox --ignore-certificate-errors --screenshot=/var/folders/mw/xsxqlk9d1d31blr91jpn77nw0000gn/T/image20181106-77613-1kk7jb3.png --window-size=600,300 "file:///var/folders/mw/xsxqlk9d1d31blr91jpn77nw0000gn/T/input20181106-77613-1e4t5e5.html"

## Issues

- if you process too many requests and because of timeouts dead processes may appear. To kill them `parents_of_dead_kids=$(ps -ef | grep [d]efunct | awk '{print $3}' | sort | uniq | egrep -v '^1$'); echo "$parents_of_dead_kids" | xargs kill`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
