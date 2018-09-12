

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



class GrammarParser
    def initialize(source)
        @s = source
        @p = -1
        @c = nil
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

    def match(c)
        read_char==c or fail
    end

    def skip_space
        advance while peek~=/\s/
    end

    def parse
        advance
        skip_space
        parse_expr
    end

    def parse_expr
        xs = []
        xs << parse_seq
        skip_space
        while peek=='|'
            advance
            xs << parse_seq
            skip_space
        end
        [:|, xs]
    end

    def parse_seq
        xs = []
        skip_space
        while peek!=nil && peek!='|' && peek!=')' && peek!=''
            xs << parse_quu
            skip_space
        end
        xs
    end

    def parse_quu
        x = parse_atom
        case peek
        when '*'
            advance
            [:*, x]
        when '+'
            advance
            [:+, x]
        when '?'
            advance
            [:'?', x]
        else
            x
        end
    end

    def parse_atom
        case peek
        when ?(
            parse_group
        when ?'
            parse_string
        else
            parse_ident
        end
    end

    def parse_group
        match '('
        x = expr
        match ')'
        x
    end

    def parse_ident
        s = +""
        while peek==/\w/
            s << read_char
        end
        s.intern
    end

    def parse_string
        advance # ?'
        s = +""
        while peek!=?'
            s << read_char
        end
        match ?'
        s
    end

end

p GrammarParser("abc '+' def").parse
p GrammarParser("abc '+' (def '*' ss)").parse
p GrammarParser("abc '+' def | abc '+' def | abc '+' def").parse
p GrammarParser("abc '+' def | abc '+' (def | abc '+' def)").parse



class Parser
    def initialize(grammer)
        @grammer = grammer
    end

    def parse(tokens)

    end
end


$p = Parser.new {
    main: [:expr],
    expr: [:Int,'+',:Int],
}
$p.parse [:Int,'+',:Int]