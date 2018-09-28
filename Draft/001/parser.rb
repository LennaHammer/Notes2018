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

class Grammar
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

  def parse_line
    advance
    skip_space
    parse_expr
  end

  def parse_rules
    advance
    skip_space
    xs = {}
    until peek.nil?
      # puts "> parsing: #{@s[@p..-1].inspect}"
      k = parse_ident_token
      # puts "> k = #{k}"
      skip_space
      match_token ':'
      # p peek
      v = parse_expr
      # puts "> v = #{v}"
      skip_space
      match_token ';'
      xs[k] = v
      # p xs
    end
    xs
  end

  def parse_expr
    xs = []
    xs << parse_capture # parse_seq
    skip_space
    while peek == '|'
      match_token '|'
      # advance
      # skip_space
      xs << parse_capture # parse_seq
      skip_space
    end
    if xs.size != 1
      [:|, *xs]
    else
      xs[0]
    end
  end

  def parse_capture
    seq = parse_seq
    if peek == '{'
      match_token '{'
      name = parse_ident_token
      match_token '}'
      [:'@', seq, name]
    else
      seq
    end
  end

  def parse_seq
    xs = []
    skip_space
    while peek =~ /[\(\w']/ # !peek.nil? && peek != '|' && peek != ')' && peek != '' && peek != ';' && peek != '{' #保留字? peek=~/[\(\w']/
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

Grammar.new('abc').parse_line==:abc or fail
p Grammar.new("'for'").parse_line
p Grammar.new("abc '+' def").parse_line
p Grammar.new("abc '+' (def '*' ss)").parse_line
p Grammar.new("abc '+' def | abc '+' def | abc '+' def").parse_line
p Grammar.new("abc '+' def | abc '+' (def | abc '+' def)+").parse_line
p Grammar.new("factor (('*'|'/') factor)*").parse_line
p Grammar.new("factor (('*'|'/') factor)* {callback}").parse_line

pp $g = Grammar.parse("
  expr: term (('+'|'-') term)*;
  term: factor (('*'|'/') factor)*;
  factor: ('+'|'-') factor | power;
  power: atom ('**' factor)?;
  atom: '(' expr ')' | NUMBER;
  ")

$g == {
  :expr=>[:&, :term, [:*, [:&, [:|, "+", "-"], :term]]],
  :term=>[:&, :factor, [:*, [:&, [:|, "*", "/"], :factor]]],
  :factor=>[:|, [:&, [:|, "+", "-"], :factor], :power],
  :power=>[:&, :atom, [:"?", [:&, "**", :factor]]],
  :atom=>[:|, [:&, "(", :expr, ")"], :NUMBER]
} or fail

class Parser
  def initialize(grammer, actions = {})
    @rules = grammer
    @top = nil
    @tokens = []
    # @stack = []
    @actions = actions
  end

  def parse(tokens)
    @tokens = tokens
    puts format('> %s', (tokens.map { |x| x[1] } * ' '))
    parse_rule(@rules[:expr])
  end

  def token
    { type: @tokens[0][1], value: @tokens[0][0] } unless @tokens.empty?
  end

  def token_type
    return nil if @tokens.empty?

    @tokens[0][1] #.intern
  end

  def token_value
    return nil if @tokens.empty?

    @tokens[0][0]
  end

  def shift
    t = token
    @tokens.shift
    t
    # "#{t[:data]}"
  end

  def error(message)
    raise Exception, message
  end

  #
  # 不消耗 token 匹配失败时 返回 nil
  # 不消耗 token 量词为空时 返回 []
  # 消耗 token 回退失败时 raise 异常
  # 返回 nil | Exception | [] | token | token list
  #
  def parse_rule(rule)
    # puts "] #{rule}, #{@tokens}"
    case rule
    when String
      rule == token_type.to_s ? shift : nil # token_value
    when Symbol
      if rule.to_s[0] =~ /^[A-Z]/
        rule == token_type ? shift : nil
      else
        if x = parse_rule(@rules[rule])
          # {type: rule, children: x}
          if action = @actions[rule]
            action.call(x)
          elsif x.is_a?(Array) && x.flatten.size == 1
            x.flatten[0]
          else
            x
          end
        else
          nil
        end
      end
    when Array
      case rule[0]
      when :&
        xs = []
        # 第一个失败 false 第二个 raise
        # 不消耗 token 返回 nil 否则 raise
        count = 0
        for i in 1...rule.size
          x = parse_rule rule[i]
          if x == []
            xs << x
          elsif x
            xs << x
            count += 1
          elsif count == 0 # 不匹配且无法回溯
            return nil
          else
            raise '&'
          end
        end
        xs
      when :|
        for i in 1...rule.size
          if x = parse_rule(rule[i])
            return x # {type: sum, enum: i-1, data: x}
          end
        end
        # raise "| #{rule} #{@tokens}"
        nil
      when :*
        xs = []
        while x = parse_rule(rule[1])
          xs << x
        end
        xs # 不消耗 token 时返回 []
      when :+
        raise :not_impl
      when :'?'
        xs = []
        if x = parse_rule(rule[1])
          xs << x
        end
        xs
      when :'@'
        name = rule[2]
        if x = parse_rule(rule[1])
          if action = @actions[name]
            action.call(x)
          else
            x
          end
        else
          nil
        end
      else
        raise rule.inspect
      end
    else
      raise rule.inspect
    end
  end
end

$p = Parser.new($g)

pp $p.parse [1, '+', 2].zip([:NUMBER, '+', :NUMBER])
pp $p.parse [1, '+', 2, '+', 3].zip([:NUMBER, '+', :NUMBER, '+', :NUMBER])
pp $p.parse [1, '+', 2, '*', 3].zip([:NUMBER, '+', :NUMBER, '*', :NUMBER])
pp $p.parse ['(', 1, '+', 2, ')', '*', 3].zip(['(', :NUMBER, '+', :NUMBER, ')', '*', :NUMBER])


class Calc
  def initialize
    grammer = Grammar.parse("
      expr: term (('+'|'-') term)* {infix};
      term: factor (('*'|'/') factor)* {infix};
      factor: ('+'|'-') factor {prefix} | atom;
      atom: '(' expr ')' {group} | NUMBER;
    ")
    
    
    actions = {
    group: lambda { |e|
               e[1]
             },
    infix: lambda { |e|
             puts "bin> #{e}"
             x = e[0][:value]
             while item = e[1].shift
               op = item[0][:value]
               y = item[1][:value]
               case op
               when '+'
                 x += y
               when '-'
                 x -= y
               when '*'
                 x *= y
               when '/'
                 x /= y
               else
                 raise op
               end
             end
             # puts "return> #{x}"
             { type: :NUMBER, value: x }
           },
    prefix: lambda {|e|
          x = e[1][:value]
          case e[0]
          when '+'
            { type: :NUMBER, value:  x}
          when '-'
            { type: :NUMBER, value: -x }
          else
            fail e
          end
          },
    }
    $p = @parser = Parser.new(grammer, actions)
    
    pp $p.parse [1, '+', 2].zip([:NUMBER, '+', :NUMBER])
    pp $p.parse [1, '+', 2, '+', 3].zip([:NUMBER, '+', :NUMBER, '+', :NUMBER])
    pp $p.parse [1, '+', 2, '*', 3].zip([:NUMBER, '+', :NUMBER, '*', :NUMBER])
    pp $p.parse ['(', 1, '+', 2, ')', '*', 3].zip(['(', :NUMBER, '+', :NUMBER, ')', '*', :NUMBER])
    @tokenize = Tokenize.new({
      /\d+/ => ->(lit){[lit.to_f, :NUMBER]},
      %r'[()*/+-]' => ->(lit){[lit, lit.intern]}
    })
  end
  def eval(string)
    @parser.parse(@tokenize.(string))[:value]
  end

end

#calc = Calc.new

#p calc.eval("1+1")

class Tokenize
  def initialize(lex)
    id = 'a'
    @actions = {}
    @pattern = Regexp.union(*lex.map{|k,v|
      pat = /(?<#{id}>#{k})/
      @actions[id] = v
      id = id.succ 
      pat
    })
    #@actons = actions || Hash.new{|h,k|h[k]=->(lit){[lit,k]}}
  end
  def call(string)
    ys = []
    string.scan(@pattern){
      tag = @pattern.names.find{|e|$~[e]}
      lit = $~[0]
      #p [@actions,tag]
      ys << @actions[tag][lit]
    }
    ys
  end
end

def tokenize(string)
  ys = []
  rule = {
    NUMBER: /\d+/,
    OP: %r'[()*/+-]',
  }
  # /(?<foo>.)(?<foo>.)/
  pat = Regexp.union(*rule.map{|k,v|/(?<#{k}>#{v})/})
  
  string.scan(pat){
    tag = pat.names.find{|e|$~[e]}
    lit = $~[0]
    ys << [lit, tag]#{type:tag, value:$~[0]}
  }
  ys
end

p tokenize("1+(2+-3)*4")
p tokenize("111+222")

t = Tokenize.new({
  /\d+/ => ->(lit){[lit, :NUMBER]},
  %r'[()*/+-]' => ->(lit){[lit, lit.intern]}
})

t.call("1+(2+-3)*4")==[["1", :NUMBER], ["+", :+], ["(", :"("], ["2", :NUMBER], ["+", :+], ["-", :-], ["3", :NUMBER], [")", :")"], ["*", :*], ["4", :NUMBER]] or fail
t.call("111+222")==[["111", :NUMBER], ["+", :+], ["222", :NUMBER]] or fail


calc = Calc.new

p calc.eval("1+1")