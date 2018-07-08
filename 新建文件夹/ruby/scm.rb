class Parser
  def initialize(code)
    @buf = code
    @pos = 0
  end

  private

  def get
    x = @buf[@pos]
    @pos += 1
    x
  end

  def unget
    @pos -= 1
  end

  def space
    while true
      case get
        when ' ', "\n", "\t"
          next
        else
          unget
          return
      end
    end
  end

  def atom
    x = ''
    while true
      c = get
      case c
        when ' ', "\n", ')', nil
          unget
          return x.to_i if x =~ /[0-9]+/
          return x.intern
        else
          x << c
      end
    end
  end

  def string
    x = ''
    while true
      case c=get
        when nil
          raise
        when '"'
          return x
        else
          x << c
      end
    end
  end

  def list
    x = []
    while true
      space
      case get
        when ')'
          return x
        else
          unget
          x << expr
      end
    end
  end

  def expr
    case get
      when nil
        nil
      when '('
        list
      when '"'
        string
      else
        unget
        atom
    end
  end

  public

  def eval
    space
    expr
  end

  def self.parse(code)
    self.new(code).eval
  end
end


class Interp
  class Env
    attr_accessor :parent, :binding

    def initialize(parent = nil)
      @parent = parent
      @binding = Hash.new
    end

    def [](key)
      if @binding.include? key
        @binding[key]
      elsif @parent
        @parent[key]
      else
        raise "var #{key} ?"
      end
    end

    def []=(key, value)
      raise NotImplementedError
    end

    def define(key, value)
      binding[key] = value
    end
  end

  Closure = Struct.new :arg, :body, :env
  Continuation = Struct.new :cont


  def eval_apply(nodes, env, cont)
    n = nodes.size
    argv = Array.new(n.pred)
    loop = ->(i) {
      if i.zero?
        eval nodes[0], env, ->(x) {
          case x
            when Closure
              eval_closure x, argv, env, cont
            when Continuation
              [x.cont, argv[0]]
            else
              [cont, x.call(*argv)]
          end
        }
      else
        eval nodes[i], env, ->(x) {
          argv[i-1] = x
          loop.(i.pred)
        }
      end
    }
    loop.(n.pred)
  end

  def eval_begin(nodes, env, cont)
    last = nodes.size.pred
    loop = ->(i) {
      if i==last
        eval nodes[i], env, cont
      else
        eval nodes[i], env, ->(x) {
          loop.(i.succ)
        }
      end
    }
    loop.(1)
  end

  def eval_closure(closure, argv, env, cont)
    new_env = Env.new closure.env
    new_env.binding = Hash[closure.arg.zip(argv)]
    eval closure.body, new_env, cont
  end

  def eval(node, env, cont)
    if node.is_a? Array
      case node.first
        when :define
          eval node[2], env, ->(x) {
            raise unless node[1].is_a? Symbol
            env.define(node[1], x)
            [cont, nil]
          }
        when :if
          eval node[1], env, ->(x) {
            if x
              eval node[2], env, cont
            else
              eval node[3], env, cont
            end
          }
        when :begin
          eval_begin node, env, cont
        when :lambda
          [cont, Closure.new(node[1], node[2], env)]
        when :'call/cc'
          eval node[1], env, ->(x) {
            eval_closure x, [Continuation.new(cont)], env, cont
          }
        when :'dynamic-wind'
          raise NotImplementedError
        else
          eval_apply node, env, cont
      end
    else
      if node.is_a? Symbol
        [cont, env[node]]
      else
        [cont, node]
      end
    end
  end

  def run(node, env)
    cont, value = eval node, env, ->(x) { [nil, x] }
    while cont
      cont, value = cont[value]
    end
    value
  end

  def self.eval(code)
    i = self.new
    tree = Parser.parse code
    i.run tree, TopLevel
  end
end

class Compiler

end

e = Parser.new("   (+ 1 2 (+ 3 4 5))")
p e.eval
p Parser.parse %{
  (+ "1" 2 3 a a)
}
TopLevel = Interp::Env.new
TopLevel.define :+, ->(x, y) {
  x + y
}
TopLevel.define :-, ->(x, y) {
  x - y
}
TopLevel.define :<, ->(x, y) {
  x < y
}
TopLevel.define :zero?, ->(x) {
  x.zero?
}
TopLevel.define :display, ->(x) {
  print x
}
p Interp.eval "(+ 1 (- 2 3))"
p Interp.eval "(if (< 6 2) 3 4)"
p Interp.eval "(begin (define x 1) (+ x 2))"
p Parser.parse "(call/cc (lambda (k) (k 2)))"
p Interp.eval "(+ 2 (call/cc (lambda (k) (begin 3 (k 4) 5))))"
p Interp.eval %{
  (begin
  (define f (lambda (x y)
  (if (zero? x) y (f (- x 1) (+ x y)))))
  (f 100 0))
}
p :ok

$tests = {
    "(+ 1 (- 2 3))" => 0,
    "(if (< 6 2) 3 4)" => 4,
    "(begin (define x 1) (+ x 2))" => 3,
    "(+ 2 (call/cc (lambda (k) (begin 3 (k 4) 5))))" => 6,
    %{
      (begin
      (define f (lambda (x y)
      (if (zero? x) y (f (- x 1) (+ x y)))))
      (f 100 0))
    } => 5050,
}

p $tests.all? { |x, y| Interp.eval(x)==y }