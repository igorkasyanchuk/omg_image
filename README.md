# OmgImage
Short description and motivation.

## Usage
How to use my plugin.

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

## Development

- install chrome headless 
- add to `/etc/hosts` new host `127.0.0.0     site.com`
- in `puma.rb` put `workers ENV.fetch("WEB_CONCURRENCY") { 3 }` (required because screenshot is made from another request)
- 

## Issues

- if you process too many requests and because of timeouts dead processes may appear. To kill them `parents_of_dead_kids=$(ps -ef | grep [d]efunct | awk '{print $3}' | sort | uniq | egrep -v '^1$'); echo "$parents_of_dead_kids" | xargs kill`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
