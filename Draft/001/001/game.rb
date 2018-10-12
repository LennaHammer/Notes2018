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

  def self.draw_handlers(e, active=true)
    color = active ? Gosu::Color::RED : Gosu::Color::GRAY
    x, y, w, h = e.x, e.y, e.w, e.h
    # SIDE
    Gosu.draw_rect(x+(w - 5)/2, y - 5, 5, 5, color) # TOP
    Gosu.draw_rect(x+(w - 5)/2, y + h, 5, 5, color) # BOTTOM
    Gosu.draw_rect(x - 5, y + (h - 5)/2, 5, 5, color) # Left
    Gosu.draw_rect(x + w, y + (h-5)/2, 5, 5, color) # RIGHT
    # CONER
    Gosu.draw_rect(x - 5, y - 5, 5, 5, color)
    Gosu.draw_rect(x - 5, y + h, 5, 5, color)
    Gosu.draw_rect(x + w, y - 5, 5, 5, color)
    Gosu.draw_rect(x + w, y + h, 5, 5, color)
  end

  def self.handlers(point, rect)
    px, py = point
    x, y, w, h = rect.x, rect.y, rect.w, rect.h
    case
      when Utils.in?([px, py], [x+(w - 5)/2, y - 5, 5, 5])
        [1, 0, 0, 0] # top
      when Utils.in?([px, py], [x+(w - 5)/2, y + h, 5, 5])
        [0, 1, 0, 0] # bottom
      when Utils.in?([px, py], [x - 5, y + (h - 5)/2, 5, 5])
        [0, 0, 1, 0] # left
      when Utils.in?([px, py], [x + w, y + (h-5)/2, 5, 5])
        [0, 0, 0, 1] # right
      when Utils.in?([px, py], [x - 5, y - 5, 5, 5])
        [1, 0, 1, 0] # left top
      when Utils.in?([px, py], [x - 5, y + h, 5, 5])
        [0, 1, 1, 0] # right top
      when Utils.in?([px, py], [x + w, y - 5, 5, 5])
        [1, 0, 0, 1] # left bottom
      when Utils.in?([px, py], [x + w, y + h, 5, 5])
        [0, 1, 0, 1] # right bottom
      else
        nil
    end
  end

  def self.rect_two_points(x1, y1, x2, y2)
    x = [x1, x2].min
    y = [y1, y2].min
    w = (x1 - x2).abs
    h = (y1 - y2).abs
    [x, y, w, h]
  end
end


class App < Gosu::Window
  def initialize
    super 320*2, 240*2
    self.caption = 'Canvas 画布'
    @status_bar = Gosu::Image.from_text('Design Mode', 16)

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

    ## update

    if @dragging # && @selection
      if @selection
        @selection.x = mouse_x - @dragging[0]
        @selection.y = mouse_y - @dragging[1]
      else
        @selections.each do |e|
          e.x += mouse_x - @moving[0]
          e.y += mouse_y - @moving[1]
        end
      end
      @moving = [mouse_x, mouse_y]
    end
    if @resizing
      px, py = @resizing_point
      @selection.resize([mouse_x-px, mouse_y-py], @resizing)
      @resizing_point = [mouse_x, mouse_y]
    end


    ## DRAW
    ## 开始按顺序绘图

    Gosu.draw_rect(0, 0, width, height, Gosu::Color::BLACK)

    @status_bar.draw(0, 0, 0, 1, 1, Gosu::Color::WHITE)

    if !@selections.empty?
      @selections.each do |e|
        Utils.draw_handlers(e, false)
      end
    end

    @objects.each(&:draw) # 绘制

    if (e = @selection)
      Utils.draw_handlers(e, true)
    end

    if @mouse_down2
      x, y = @mouse_down2
      Gosu.draw_rect(x, y, mouse_x-x, mouse_y-y, Gosu::Color.rgba(255, 255, 255, 32))
    end

    if @drawing_start
      x, y = @drawing_start
      Gosu.draw_rect(x, y, mouse_x-x, mouse_y-y, Gosu::Color.rgba(0, 255, 255, 32))
    end

  end

  def button_up(id)
    if id == Gosu::MS_LEFT

      if @dragging # && @selection
        if @selection
          @selection.x = mouse_x - @dragging[0]
          @selection.y = mouse_y - @dragging[1]
        end
        @selections.each do |e|
          #e.x = mouse_x - @dragging[0]
          #e.y = mouse_y - @dragging[1]
        end
        @dragging = nil
        @moving = nil
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
        w = (mouse_x - @mouse_down2[0]).abs
        h = (mouse_y - @mouse_down2[1]).abs
        rect = Rect.new(x, y, w, h)
        @selections.clear
        @objects.each do |e|
          if Utils.rect_intersect?(e, rect)
            @selections << e
          end
        end
        p @selections
        if @selections.size==1
          @selection = @selections.first
          @selections.clear
        end
        @mouse_down2 = nil
      end

      if @drawing_start
        x, y, w, h=Utils.rect_two_points(*@drawing_start, mouse_x, mouse_y)
        w, h = 50, 20 if w<5 && h<5
        @objects << Rect.new(x, y, w, h)
        @selection = @objects.last
        @selections.clear
        @drawing_mode = false
        @drawing_start = nil
      end

    end
  end

  def button_down(id)
    p id
    case id
      when Gosu::MS_LEFT # 鼠标按下

        # 插入大小
        if @drawing_mode
          @drawing_start = [mouse_x, mouse_y]
          return
        end

        # 改变大小
        if @selection
          px, py = mouse_x, mouse_y
          @resizing = Utils.handlers([px, py], @selection)
          if @resizing
            @resizing_point = [px, py]
            return
          end
        end

        # 单选或开始拖动
        @selection = nil
        @objects.reverse_each do |e|
          if e.contain?(mouse_x, mouse_y)
            if !@selections.include?(e)
              @selections.clear
              @selection = e
            end
            @dragging = [mouse_x - e.x, mouse_y - e.y]
            @moving = [mouse_x, mouse_y]
            return # break
          end
          self
        end

        # 开始框选
        @selections.clear
        @mouse_down2 = [mouse_x, mouse_y]

      when Gosu::KB_LEFT
        @selection.x -= 5 if @selection
      when Gosu::KB_RIGHT
        @selection.x += 5 if @selection
      when Gosu::KB_DOWN
        @selection.y += 5 if @selection
      when Gosu::KB_UP
        @selection.y -= 5 if @selection
      when 9 # 'f'
        @objects << Rect.new(50, 50, 150, 50)
        @selection = @objects.last unless @dragging
      when 4 #'a'
        @drawing_mode = true
      else
    end
  end

  def update
    # p Gosu.button_down?(256)
  end
end
App.new.show

# 参考 PythonCard