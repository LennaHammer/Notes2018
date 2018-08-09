
blocks = open('Ruby Algo.md','r:utf-8',&:read).scan(/^(```+)ruby\b[^\n]*\n(.*?)^\1\s*$/m).map{|e|e[1]}

puts "#{blocks.size} blocks"

open('_out.rb','w:utf-8'){|out|
  blocks.each{|b|
    out.puts b
  }
}

system('ruby _out.rb')