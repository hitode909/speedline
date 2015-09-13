require 'bundler'

Bundler.require

require 'open-uri'

url = ARGV.first

source = open(url).read

source_image = Magick::Image.from_blob(source).first

p source_image
CENTER = [ source_image.columns / 2, source_image.rows / 2]

draw = Magick::Draw.new

draw.fill('black')

radius_center = 0.75
step = 0.02
bold = 1.0
theeta = 0
while theeta < Math::PI*2 do
  step_noise = rand + 0.5
  theeta += step * step_noise
  radius_center_noise = rand*0.3+1.0
  bold_noise = rand*0.7+0.3
  center = [Math.sin(theeta) * CENTER[0] *radius_center * radius_center_noise + CENTER[0], Math.cos(theeta) * CENTER[1] *radius_center * radius_center_noise + CENTER[1]]
  point = [Math.sin(theeta) * CENTER[0] * 2 + CENTER[0], Math.cos(theeta) * CENTER[1] * 2 + CENTER[1]]
  point2 = [Math.sin(theeta+step*bold*bold_noise) * CENTER[0] * 2 + CENTER[0], Math.cos(theeta+step*bold*bold_noise) * CENTER[1] * 2 + CENTER[1]]

  draw.polygon( *center,   *point,  *point2)
end

draw.draw(source_image)

source_image.write('_.jpg')
