class Parser
  def initialize
    @s = ""
    @p = 0
  end

  def self.call(s)
    (@@inst||=new).parse(s)
  end

  def peek
    @s[@p]||''
  end

  def advance
    @p += 1
  end

  def parse(s)
    @s = s
    @p = 0
    parse_sexp
  end

  def parse_space
    while peek=~/\s/
      advance
    end
  end

  def parse_sexp
    parse_space
    case peek
      when '('
        advance
        parse_list
      else
        parse_atom
    end
  end

  def parse_list
    xs = []
    parse_space
    while peek!=')'
      fail [@s, @p].to_s+"?" if peek.nil? || peek==''
      xs << parse_sexp
      parse_space
    end
    advance
    xs
  end

  def parse_atom
    s = ""
    while ![' ', '(', ')', '', nil].include?(c=peek)
      s << c
      advance
    end
    if s =~ /[0-9]+/
      s.to_i
    else
      s.intern
    end
  end
end


p :ok
p '1'[23]
p Parser.('123')
p Parser.('(+ 1 2 )')
p Parser.('(begin (define (f x) (if (= x 0) 0 (+ x (f (- x 1))))) (f 100))')


{
    '123' =>
        123,
    '(+ 1 (* 2 3))' =>
        [:+, 1, [:*, 2, 3]],
    '(begin (define (f x) (if (= x 0) 0 (+ x (f (- x 1))))) (f 100))' =>
        [:begin, [:define, [:f, :x], [:if, [:'=', :x, 0], 0, [:+, :x, [:f, [:-, :x, 1]]]]], [:f, 100]],
}.all? { |k, v| Parser.(k)==v } or fail
