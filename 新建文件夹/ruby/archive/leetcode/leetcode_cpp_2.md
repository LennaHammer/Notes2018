# LeetCode 笔记 第二部分

从 257 题开始

到 512 题


## 解答

### 257. Binary Tree Paths

+ 二叉树，所有到叶节点的路径，深度优先搜索

```cpp
class Solution {
public:
    vector<string> binaryTreePaths(TreeNode* root) {
        vector<string> ans;
        vector<int> path;
        function<void(TreeNode*)> f = [&](TreeNode* node){
             if(!node)
                return;
             if(!node->left && !node->right){
                 stringstream s;
                 for(auto x: path)
                    s<< x << "->";
                 s << node->val;
                 ans.push_back(s.str());
                 return;
             }
             path.push_back(node->val);
             f(node->left);
             f(node->right);
             path.pop_back();
        };
        f(root);
        return ans;
    }
};
```

### 258. Add Digits

+ 数字相加，总结数学规律
+ 存在递推关系 f(x) = x>=10 ? f(x/10 + x%10) : x  

```cpp
class Solution {
public:
    int addDigits(int num) {
        return 1+(num-1)%9;
    }
};
```

263. Ugly Number

+ 因数分解

```cpp
class Solution {
public:
    bool isUgly(int num) {
        if(num<=0)
            return false;
        if(num==1)
            return true;
        while(num%2==0)
            num/=2;
        while(num%3==0)
            num/=3;
        while(num%5==0)
            num/=5;
        return num==1;
    }
};
```

### 268. Missing Number

+ 数组
+ 等差数列求和

```c
int missingNumber(int* nums, int numsSize) {
    int y = numsSize;
    for(int i=0; i<numsSize; i++)
        y += i-nums[i];
    return y;
}
```

### 283. Move Zeroes

```c
void moveZeroes(int* nums, int numsSize) {
    int s = 0;
    for(int i=0;i<numsSize;i++)
        if(nums[i]!=0)
            nums[s++] = nums[i]; 
    for(int i=s; i<numsSize; i++)
        nums[i] = 0;
}
```


### 344. Reverse String

```c++
class Solution {
public:
    string reverseString(string s) {
        int i=0, j = s.size()-1;
        while(i<j){
            swap(s[i],s[j]);
            i++, j--;
        }
        return s;
    }
};
```

### 349. Intersection of Two Arrays

+ 数组去重

```c++
class Solution {
public:
    vector<int> intersection(vector<int>& nums1, vector<int>& nums2) {
        vector<int> nums3;
        unordered_map<int,int> h;
        for(int x: nums1)
            h[x] = 1;
        for(int x: nums2)
            h[x] |= 2;
        for(auto p: h)
            if(p.second==3)
                nums3.push_back(p.first);
        return nums3;
    }
};
```

### 404. Sum of Left Leaves

+ 二叉树
```c++
class Solution {
    int f(TreeNode* node,bool isLeft){
        if(node==NULL)
            return 0;
        if(node->left==NULL && node->right==NULL)
            return isLeft ? node->val : 0;
        return f(node->left, true)+f(node->right, false);
    }
public:
    int sumOfLeftLeaves(TreeNode* root) {
        return f(root, false);
    }
};
```

### 412. Fizz Buzz

```c
/**
 * Return an array of size *returnSize.
 * Note: The returned array must be malloced, assume caller calls free().
 */
char** fizzBuzz(int n, int* returnSize) {
    char **xs = (char**)malloc(sizeof(char*)*n);
    for(int i=0;i<n;i++){
        int x = i + 1;
        if(x%3==0){
            if(x%5==0){
                xs[i] = "FizzBuzz";
            }else{
                xs[i] = "Fizz";
            }
        }else if(x%5==0){
            xs[i] = "Buzz";
        }else{
            char *s = (char*)malloc(sizeof(char)*10);
            sprintf(s,"%d",x);
            xs[i] = s;
        }
    }
    *returnSize = n;
    return xs;
}
```

```c++
class Solution {
public:
    vector<string> fizzBuzz(int n) {
        vector<string> xs;
        char *s = (char*)malloc(sizeof(char)*10);
        for(int i=0;i<n;i++){
            int x = i + 1;
            if(x%3==0){
                if(x%5==0){
                    xs.push_back("FizzBuzz");
                }else{
                    xs.push_back("Fizz");
                }
            }else if(x%5==0){
                xs.push_back("Buzz");
            }else{
                sprintf(s,"%d",x);
                xs.push_back(s);
            }
        }
        return xs;
    }
};
```

### 434. Number of Segments in a String

