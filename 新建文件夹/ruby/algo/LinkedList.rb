


class LinkedList
  Node = Struct.new(:value, :next)
  def initialize
  	@head = nil
  end
  def push(value)
    @head = Node.new(value, @head)
  end
  def each
  	node = @head
  	while node
  	  yield node.value
  	  node = node.next
  	end 	
  end
  def length
  	n = 0
  	node = @head
  	while node
  	  n += 1
  	  node = node.next
  	end
    n
  end
  def reverse
  	prev = nil
  	node = @head 
  	while node
  		succ = node.next 
        node.next = prev
  		prev = node
  		node = succ
  	end
  	@head = prev
  end
  def to_a
  	a = []
  	each{|x|a<<x}
    a
  end
  def self.from_array(a)
    list = self.new
    a.reverse_each do |e|
      list.push e
    end
    list
  end
end


def main
  x = LinkedList.new
  x.push 1
  x.push 2
  p x.length
  p x.to_a
  p LinkedList.from_array([1,2,3,4,5]).to_a
end

main