# LeetCode Python

挑选一些喜欢的题目，涵盖不同的数据结构和算法

### 1. Two Sum

数组 哈希表

```python
class Solution:
    def twoSum(self, nums, target):
        h = {}
        for i,x in enumerate(nums):
            if x in h:
                return h[x], i
            h[target-x] = i
```

### 2. Add Two Numbers

链表 大数

链表遍历 循环
链表尾差 头节点
大数加法 进位

```python
class Solution:
    def addTwoNumbers(self, l1, l2):
        l3 = l = ListNode(None)
        c = 0
        while l1 or l2 or c:
            if l1:
                c += l1.val
                l1 = l1.next
            if l2:
                c += l2.val
                l2 = l2.next
            l3.next = ListNode(c%10)
            l3 = l3.next
            c //= 10
        return l.next
```

### 3. Longest Substring Without Repeating Characters

数组 动态规划

```python
class Solution:
    def lengthOfLongestSubstring(self, s):
        h, m, i = {}, 0, -1
        for j, x in enumerate(s):
            i = max(i, h.get(x, -1))
            m = max(m, j-i)
            h[x] = j
        return m
```

## 33. Search in Rotated Sorted Array

二分查找


## 34. Search for a Range

二分查找

```python
class Solution(object):
    def lower_bound(self, nums, target):
        a, b = 0, len(nums)
        while a < b:
            c = (a+b)//2
            if nums[c]<target:
                a = c + 1
            else:
                b = c
        return b
    def upper_bound(self, nums, target):
        a, b = 0, len(nums)
        while a < b:
            c = (a+b)//2
            if nums[c]<=target:
                a = c + 1
            else:
                b = c
        return a-1
    def searchRange(self, nums, target):
        a = self.lower_bound(nums,target)
        b = self.upper_bound(nums,target)
        return [a, b] if a<=b else [-1, -1]

```


### 506. Relative Ranks

排序

```python
class Solution:
    Ranks = ["Gold Medal", "Silver Medal", "Bronze Medal"]
    def findRelativeRanks(self, nums):
        index = sorted(range(len(nums)),key=lambda x:nums[x],reverse=True)
        xs = [None]*len(nums)
        for k, v in enumerate(index,1):
            xs[v] = str(k)
        for k, v in enumerate(index[:3]):
            xs[v] = self.Ranks[k]
        return xs
```