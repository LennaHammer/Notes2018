
blocks = open('Ruby Algo.md','r:utf-8',&:read).scan(/```ruby\s*\n(.+?)\n```/m)

out = open('_out.rb','w:utf-8') 
blocks.each{|b|
  out.puts b
}
out.close

system('ruby _out.rb')