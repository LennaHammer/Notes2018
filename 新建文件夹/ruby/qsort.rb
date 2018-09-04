# 快速排序

def _partition(xs, a, b)
  pvt = xs[b]
  s = a
  for i in a...b
    if xs[i] < pvt
      xs[s], xs[i] = xs[i], xs[s]
      s += 1
    end
  end
  xs[s], xs[b] = xs[b], xs[s]
  s
end

def _quicksort(xs, a, b)
  return unless a < b
  c = _partition(xs, a, b)
  _quicksort(xs, a, c-1)
  _quicksort(xs, c+1, b)
end

def qsort(xs)
  _quicksort(xs, 0, xs.size-1)
  nil
end

1000.times.all?{
  x = ((-5..10).to_a*3).sample(rand(0..10)).shuffle
  qsort(x)
  x == x.sort
} or fail

$xs = []#.shuffle
$xs = ((-10..10).to_a*3).sample(rand(0..10)).shuffle
qsort($xs)
p $xs



