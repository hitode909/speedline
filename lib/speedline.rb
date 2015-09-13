require 'open-uri'
require 'RMagick'

class SpeedLine
  def apply_for_url(url)
    images = Magick::ImageList.new.from_blob(open(url).read)

    if images.length > 1
      gif = images
    else
      gif = Magick::ImageList.new
      frame = images.first
      frame.format = 'GIF'
      3.times {
        gif << frame.clone
      }
    end

    gif.each{|image|
      append_line(image)
    }
    gif.optimize_layers(Magick::OptimizeTransLayer).deconstruct.to_blob
  end

  protected

  def append_line(image)
    draw = Magick::Draw.new
    draw.fill('black')

    center = [ image.columns / 2, image.rows / 2]

    radius_center = 0.75
    step = 0.02
    bold = 1.0
    theeta = 0
    while theeta < Math::PI*2 do
      step_noise = rand + 0.5
      theeta += step * step_noise
      radius_center_noise = rand*0.3+1.0
      bold_noise = rand*0.7+0.3
      line_center = [Math.sin(theeta) * center[0] *radius_center * radius_center_noise + center[0], Math.cos(theeta) * center[1] *radius_center * radius_center_noise + center[1]]
      point = [Math.sin(theeta) * center[0] * 2 + center[0], Math.cos(theeta) * center[1] * 2 + center[1]]
      point2 = [Math.sin(theeta+step*bold*bold_noise) * center[0] * 2 + center[0], Math.cos(theeta+step*bold*bold_noise) * center[1] * 2 + center[1]]

      draw.polygon( *line_center,   *point,  *point2)
    end

    draw.draw(image)
    image
  end
end
