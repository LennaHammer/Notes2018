sum = 0
for i in 1..100
  sum += i
end
puts sum

class VM
  def initialize(code)
    @code = code
    @pc = 0
    @stack = []
    @memory = Array.new(10, 0)
  end
  def run
    while @pc<@code.size
      x = @code[@pc]
      @pc += 1
      case x
      when Array
        case x[0]
        when :call
        when :goto
          @pc = x[1]
        when :label
        when :branch
          if !@stack.pop
            @pc += x[1]
          end
        when :load
          @stack.push @memory[x[1]]
        when :store
          @memory[x[1]] = @stack.pop
        end
      when Integer
        @stack.push x
      when :==
      when :+
        b = @stack.pop
        a = @stack.pop
        @stack.push(a+b)
      when :-
        b = @stack.pop
        a = @stack.pop
        @stack.push(a-b)
      when :*
        b = @stack.pop
        a = @stack.pop
        @stack.push(a*b)
      when :/
        b = @stack.pop
        a = @stack.pop
        @stack.push(a/b)
      else
        fail
      end
    end
  end
end




code = [1,2,:+,3,:*]
$vm = VM.new(code)
$vm.run
p $vm
code2 = [1,2,3,:+,:+,2,:<,:branch,3,1,2,:+,:goto,:end,123,:+,:end]




class ThreadPool
  def initialize(size)
    @pool = Array.new(size){Thread.new{}}
  end
  def execute(&blk)
    
  end
  def pmap(xs,&blk)

  end
end

#p ThreadPool.new(2)