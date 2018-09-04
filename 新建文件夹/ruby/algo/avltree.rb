class AVLTREE

  Node = Struct.new(:key, :value, :left, :right, :height)

  def initialize
    @root = nil
    p :avl_tree
  end

  def each
    stack = []
    node = @root
    while node || !stack.empty?
      while node
        stack.push(node)
        node = node.left
      end
      node = stack.pop
      yield node.key, node.value
      node = node.right
    end
  end

  def inspect
    f = ->(node){node ? "(#{f[node.left]} #{node.key} #{f[node.right]})" : ''}
    f[@root]
  end

  def size
    f = ->(node){node ? 1+f[node.left]+f[node.right] : 0}
    f[@root]
  end

  def [](key)
    node = @root
    while true
      if node.nil?
        return nil
      elsif key==node.key
        return node.value
      elsif key<node.key
        node = node.left
      else
        node = node.right
      end
    end
  end

  def []=(key, value)
    @root = insert(@root, key, value)
  end

  private

  def make_node(key, value)
    Node.new(key, value, nil, nil, 1)
  end
  
  def insert(node, key, value)
    if node.nil?
      make_node(key, value)
    elsif key == node.key
      node.value = value
      node
    elsif key < node.key
      node.left = insert(node.left, key, value)
      if height(node.left) - height(node.right) == 2
        if height(node.left.left) < height(node.left.right)
          node.left = left_rotate(node.left)
        end
        right_rotate(node)
      else
        update_height(node)
        node
      end
    else
      node.right = insert(node.right, key, value)
      if height(node.right) - height(node.left) == 2
        if height(node.right.left) > height(node.right.right)
          node.right = right_rotate(node.right)
        end
        left_rotate(node)
      else
        update_height(node)
        node
      end
    end
  end

  def height(node)
    node ? node.height : 0
  end

  def update_height(node)
    f = ->(node){node ? node.height : 0}
    node.height = [f[node.left], f[node.right]].max + 1
  end
  
  def left_rotate(node)
    right = node.right
    node.right = right.left
    right.left = node
    update_height(node)
    update_height(right)
    right
  end
  
  def right_rotate(node)
    left = node.left
    node.left = left.right
    left.right = node
    update_height(node)
    update_height(left)
    left
  end
end


$t = AVLTREE.new
[1,4,6,2,1,7,4].each_with_index do |x,i|
  $t[x] = i
end
p $t
p $t.size

def test_1(seq)
  t = AVLTREE.new
  seq.each do |i|
    t[i] = i
  end
  p t
  p t.size
  p t.to_enum.to_a
end
test_1(1..2)
test_1(1..6)
test_1([1,2,3,4].shuffle)


# https://www.cnblogs.com/grandyang/p/4297300.html



# def put(key, value)
#   if @root.nil?
#     @root = Node.new(key, value)
#     return
#   end
#   node = @root
#   while true
#     if key==node.key
#       node.value = value
#       return
#     elsif key<node.key
#       if node.left
#         node = node.left
#       else
#         new_node = Node.new(key,value)
#         node.left = new_node
#         return
#       end
#     else
#       if node.right
#         node = node.right
#       else
#         new_node = Node.new(key, value)
#         node.right = new_node
#         return
#       end
#     end
#   end
# end