# 二分查找


def bsearch(xs,x)
  a = 0
  b = xs.size - 1 # 右边界包含
  while a <= b
    c = (a+b)/2
    e = xs[c]
    if x==e
      return c
    elsif x<e
      b = b - 1
    else
      a = a + 1
    end
  end
  -1
end

p bsearch([1,2,3,4,5],1)
p bsearch([1,2,3,4,5],4)
p bsearch([1,2,3,4,5],4.3)