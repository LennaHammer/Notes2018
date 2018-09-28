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
end

class App < Gosu::Window
  def initialize
    super 320, 240

    @objects = []

    @objects << Rect.new(50, 50, 50, 50)
    @objects << Rect.new(50, 50, 50, 50)
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
      Gosu.draw_rect(e.x - 5, e.y + e.w, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.h, e.y - 5, 5, 5, Gosu::Color::RED)
      Gosu.draw_rect(e.x + e.h, e.y + e.w, 5, 5, Gosu::Color::RED)
    end
  end

  def button_up(id)
    return unless id == Gosu::MS_LEFT

    if @mouse_down && @select
      @select.x = mouse_x - @mouse_down[0]
      @select.y = mouse_y - @mouse_down[1]
      @mouse_down = nil
      end
  end

  def button_down(id)
    p id
    case id
    when Gosu::MS_LEFT
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
    end
  end

  def update
    # p Gosu.button_down?(256)
  end
end
App.new.show
