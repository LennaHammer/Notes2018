

graph1 = {
  1 => [1,3,6],
  2 => [4,2],
  4 => [5],
  5 => [6,2],
  6 => [2]
}

def bfs(graph, start)
  queue = [start]
  closed = {start=>true}
  while x = queue.shift
    yield x
    graph[x]&.each do |v|
      next if closed[v]
      queue << v
      closed[v] = true
    end
  end
end


bfs(graph1, 1){|x|puts x}