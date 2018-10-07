require 'gosu'

class Rect
  attr_accessor :x, :y, :w, :h
  def initialize(x, y, w, h)
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def contain?(x, y)
    @x <= x && x <= @x + @w && @y <= y && y < @y + @h
  end

  def draw
    Gosu.draw_rect(@x, @y, @w, @h, Gosu::Color::WHITE)
    Gosu.draw_rect(@x + 1, @y + 1, @w - 2, @h - 2, Gosu::Color::BLACK)
  end
  def resize(delta, direction)
    dx,dy = delta
    n,s,e,w = direction
    @x = @x + e * dx
    @y = @y + n * dy
    # if self.alignToGrid:
    #     xOffset = xOffset / self.xGridSize * self.xGridSize
    #     yOffset = yOffset / self.yGridSize * self.yGridSize
    #     xStartOffset = xStartOffset / self.xGridSize * self.xGridSize
    #     yStartOffset = yStartOffset / self.yGridSize * self.yGridSize

    @w = @w + (w - e) * dx
    @h = @h + (s - n) * dy
    @w=5 if @w<=5
    @h=5 if @h<=5
  end
end
module Utils
  def self.in?(point, rect)
    px, py = point
    x, y, w, h = rect
    x <= px && px <= x + w && y <= py && py < y + h
  end
end
class App < Gosu::Window
  def initialize
    super 320, 240

    @objects = []

    @objects << Rect.new(50, 50, 50, 150)
    @objects << Rect.new(50, 50, 150, 50)
  end

  def needs_cursor?
    true
  end

  def draw
    # Gosu.draw_rect(27, 27, 27, 27, Gosu::Color::WHITE)

    @objects.each(&:draw)
    if @mouse_down && @select
      @select.x = mouse_x - @mouse_down[0]
      @select.y = mouse_y - @mouse_down[1]
    end
    if e = @select
      # Gosu.draw_rect(e.x - 5, e.y - 5, e.w + 10, e.h + 10, Gosu::Color::RED)
      Gosu.draw_rect(e.x - 5, e.y - 5, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x - 5, e.y + e.h, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.w, e.y - 5, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.w, e.y + e.h, 5, 5, Gosu::Color::RED)
    end
    if @sizing
      px,py = @sizing_point
      @select.resize([mouse_x-px,mouse_y-py],@sizing)
      @sizing_point = [mouse_x,mouse_y]
    end
  end

  def button_up(id)
    return unless id == Gosu::MS_LEFT

    if @mouse_down && @select
      @select.x = mouse_x - @mouse_down[0]
      @select.y = mouse_y - @mouse_down[1]
      @mouse_down = nil
      end
      if @sizing
        px,py = @sizing_point
        @select.resize([mouse_x-px,mouse_y-py],@sizing)
        @sizing_point = [mouse_x,mouse_y]
        @sizing= nil
      end      
  end

  def button_down(id)
    p id
    case id
    when Gosu::MS_LEFT
      if @select
        px,py=mouse_x,mouse_y
        x,y,w,h = @select.x,@select.y,@select.w,@select.h
        case  
        when Utils.in?([px,py],[x - 5, y - 5, 5, 5])
          @sizing = [1,0,1,0] # :LEFTTOP
        when Utils.in?([px,py],[x - 5, y + h, 5, 5])
          @sizing =[0,1,1,0]  # :RIGHTTOP
        when Utils.in?([px,py],[x + w, y - 5, 5, 5])
          @sizing = [1,0,0,1] # :LEFTBOTTOM 
        when Utils.in?([px,py],[x + w, y + h, 5, 5])
          @sizing = [0,1,0,1] # :RIGHTBOTTOM
        else
          @sizing = nil
        end
        p @sizing
        if @sizing
          @sizing_point = [px, py]
          return 
        end
      end
      @select = nil
      @objects.reverse_each do |e|
        if e.contain?(mouse_x, mouse_y)
          @select = e
          @mouse_down = [mouse_x - e.x, mouse_y - e.y]
          break
        end
        if 1
        end
      end
    when Gosu::KB_LEFT
      @select.x -= 5 if @select
    when Gosu::KB_RIGHT
      @select.x += 5 if @select
    when Gosu::KB_DOWN
      @select.y += 5 if @select
    when Gosu::KB_UP
      @select.y -= 5 if @select
    when 9
      @objects << Rect.new(50, 50, 150, 50)
    end
  end

  def update
    # p Gosu.button_down?(256)
  end
end
App.new.show

# 参考 PythonCard