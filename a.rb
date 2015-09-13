require 'bundler'

Bundler.require

require 'open-uri'

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'speedline'

url = ARGV.first

content = SpeedLine.new.apply_for_url(url)

open('out.gif', 'w') {|f|
  f.write content
}
