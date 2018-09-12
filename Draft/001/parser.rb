# 参考 yacc
# 参考 https://github.com/python/cpython/blob/2064bb6d576ff7016d59318038779f428b0f0f3f/Grammar/Grammar
# 参考 ocamlyacc http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual026.html

# 记号
# xxx : qqq '+' qqq | '-' ;
# | 或者
# [] 零次或一次
# () 括号
# ()+ ()* ()? 出现次数

# 规则 LL(1) 预读一个 token 判断，只回退一个，否则报错

require 'pp'

class GrammarParser
  def initialize(source)
    p source
    @grammer = nil
    @s = source
    @p = -1
    @c = nil
  end

  def self.parse(source)
    new(source).parse_rules
  end

  def inspect
    @grammer.inspect
  end


  def peek
    # p @s[@p]
    @s[@p]
  end

  def advance
    @p += 1
  end

  def read_char
    c = peek
    advance
    c
  end

  def match_token(c)
    (read_char == c) || raise
    skip_space
  end

  def skip_space # 用在 token 结束
    advance while peek =~ /\s/
  end

  def parse
    advance
    skip_space
    parse_expr
  end

  def parse_rules
    advance
    skip_space
    xs = {}
    until peek.nil?
      puts "> parsing: #{@s[@p..-1].inspect}"
      k = parse_ident_token
      puts "> k = #{k}"
      skip_space
      match_token ':'
      #p peek
      v = parse_expr
      puts "> v = #{v}"
      skip_space
      match_token ';'
      xs[k] = v
      p xs
    end
    xs
  end

  def parse_expr
    xs = []
    xs << parse_seq
    skip_space
    while peek == '|'
      match_token '|'
      #advance
      #skip_space
      xs << parse_seq
      skip_space
    end
    if xs.size != 1
      [:|, *xs]
    else
      xs[0]
    end
  end

  def parse_seq
    xs = []
    skip_space
    while !peek.nil? && peek != '|' && peek != ')' && peek != '' && peek != ';' #?
      xs << parse_quu
      skip_space
    end
    xs.size == 1 ? xs[0] : [:&, *xs]
  end

  def parse_quu
    x = parse_atom
    case peek
    when '*'
      advance
      skip_space
      [:*, x]
    when '+'
      advance
      skip_space
      [:+, x]
    when '?'
      advance
      skip_space
      [:'?', x]
    else
      x
    end
  end

  def parse_atom
    case peek
    when '('
      parse_group
    when "'"
      parse_string_token
    else
      parse_ident_token
    end
  end

  def parse_group
    match_token '('
    x = parse_expr
    match_token ')'
    x
  end

  def parse_ident_token
    # fail
    s = +''
    while peek =~ /\w/
      s << read_char
      # p s
    end
    skip_space
    # fail ">#{s} #{@p}"
    s.intern
  end

  def parse_string_token
    advance # ?'
    s = +''
    s << read_char while peek != "'"
    match_token "'"
    skip_space
    s
  end
end

p GrammarParser.new("abc").parse
p GrammarParser.new("'for'").parse
p GrammarParser.new("abc '+' def").parse
p GrammarParser.new("abc '+' (def '*' ss)").parse
p GrammarParser.new("abc '+' def | abc '+' def | abc '+' def").parse
p GrammarParser.new("abc '+' def | abc '+' (def | abc '+' def)+").parse
p GrammarParser.new("factor (('*'|'/') factor)*").parse

pp $g=GrammarParser.parse("
  arith_expr: term (('+'|'-') term)*;
  term: factor (('*'|'/') factor)*;
  factor: ('+'|'-') factor | power;
  power: atom ('**' factor)?;
  atom: '(' arith ')' | NUMBER;
  ")

  {:arith_expr=>[:&, :term, [:*, [:&, [:|, "+", "-"], :term]]],
    :term=>[:&, :factor, [:*, [:&, [:|, "*", "/"], :factor]]],
    :factor=>[:|, [:&, [:|, "+", "-"], :factor], :power],
    :power=>[:&, :atom, [:"?", [:&, "**", :factor]]],
    :atom=>[:|, [:&, "(", :arith, ")"], :NUMBER]}

class Parser
  def initialize(grammer)
    @rules = grammer
    @tokens = []
  end

  def parse(tokens); 
    @tokens = tokens
  end

  def type
    @token[0][1]
  end

  def value
    @token[0][0]
  end

  def parse_rule(rule)
    case rule
    when String
      if rule==value
        [type, value]
      else
        nil
      end
    when Symbol
      if rule.to_s[0].upcase?
        type==rule ? [type, value]
      else
        parse_rules(@rules[rule])
      end
    when Array
      case rule[0]
      when :&
        # 第一个返回 false 第二个 raise
        for e in rule[1..-1]
          parse_rule e
        end
      when :|
      when :*
      when :+
      when :'?'
      end
    else
      fail
    end

  end
end

$p = Parser.new($g)

$p.parse [:Int, '+', :Int]
