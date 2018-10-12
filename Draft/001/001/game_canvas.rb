require 'gosu'

class Item
  attr_accessor :x, :y, :w, :h

  def initialize
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def update

  end

  def draw

  end

  def click
    false
  end
end

class CanvasItem
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
    dx, dy = delta
    n, s, e, w = direction
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


module Helper
  def self.in?(point, rect)
    px, py = point
    x, y, w, h = rect
    x <= px && px <= x + w && y <= py && py < y + h
  end
end

class Button  < Item
  def draw
    Gosu.draw_rect(@x, @y, @w, @h, Gosu::Color::WHITE)
  end
end

class Resizer < Item
  attr_reader :draging

  def initialize
    super
    @draging = false
    @resizing = nil
    @start_positon = [0,0]
    @end_pos = [0,0]
  end

  def draw
    e = self
    Gosu.draw_rect(e.x - 5, e.y - 5, 5, 5, Gosu::Color::RED)
    Gosu.draw_rect(e.x - 5, e.y + e.h, 5, 5, Gosu::Color::RED)
    Gosu.draw_rect(e.x + e.w, e.y - 5, 5, 5, Gosu::Color::RED)
    Gosu.draw_rect(e.x + e.w, e.y + e.h, 5, 5, Gosu::Color::RED)
  end

  def click(point_pos)
    px, py = point_pos
    x, y, w, h = self.x, self.y, self.w, self.h
    case
      when Helper.in?([px, py], [x - 5, y - 5, 5, 5])
        @resizing = [1, 0, 1, 0] # LEFT TOP
      when Helper.in?([px, py], [x - 5, y + h, 5, 5])
        @resizing =[0, 1, 1, 0] # RIGHT TOP
      when Helper.in?([px, py], [x + w, y - 5, 5, 5])
        @resizing = [1, 0, 0, 1] # LEFT BOTTOM
      when Helper.in?([px, py], [x + w, y + h, 5, 5])
        @resizing = [0, 1, 0, 1] # RIGHT BOTTOM
      else
        @resizing = nil
    end
    if @resizing
      @resizing_point = [px, py]
      return true
    end
    super()
  end
end

class CanvasApp < Gosu::Window
  def initialize
    super 320, 240

    @objects = []

    @objects << CanvasItem.new(50, 50, 50, 150)
    @objects << CanvasItem.new(50, 50, 150, 50)

    @selection = nil
    @selections = []

  end

  def needs_cursor?
    true
  end

  def draw
    # Gosu.draw_rect(27, 27, 27, 27, Gosu::Color::WHITE)


    if @dragging && @selection
      @selection.x = mouse_x - @dragging[0]
      @selection.y = mouse_y - @dragging[1]
    end

    if @resizing
      px, py = @resizing_point
      @selection.resize([mouse_x-px, mouse_y-py], @resizing)
      @resizing_point = [mouse_x, mouse_y]
    end
    @objects.each(&:draw)
    if e = @selection
      # Gosu.draw_rect(e.x - 5, e.y - 5, e.w + 10, e.h + 10, Gosu::Color::RED)
      Gosu.draw_rect(e.x - 5, e.y - 5, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x - 5, e.y + e.h, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.w, e.y - 5, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.w, e.y + e.h, 5, 5, Gosu::Color::RED)
    end
  end

  def button_up(id)
    return unless id == Gosu::MS_LEFT

    if @dragging && @selection
      @selection.x = mouse_x - @dragging[0]
      @selection.y = mouse_y - @dragging[1]
      @dragging = nil
    end
    if @resizing
      px, py = @resizing_point
      @selection.resize([mouse_x-px, mouse_y-py], @resizing)
      @resizing_point = [mouse_x, mouse_y]
      @resizing= nil
    end
  end

  def button_down(id)
    p id
    case id
      when Gosu::MS_LEFT
        if @selection
          px, py=mouse_x, mouse_y
          x, y, w, h = @selection.x, @selection.y, @selection.w, @selection.h
          case
            when Helper.in?([px, py], [x - 5, y - 5, 5, 5])
              @resizing = [1, 0, 1, 0] # :LEFTTOP
            when Helper.in?([px, py], [x - 5, y + h, 5, 5])
              @resizing =[0, 1, 1, 0] # :RIGHTTOP
            when Helper.in?([px, py], [x + w, y - 5, 5, 5])
              @resizing = [1, 0, 0, 1] # :LEFTBOTTOM
            when Helper.in?([px, py], [x + w, y + h, 5, 5])
              @resizing = [0, 1, 0, 1] # :RIGHTBOTTOM
            else
              @resizing = nil
          end
          p @resizing
          if @resizing
            @resizing_point = [px, py]
            return
          end
        end


        @selection = nil
        @objects.reverse_each do |e|
          if e.contain?(mouse_x, mouse_y)
            @selection = e
            @dragging = [mouse_x - e.x, mouse_y - e.y]
            break
          end
          if 1
          end
        end


      when Gosu::KB_LEFT
        @selection.x -= 5 if @selection
      when Gosu::KB_RIGHT
        @selection.x += 5 if @selection
      when Gosu::KB_DOWN
        @selection.y += 5 if @selection
      when Gosu::KB_UP
        @selection.y -= 5 if @selection
      when 9
        @objects << CanvasItem.new(50, 50, 150, 50)
    end
  end

  def update
    # p Gosu.button_down?(256)
  end
end

$APP = CanvasApp.new

$APP.show

# 参考 PythonCard