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


module Utils
  # module_function
  def self.in?(point, rect)
    px, py = point
    x, y, w, h = rect
    x <= px && px <= x + w && y <= py && py < y + h
  end

  def self.rect_intersect?(a, b)
    x1 = [a.x, b.x].max
    y1 = [a.y, b.y].max
    x2 = [a.x+a.w, b.x+b.w].min
    y2 = [a.y+a.h, b.y+b.y].min
    x1 <= x2 && y1 <= y2
  end
end


class App < Gosu::Window
  def initialize
    super 320, 240
    self.caption = 'Canvas 画布'
    @bar = Gosu::Image.from_text('Design Mode', 16)

    @objects = []

    @objects << Rect.new(50, 50, 50, 150)
    @objects << Rect.new(50, 50, 150, 50)

    @selection = nil
    @selections = []
    @dragging = nil
    @resizing = nil
    @mouse_down2 = nil

  end

  def needs_cursor?
    true
  end

  def draw
    @bar.draw(0, 0, 0, 1, 1, Gosu::Color::WHITE)
    # Gosu.draw_rect(27, 27, 27, 27, Gosu::Color::WHITE)

    if @dragging # && @selection
      @selection.x = mouse_x - @dragging[0]
      @selection.y = mouse_y - @dragging[1]
    end

    if @resizing
      px, py = @resizing_point
      @selection.resize([mouse_x-px, mouse_y-py], @resizing)
      @resizing_point = [mouse_x, mouse_y]
    end

    @objects.each(&:draw)

    if (e = @selection)
      # Gosu.draw_rect(e.x - 5, e.y - 5, e.w + 10, e.h + 10, Gosu::Color::RED)
      Gosu.draw_rect(e.x - 5, e.y - 5, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x - 5, e.y + e.h, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.w, e.y - 5, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.w, e.y + e.h, 5, 5, Gosu::Color::RED)
    end

    if @mouse_down2
      x, y = @mouse_down2
      Gosu.draw_rect(x, y, mouse_x-x, mouse_y-y, Gosu::Color.rgba(255, 255, 255, 32))
    end
  end

  def button_up(id)
    if id == Gosu::MS_LEFT

      if @dragging # && @selection
        @selection.x = mouse_x - @dragging[0]
        @selection.y = mouse_y - @dragging[1]
        @dragging = nil
      end

      if @resizing
        px, py = @resizing_point
        @selection.resize([mouse_x-px, mouse_y-py], @resizing)
        @resizing_point = nil # [mouse_x, mouse_y]
        @resizing = nil
      end

      if @mouse_down2
        x = [mouse_x, @mouse_down2[0]].min
        y = [mouse_y, @mouse_down2[1]].min
        w = (mouse_x-@mouse_down2[0]).abs
        h = (mouse_y-@mouse_down2[1]).abs
        rect = Rect.new(x, y, w, h)
        @selections.clear
        @objects.each { |e|
          if Utils.rect_intersect?(e, rect)
            @selections << e
          end
        }
        p @selections
        @mouse_down2 = nil
      end
    end
  end

  def button_down(id)
    p id
    case id
      when Gosu::MS_LEFT
        if @selection
          px, py = mouse_x, mouse_y
          x, y, w, h = @selection.x, @selection.y, @selection.w, @selection.h
          case
            when Utils.in?([px, py], [x - 5, y - 5, 5, 5])
              @resizing = [1, 0, 1, 0] # left top
            when Utils.in?([px, py], [x - 5, y + h, 5, 5])
              @resizing =[0, 1, 1, 0] # right top
            when Utils.in?([px, py], [x + w, y - 5, 5, 5])
              @resizing = [1, 0, 0, 1] # left bottom
            when Utils.in?([px, py], [x + w, y + h, 5, 5])
              @resizing = [0, 1, 0, 1] # right bottom
            else
              @resizing = nil
          end
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
            return # break
          end
          self
        end
        @mouse_down2 = [mouse_x, mouse_y]
      when Gosu::KB_LEFT
        @selection.x -= 5 if @selection
      when Gosu::KB_RIGHT
        @selection.x += 5 if @selection
      when Gosu::KB_DOWN
        @selection.y += 5 if @selection
      when Gosu::KB_UP
        @selection.y -= 5 if @selection
      when 9
        @objects << Rect.new(50, 50, 150, 50)
        @selection = @objects.last unless @dragging
      else
    end
  end

  def update
    # p Gosu.button_down?(256)
  end
end
App.new.show

# 参考 PythonCard