+ 字符串，数组
+ 状态机

```c
int countSegments(char* s) {
    int count = 0;
    bool word = false;
    for(;;){
        if(isspace(*s) || *s=='\0'){
            if(word){
                count++;
                word = false;
            }
            if(!*s)
                return count;
        }else{
            if(!word)
                word = true;
        }
        s++;
    }
}
```

### 501. Find Mode in Binary Search Tree

```cpp
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
    vector<int> result;
    int value;
    int count;
    int mode_count;
    void append_result(){
        if(count==mode_count){
            result.push_back(value);
        }else if(count>mode_count){
            result.clear();
            result.push_back(value);
            mode_count = count;
        }
    }
    void inorder(TreeNode* node){
        if(!node)
            return;
        inorder(node->left);
        if(node->val==value){
            count++;
        }else{
            append_result();
            value = node->val;
            count = 1;
        }
        inorder(node->right);
    }
public:
    vector<int> findMode(TreeNode* root) {
        count = 0;
        mode_count = 0;
        inorder(root);
        if(count)
            append_result();
        return result;
    }
};
```

### 504. Base 7

```cpp
class Solution {
public:
    string convertToBase7(int num) {
        if(num==0)
            return "0";
        stringstream sb;
        bool m = num < 0;
        unsigned x = m ? -num : num;
        while(x){
            sb << x%7;
            x /= 7;
        }
        if(m)
            sb << '-';
        auto s = sb.str();
        reverse(begin(s),end(s));
        return s;
    }
};
```

### 506. Relative Ranks


```cpp
class Solution {
public:
    vector<string> findRelativeRanks(vector<int>& nums) {
        vector<string> ranks = {"Gold Medal", "Silver Medal", "Bronze Medal"};
        ranks.resize(nums.size());
        for(int i=3;i<nums.size();i++)
            ranks[i] = to_string(i+1);
        vector<int> index(nums.size());
        iota(index.begin(),index.end(),0);
        sort(index.begin(),index.end(),[&](auto i,auto j){return nums[i]>nums[j];});
        vector<string> ret(nums.size());
        for(int i=0;i<nums.size();i++)
            swap(ret[index[i]], ranks[i]);
        return ret;
    }
};
```

### 507. Perfect Number

+ 因数分解
+ 分解全部因式会超时，稍微优化一下

```cpp
class Solution {
public:
    bool checkPerfectNumber(int num) {
        if(num==1)
            return false;
        int x = 1;
        for(int i=2,e=sqrt(num);i<=e;i++)
            if(num%i==0)
                x += i + num/i;
        return num==x;
    }
};
```

### 508. Most Frequent Subtree Sum

+ 二叉树，递归

```cpp
class Solution {
    unordered_map<int,int> count;
    int m = 0;
    int f(TreeNode* node){
        if(!node)
            return 0;
        int val = node->val + f(node->left) + f(node->right);
        m = max(m, ++count[val]);
        return val;
    }
public:
    vector<int> findFrequentTreeSum(TreeNode* root) {
        f(root);
        vector<int> result;
        for(auto x: count)
            if(x.second==m)
                result.push_back(x.first);
        return result;
    }
};
```


## Ruby

### 506. Relative Ranks

+ 排名
+ 用下标的排序

```ruby
def find_relative_ranks(nums)
    index = (0...nums.size).sort_by{|x|-nums[x]}
    xs, i = [], 0
    xs[i] = "Gold Medal" if i = index.shift
    xs[i] = "Silver Medal" if i = index.shift
    xs[i] = "Bronze Medal" if i = index.shift
    index.each.with_index(4){|i,rank|xs[i]=rank.to_s}
    xs
end
```

```ruby
Ranks = ["Gold Medal", "Silver Medal", "Bronze Medal"]
def find_relative_ranks(nums)
    index = (0...nums.size).sort_by{|x|-nums[x]}
    xs = Array.new(nums.size)
    index.each.with_index(1){|i,rank|xs[i]=rank.to_s}
    index.take(3).each_with_index{|i,j|xs[i]=Ranks[j]}
    xs
end
```

### 508. Most Frequent Subtree Sum

+ 二叉树，递归

```ruby
def find_frequent_tree_sum(root)
    h = Hash.new(0)
    f = ->(node){
        if node
            x = node.val+f.(node.left)+f.(node.right)
            h[x] += 1
            x
        else
            0
        end
    }
    f.(root)
    m = h.each_value.max
    h.select{|k,v|v==m}.map(&:first)
end
```

##

+ http://blog.csdn.net/zjucor
http://bookshadow.com/


http://www.cnblogs.com/grandyang/p/4606334.html