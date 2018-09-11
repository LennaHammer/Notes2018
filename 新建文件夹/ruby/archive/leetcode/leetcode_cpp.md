
# LeetCode 刷题随手记 - 第一部分

账户：LennaHammer

前 256 题（非会员），仅算法题，的吐槽

https://leetcode.com/problemset/algorithms/

## 说明

**刷题指南**

+ 不要背题，前面的基本题型需要熟悉
+ 不要刷太多题
+ 前面的基本题型需要熟悉
+ 记模版

> 背题很容易忘，而且题目有具体的要求，还总会有新的题目。
> 模板，比如大数、回溯、图的深度优先搜索、动态规划。
> 一次刷一定量的题，方便类比和补遗。对照课本上的知识点。
> 总之，为了解决题目，不是单独扯道理。


**关于 LeetCode**

+ 是针对白板编程设计的题目
+ 手写，
+ 测试
+ AC 

+ LeetCode 的题目还都是基础题，白板编程的，自己写测试
+ AC 仍可能不对
+ 不 AC 不一定错，比如 LeetCode 改题目了
+ AC
  + 对特殊值处理可能不对
  + 与题目中对实现方式的要求不一致

+ Leetcode 没有对异常输入的处理
+ 有些课本上的知识点目前的有没有涵盖到的
+ 而且仅算法题的涵盖也有点窄
+ 不要在题目的范围和已有的题目上限制
  + 其他方面的基础知识，未知的题目的分析方法

每道题选择一个标签，为了按方法分类

+ 题后的标签用来按解法归类
  + 只指定一个类别，

比如 Array+DP 的

按题号排列，从学习的角度，归类更好。
  
## 解答

使用 C/C++，按题号顺序。

分类学习。


### 1. Two Sum

+ 哈希表，O(N)
+ 或者先排序再查找，如果不是返回下标

要点
1. 数组遍历：用 for 循环，可以求和，最大值，最大值的下标，元素是否存在。
2. 双指针：同向，可以两头，可以嵌套。可以快慢，先后，收缩。

```cpp
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int,int> h;
        for(int i=0;;i++){
            int x = nums[i];
            if(h.count(x))
                return {h[x],i};
            h[target-x] = i;
        }
    }
};
```

### 2. Add Two Numbers

+ 链表，遍历和尾插
+ 大数，加法

要点
1. 大数：用一个整数表示大数中一位（或几位），计算加法时产生进位。 
2. 链表：和数组都是基础的容器。链表是递归的结构，可以递归遍历，尾递归写成循环。可以直接头部插入或尾部插入（记录最后节点）。为处理空链表方便，可以通过额外的头节点。

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode* list = NULL;
        ListNode** p = &list;
        int s = 0;
        while(l1 || l2 || s){
            if(l1){
                s+ = l1->val;
                l1 = l1->next;
            }
            if(l2){
                s+ = l2->val;
                l2 = l2->next;
            }
            *p = new ListNode(s%10);
            p = &(*p)->next;
            s /= 10;
        }
        return list;
    }
};
```


### 3. Longest Substring Without Repeating Characters

+ 数组
+ 动态规划
+ O(N)

要点
1. 双指针：一个向前一步，另一个根据条件收缩。该题在遍历时记录最大值。


```cpp
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        int y = 0;
        int b[128] = {0};
        int l = 0;
        for(int i=0;i<s.size();i++){
            char c = s[i];
            l = max(l,b[c]);
            y = max(y,i-l+1);
            b[c] = i+1;
        }
        return y;
    }
};
```

```cpp
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        int y = 0;
        vector<int> b(128, -1);
        int a = -1;
        for(int i=0;i<s.size();i++){
            char c = s[i];
            a = max(a,b[c]);
            y = max(y,i-a);
            b[c] = i;
        }
        return y;
    }
};
```

### 4. Median of Two Sorted Arrays

双数组的查找，找中位数。

+ 挺有趣的一道题！
+ 算总长度，分奇偶
+ 转化为求第 k 个值。
  + 从 0 开始是，从 1 开始。
+ 有个相关的题
  + Find the k-th Smallest Element in the Union of Two Sorted Arrays
  + http://articles.leetcode.com/find-k-th-smallest-element-in-union-of/

要点
1. 双有序数组：搜索时，可以归并为一个数组执行查找，也可以直接在双数组上查找。

```cpp
class Solution {
    double find(vector<int>& A, vector<int>& B, int k){
        int a = 0, b = 0;
        for(;;){
            if(k==0){
                if(!(b<B.size()) || (a<A.size() && A[a]<B[b]))
                    return A[a];
                else
                    return B[b];
            }
            int c = (k-1)/2;
            if(!(b+c<B.size()) || (a+c<A.size() && A[a+c]<=B[b+c])){
                a += c+1;
                k -= c+1;
            }else{
                b += c+1;
                k -= c+1;
            }
            
        }
    }
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        int length = nums1.size() + nums2.size();
        if(length%2)
            return find(nums1,nums2,length/2);
        else
            return (find(nums1,nums2,length/2-1)+find(nums1,nums2,length/2))/2.0;
    }
};
```

```c
double find(int* nums1, int nums1Size, int* nums2, int nums2Size, int k){
    for(;;){
        if(nums1Size>nums2Size){
            int* nums3 = nums2;
            nums2 = nums1;
            nums1 = nums3;
            nums1Size = nums1Size^nums2Size;
            nums2Size = nums1Size^nums2Size;
            nums1Size = nums1Size^nums2Size;
        }else if(nums1Size==0){
            return nums2[k-1];
        }else if(k==1){
            return nums1[0]<nums2[0] ? nums1[0] : nums2[0];
        }else{
            int k1 = k/2 < nums1Size ? k/2 : nums1Size;
            int k2 = k - k1;
            if(nums1[k1-1]==nums2[k2-1]){
                return nums1[k1-1];
            }else if(nums1[k1-1]<nums2[k2-1]){
                nums1 += k1;
                nums1Size -= k1;
                k -= k1;
            }else{
                nums2 += k2;
                nums2Size -= k2;
                k -= k2;
            }
        }
    }
}
double findMedianSortedArrays(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    int length = nums1Size + nums2Size;
    double med = find(nums1, nums1Size, nums2, nums2Size, length/2+1);
    if(length%2==0)
        med = (med+find(nums1, nums1Size, nums2, nums2Size, length/2))/2;
    return med;
}
```

### 5. Longest Palindromic Substring

+ 动态规划，后面回文子串的题目还会用到
  + 从前往后，计算前缀，或者从后往前，计算后缀都可以
+ 这题也有别的更好的方法。

```cpp
class Solution {
public:
    string longestPalindrome(string s) {
        int len = 0, start;
        int n = s.size();
        auto f = [&](int j, int k){
            while(j>=0 && k<n && s[j]==s[k]){
                j--, k++;
            }
            if(k-j-1>len){
                len = k-j-1;
                start = j+1;
            }
        };
        for(int i=0; i<n; i++){
            f(i, i);
            f(i, i+1);
        }
        return s.substr(start, len);
    }
};
```



```cpp
class Solution {
public:
    string longestPalindrome(string s) {
        int len = 0, start;
        int n = s.size();
        bool d[n][n];
        memset(d, 0, sizeof(bool)*(n*n));
        for(int i=0; i<n; i++){
            for(int j=0;j<=i; j++){
                d[j][i] = s[j]==s[i] && (i-j<3 ||d[j+1][i-1]);
                if(d[j][i] && (i-j+1) > len){
                    len = i - j + 1;
                    start = j;
                }
                
            }
        }
        return s.substr(start, len);
    }
};
```



### 6. ZigZag Conversion

+ 存在下标周期性映射关系
+ 分析 r=1,2,3,4,5 的情况

```cpp
class Solution {
public:
    string convert(string s, int numRows) {
        if(numRows==1)
            return s;
        int d = 2*numRows-2;
        string y;
        for(int i=0; i<numRows; i++){
            for(int j=i; j<s.size(); j+=d){
                y.push_back(s[j]);
                if(i!=0 && i!=numRows-1){
                    int k = j+d-i*2;
                    if(k < s.size()){
                        y.push_back(s[k]);
                    }
                }
            }
        }
        return y;
    }
};

// numRows = 5
// 0     8         16
// 1   7 9      15 17
// 2  6  10   14
// 3 5   11 13
// 4     12

// 0   4
// 1 3 5 7
// 2   6

// 0 2
// 1 3

// 0 1 2 3
```


### 7. Reverse Integer

> Integer

+ 32位补码表示有符号整数
+ 符号不变，转换结果可能会溢出

> 要点
> 1. 十进制：用取模和整数除法，可以得到最低位和余下的高位。
> 2. 整型溢出：运算后超出表示范围，可以在运算前，或者运算后检查


```cpp
class Solution {
public:
    int reverse(int x) {
        int a = x>0 ? INT_MAX : INT_MIN;
        int b = a/10, c = a%10;
        int y = 0;
        for(;x>=10 || x<=-10; x /= 10)
            y = y*10 + x%10;
        if(x>0)
            return y<b || (y==b && x<=c) ? y*10+x : 0;
        else
            return y>b || (y==b && x>=c) ? y*10+x : 0;
    }
};
```

```cpp
class Solution {
public:
    int reverse(int x) {
        int a = x>=0 ? INT_MAX : INT_MIN;
        int b = a/10, c = a%10;
        int y = 0;
        if(x>=0){
            for(;x>=10; x /= 10)
                y = y*10 + x%10;
            return y<b || (y==b && x<=c) ? y*10+x : 0;
        }else{
            for(;x<=-10; x /= 10)
                y = y*10 + x%10;
            return y>b || (y==b && x>=c) ? y*10+x : 0;
        }
    }
};
```

这道题 LeetCode 的 Blog 上的解法挺不错的

### 8. String to Integer (atoi)

+ 字符串转整数，实现 C 语言的字符串类库函数
+ 可以用 `7. Reverse Integer` 用到的溢出的判断方法
  + 区分处理正负补码的表示范围

```c
int myAtoi(char* str) {
    while(isspace(*str))
        str++;
    int neg = 0;
    switch(*str){
        case '-':
            neg = 1;
        case '+':
            str++;
            break;
    }
    if(!isdigit(*str))
        return 0;
    int a, b;
    if(!neg)
        a = INT_MAX/10, b = INT_MAX%10;
    else
        a = -(INT_MIN/10), b = -(INT_MIN%10);
    int value = 0;
    while(isdigit(*str)){
        int digit = *str-'0';
        if(value>a || (value==a && digit>b))
            return neg ? INT_MIN : INT_MAX;
        value = value*10 + digit;
        str++;
    }
    return neg ? -value : value;
}
```
  
### 9. Palindrome Number

+ 逐对比较
+ 十进制自然数运算
取最高位和最低位

```cpp
class Solution {
public:
    bool isPalindrome(int x) {
        if(x<0)
            return false;
        int c = 1;
        while(x/c>=10)
            c *= 10;
        while(x){
            if((x/c)!=(x%10))
                return false;
            x = (x%c)/10;
            c /= 100;
        }
        return true;
    }
};
```

### 10. Regular Expression Matching

+ 递归/回溯处理字符串后缀
+ 注意各种情况的组合

```cpp
class Solution {
    bool _isMatch(const char* s, const char* p) {
        if(*p==0){
            return *s==0;
        }else if(*(p+1)=='*'){
            if(*s==0)
                return _isMatch(s, p+2);
            else if(*s==*p || *p=='.')
                return _isMatch(s+1, p) || _isMatch(s, p+2);
            else
                return _isMatch(s, p+2);
        }else{
            if(*s==0)
                return false;
            if(*s==*p || *p=='.')
                return _isMatch(s+1, p+1);
            else
                return false;
        }
    }    
public:
    bool isMatch(string s, string p) {
        return _isMatch(s.c_str(), p.c_str());
    }
};
```

### 11. Container With Most Water

+ 数组，动态规划，双指针
+ 能装最多的水
+ 双指针，从两头，次高往最高收缩

```c
class Solution {
public:
    int maxArea(vector<int>& height) {
        int i = 0, j = height.size()-1;
        int m = 0;
        while(i<j){
            m = max(m, min(height[i],height[j])*(j-i));
            if(height[i] < height[j])
                i++;
            else
                j--;
        }
        return m;
    }
};
```

### 12. Integer to Roman

+ 罗马数字转换，输入为 1 到 3999

```cpp
class Solution {
public:
    string intToRoman(int num) {
        int integers[13] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
        char* romans[13] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
        string sb;
        for(int i=0; i<13; i++){
            for(int j=num/integers[i]; j--;)
                sb += romans[i];
            num %= integers[i];
        }
        return sb;
    }
};
```


### 13. Roman to Integer

+ 罗马数字转换

```c
int romanToInt(char* s) {
    int integers[13] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
    char* romans[13] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
    int result = 0;
    for(int i=0; i<13; i++){
        while(!memcmp(s, romans[i], strlen(romans[i]))){
            result += integers[i];
            s += strlen(romans[i]);            
        }
    }
    return result;
}
```

### 14. Longest Common Prefix

+ 字符串比较，公共前缀
直接按题意实现即可

```c
char* longestCommonPrefix(char** strs, int strsSize) {
    char *result;
    if(strsSize==0){
        result = (char*)malloc(sizeof(char));
        result[0] = 0;
        return result;
    }
    int count = 0;
    for(;;){
        char ch = strs[0][count];
        if(ch==0)
            break;
        for(int j=1; j<strsSize; j++)
            if(strs[j][count]!=ch)
                goto end_for;
        count++;
    }
    end_for:
    result = (char*)malloc(sizeof(char)*(count+1));
    memcpy(result,strs[0],sizeof(char)*count);
    result[count] = 0;
    return result;
}
```

### 15. 3Sum

+ 排序然后查找
  + 这题有重复元素，比如 `[-1, -1, 2]` ，如果最后再去重可能会超时
+ 注意 `.size()` 返回的是 unsigned，若判断 `<.size()-1` 会一直循环
或者用哈希表

```cpp
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        vector<vector<int>> result;
        sort(nums.begin(), nums.end());
        int n = nums.size();
        for(int i=0; i<n-2; i++){
            if(i!=0 && nums[i]==nums[i-1])
                continue;
            int j = i+1, k = nums.size()-1;
            while(j < k){
                int s = nums[i] + nums[j] + nums[k];
                if(s==0){
                    result.push_back({nums[i], nums[j], nums[k]});
                    j++, k--;
                }else if(s<0){
                    j++;
                }else{
                    k--;
                }
                while(j!=i+1 && nums[j]==nums[j-1])
                    j++;
                while(k!=nums.size()-1 && nums[k]==nums[k+1])
                    k--;                    
            }
        }
        return result;
    }
};
```

```cpp
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        vector<vector<int>> result;
        sort(nums.begin(), nums.end());
        int n = nums.size();
        for(int i=0; i<n-2 && nums[i]<=0; i++){
            if(i!=0 && nums[i]==nums[i-1])
                continue;
            int j = i+1, k = nums.size()-1;
            while(j < k){
                int s = nums[i] + nums[j] + nums[k];
                if(s==0){
                    result.push_back({nums[i], nums[j], nums[k]});
                    j++, k--;
                }else if(s<0){
                    j++;
                }else{
                    k--;
                }
                while(j!=i+1 && nums[j]==nums[j-1])
                    j++;
                while(k!=nums.size()-1 && nums[k]==nums[k+1])
                    k--;                    
            }
        }
        return result;
    }
};
```

### 16. 3Sum Closest

> Search

+ 先排序
+ 或者用哈希

```cpp
class Solution {
public:
    int threeSumClosest(vector<int>& nums, int target) {
        int ans = 0, d = INT_MAX;
        sort(nums.begin(), nums.end());
        if(nums.size()<3)
            return 0;
        for(int i=0; i<nums.size()-2; i++){
            if(i!=0 && nums[i]==nums[i-1])
                continue;
            int j = i+1, k = nums.size()-1;
            while(j < k){
                int s = nums[i] + nums[j] + nums[k] - target;
                if(abs(s)<d){
                    d = abs(s);
                    ans = s + target;
                }
                if(s==0){
                    j++, k--;
                }else if(s<0){
                    j++;
                }else{
                    k--;
                }
                while(j!=i+1 && nums[j]==nums[j-1])
                    j++;
                while(k!=nums.size()-1 && nums[k]==nums[k+1])
                    k--;
            }
        }
        return ans;        
    }
};
```

### 17. Letter Combinations of a Phone Number

+ 递归，回溯，排列组合

要点
回溯：

```cpp
class Solution {
public:
    vector<string> letterCombinations(string digits) {
        vector<string> result;
        if(digits.size()==0)
            return result;
        string y = digits;
        int n = digits.size();
        char b[digits.size()+1];
        b[n] = 0;
        char* s[10] = {
          "","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"  
        };
        function<void(int)> f = [&](int i){
            if(i==digits.size()){
                result.push_back(b);
            }else{
                for(char *p = s[digits[i]-'0']; *p; p++){
                    b[i] = *p;
                    f(i+1);
                }
            }
        };
        f(0);
        return result;
    }
};
```


### 18. 4Sum

```cpp
class Solution {
public:
    vector<vector<int>> fourSum(vector<int>& nums, int target) {
        vector<vector<int>> ans;
        sort(nums.begin(), nums.end());
        for(int x:nums)printf("%d ",x);puts("");
        int n = nums.size();
        for(int i=0; i<n-3; i++){
            if(i!=0 && nums[i]==nums[i-1])
                continue;
            for(int j=i+1; j<n-2; j++){
                if(j!=i+1 && nums[j]==nums[j-1])
                    continue;
                int k = j + 1, l = n-1;
                while(k<l){
                    int sum = nums[i]+nums[j]+nums[k]+nums[l];
                    if(sum==target){
                        ans.push_back({nums[i],nums[j],nums[k],nums[l]});
                        k++, l--;
                    }else if(sum<target){
                        k++;
                    }else{
                        l--;
                    }
                    while(k!=j+1 && k<l && nums[k]==nums[k-1])
                        k++;
                    while(l!=n-1 && k<l && nums[l]==nums[l+1])
                        l--;
                }
            }
        }
        return ans;
    }
};
```
### 19. Remove Nth Node From End of List

+ 链表，双指针

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* removeNthFromEnd(struct ListNode* head, int n) {
    struct ListNode* p = head;
    while(n--)
        p = p->next;
    if(p==NULL)
        return head->next;
    p = p->next;
    struct ListNode* q = head;
    while(p){
        q = q->next;
        p = p->next;
    }
    q->next = q->next->next;
    return head;
}
```

### 20. Valid Parentheses

+ 栈，先进后出
要点
stack

```c
bool isValid(char* s) {
    const char *ps = "([{)]}";
    int stack_size = 3;
    char *stack = (char*)malloc(sizeof(char)*stack_size);
    char *push = stack;
    for(char x; x=*s++;){
        char* found = strchr(ps, x);
        if(found){
            int a = found - ps;
            if(a<3){
                if(push==stack+stack_size){
                    stack = (char*)realloc(stack,sizeof(char)*(stack_size<<1));
                    push = stack + stack_size;
                    stack_size <<= 1;
                }
                *push++ = ps[a+3];
            }else{
                if(push<=stack || push[-1]!=x)
                    return false;
                push--;
            }
        }
    }
    return push==stack;
}
```



### 21. Merge Two Sorted Lists

+ 链表的节点操作
+ 有序序列的归并
要点：节点题通常会要求不改变元素，但也不一定。

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
        ListNode* head = NULL;
        ListNode** append = &head; 
        for(;;){
            if(!l1){
                *append = l2;
                break;
            }
            if(!l2){
                *append = l1;
                break;
            }
            if(l1->val<l2->val){
                *append = l1;
                l1 = l1->next;
            }else{
                *append = l2;
                l2 = l2->next;
            }
            append = &(*append)->next;
        }
        return head;
    }
};
```

### 22. Generate Parentheses

+ 递归，回溯

```cpp
class Solution {
public:
    vector<string> generateParenthesis(int n) {
        vector<string> result;
        string item(n*2, ' ');
        function<void(int,int)> f = [&](int i,int s){
            if(i==n*2){
                result.push_back(item);
                return;
            }
            if(s > 0){
                item[i] = ')';
                f(i+1, s-1);
            }
            if(s < 2*n - i){
                item[i] = '(';
                f(i+1, s+1);
            }
        };
        f(0, 0);
        return result;
    }
};
```

### 23. Merge k Sorted Lists

+ 归并排序，链表
+ 两两归并，次数

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2) {
    struct ListNode* head = NULL;
    struct ListNode** append = &head; 
    for(;;){
        if(!l1){
            *append = l2;
            break;
        }
        if(!l2){
            *append = l1;
            break;
        }
        if(l1->val<l2->val){
            *append = l1;
            l1 = l1->next;
        }else{
            *append = l2;
            l2 = l2->next;
        }
        append = &(*append)->next;
    }
    return head;
} 
struct ListNode* mergeKLists(struct ListNode** lists, int listsSize) {
    if(listsSize==0)
        return NULL;
    if(listsSize==1)
        return lists[0];
    if(listsSize==2)
        return mergeTwoLists(lists[0], lists[1]);
    return mergeTwoLists(mergeKLists(lists,listsSize/2),mergeKLists(lists+listsSize/2,listsSize-listsSize/2));
}
```

### 24. Swap Nodes in Pairs

+ 链表

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* swapPairs(ListNode* head) {
        auto list = new ListNode(-1);
        list->next = head;
        auto p = list;
        while(p->next){
            auto a = p->next;
            auto b = a->next;
            if(!b)
                break;
            auto c = b->next;
            a->next = c;
            b->next = a;
            p->next = b;
            p = a;
        }
        return list->next;
    }
};
```

### 25. Reverse Nodes in k-Group

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* reverseKGroup(ListNode* head, int k) {
        auto list = new ListNode(-1);
        list->next = head;
        auto last = list;
        for(;;){
            auto list2 = last;
            int n = k;
            while(n && last->next){
                n--;
                last = last->next;
            }
            if(n)
                break;
            ListNode* prev = last->next;
            ListNode* node = list2->next;
            for(int i=0; i<k; i++){
                auto next = node->next;
                node->next = prev;
                prev = node;
                node = next;
            }
            last = list2->next;
            list2->next = prev;
            
        }
        return list->next;
    }
};
```

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* reverseKGroup(struct ListNode* head, int k) {
    struct ListNode **append = &head;
    for(;;){
        struct ListNode **list = append;
        int n = k;
        while(n && *append){
            append = &(*append)->next;
            n--;
        }
        if(n)
            break;
        struct ListNode *prev = *append;
        struct ListNode *node = *list;
        for(int i=0; i<k; i++){
            struct ListNode *next = node->next;
            node->next = prev;
            prev = node;
            node = next;
        }
        auto append2 = &(*list)->next;        
        *list = prev;
        append = append2;
    }
    return head;
}
```

### 26. Remove Duplicates from Sorted Array

+ 去重，通过排序。

```c
int removeDuplicates(int* nums, int numsSize) {
    if(numsSize==0)
        return 0;
    int *s = nums;
    for(int i=1; i<numsSize;i++){
        if(nums[i]!=*s){
            *++s = nums[i];
        }
    }
    return s - nums + 1;
}
```

### 27. Remove Element

+ 数组
+ 双指针

```c
int removeElement(int* nums, int numsSize, int val) {
    int *s = nums;
    for(int i=0; i<numsSize; i++){
        if(nums[i]!=val)
            *s++ = nums[i];
    }
    return s - nums;
}
```

### 28. Implement strStr()

字符串查找问题
> Search

+ 库函数 strstr 实现为 O(MN) ，平时需要 O(N) 就用正则表达式生成状态机


+ KMP 算法 
  + 回溯
  + 后面的题目会用到
  + http://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm
  + http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/kmpen.htm

> 要点
> 1. 前缀：字符串头部的连续字符构成的子串。该子串可能会在字符串内重复出现。


```cpp
class Solution {
    int* built_table(string& m){
        int *T = new int[m.size()];
        T[0] = -1;
        T[1] = 0;
        for(int i=2, j=0; i<m.size(); ){
            printf("> %d \n",i);
            if(m[i-1] == m[j]){
                T[i] = j + 1;
                i++, j++;
            }else if(j>0){
                j = T[j];
            }else{
                T[i] = 0;
                i++;
            }
        }
        return T;
    }
    int search(string &s, string &m){
        if(m.size()==0)
            return 0;
        auto next = built_table(m);
        for(int i=0, j=0; i<s.size();){
            if(m[j]==s[i]){
                if(j+1==m.size()){
                    return i-j;
                }else{
                    i++, j++;
                }
            }else{
                if(next[j]!=-1){
                    j = next[j];
                }else{
                    i++;
                    j = 0;
                }
            }
        }
        return -1;
    }
public:
    int strStr(string haystack, string needle) {
        return search(haystack, needle);
    }
};
```

稍微改一下，上面的删掉，也有其他写法

```cpp
class Solution {
    int* built_table(string& m){
        int *T = new int[m.size()];
        T[0] = -1;
        T[1] = 0;
        for(int i=2, j=0; i<m.size(); ){
            if(m[i-1] == m[j]){
                T[i] = j + 1;
                i++, j++;
            }else if(j!=0){
                j = T[j];
            }else{
                T[i] = 0;
                i++;
            }
        }
        return T;
    }
    int search(string &s, string &m){
        if(m.size()==0)
            return 0;
        auto next = built_table(m);
        for(int i=0, j=0; i<s.size();){
            if(m[j]==s[i]){
                if(j+1==m.size())
                    return i-j;
                else
                    i++, j++;
            }else{
                if(j!=0)
                    j = next[j];
                else
                    i++;
            }
        }
        return -1;
    }
public:
    int strStr(string haystack, string needle) {
        return search(haystack, needle);
    }
};
```

这样也行

```c
int strStr(char* s1, char* s2) {
    int m = strlen(s2);
    if(m==0)
        return 0;
    int n = strlen(s1);
    int b[m+1];
    int i, j;
    i = 0, j = -1;
    b[i] = j;
    while(i<m){
        while(j>=0 && s2[i]!=s2[j])
            j = b[j];
        i++, j++;
        if(s2[i]==s2[j])
            b[i] = b[j];
        else
            b[i] = j;
    }
    i = j = 0;
    while(i<n){
        while(j>=0 && s1[i]!=s2[j])
            j = b[j];
        i++, j++;
        if(j==m)
            return i-j;
    }
    return -1;
}
```

```c
int strStr(char* s1, char* s2) {
    int m = strlen(s2);
    if(m==0)
        return 0;
    int n = strlen(s1);
    int b[m+1];
    int i, j;
    i = 0, j = -1;
    b[i] = j;
    while(i<m){
        while(j>=0 && s2[i]!=s2[j])
            j = b[j];
        i++, j++;
        b[i] = j;
    }
    i = j = 0;
    while(i<n){
        while(j>=0 && s1[i]!=s2[j])
            j = b[j];
        i++, j++;
        if(j==m)
            return i-j;
    }
    return -1;
}
```

### 29. Divide Two Integers

+ 整数运算，通过除法和取模

```c
int divide(int dividend, int divisor) {
	if(divisor==0)
		return INT_MAX;
    unsigned a = dividend>=0 ? dividend : -dividend;
    unsigned b = divisor>=0 ? divisor : -divisor;
    unsigned c = 0;
    int n = 0;
    for(unsigned i=b; i<a; i<<=1)
        n++;
    for(int i=n; i>=0; i--){
    	if((b<<i)<=a){ 
	        c += (1<<i);
	        a -= (b<<i);
        }
    }
    if((dividend>0 && divisor<0) || (dividend<0 && divisor>0))
        return -c;
    return c>INT_MAX ? INT_MAX : c;
}
```

### 30. Substring with Concatenation of All Words

> Array

```cpp
class Solution {
public:
    vector<int> findSubstring(string s, vector<string>& words) {
        vector<int> ans;
        unordered_map<string,int> count;
        for(auto& x: words)
            count[x]++;
        int n = words.at(0).size();
        int m = n*words.size();
        for(int i=0,e = s.size()-m+1; i<e; i++){
            unordered_map<string,int> copy(count);
            for(int j=0; j<words.size(); j++){
                auto x = s.substr(i+j*n, n);
                auto it = copy.find(x);
                if(it!=copy.end() && it->second)
                    copy[x]--;
                else
                    goto out;
            }
            ans.push_back(i);
            out:;
        }
        return ans;
    }
};
```

### 31. Next Permutation

+ 排列组合，求下一个排列
+ 函数不保存额外的状态，每次调用独立
+ 三个元素则依次为 123,132,213,231,312,321
  + 值的大小按升序排列，123 开始 321 结束
  + 每一位的值表示序号，唯一且有限个
+ 从右往左找到第一个小于右侧元素的 A
  + 这是可以增大的最低位（从右往左）
    + A 右侧一定是降序序列
  + 没找到（如 321）则逆置整个排列
  + 找到则找到比 A 大的最低位 B
    + B 一定是 A 右侧比 A 大的最小值
  + A, B 互换，低于 A 的位逆置（从降序变成升序）

> 要点
> 1. 升序：等长序列之间也可构成偏序关系。

```cpp
class Solution {
public:
    void nextPermutation(vector<int>& nums) {
        int n = nums.size();
        int l = n-1;
        while(l>0 && !(nums[l-1]<nums[l]))
            l--;
        if(l>0){
            int r = n-1;
            while(!(nums[l-1]<nums[r]))
                r--;
            swap(nums[l-1], nums[r]);
        }
        for(int r=n-1;l<r;l++,r--)
            swap(nums[l], nums[r]);
            
    }
};
```

### 32. Longest Valid Parentheses

+ 可以用动态规划来做

```cpp
class Solution {
public:
    int longestValidParentheses(string s) {
        int len = 0, start = -1;
        stack<int> st;
        for(int i=0; i<s.size(); i++){
            if(s[i]=='('){
                st.push(i);
            }else if(!st.empty()){
                st.pop();
                if(!st.empty()){
                    len = max(len, i-st.top());
                }else{
                    len = max(len, i-start);
                }
            }else{
                start = i;
            }
        }
        return len;
    }
};
```

### 33. Search in Rotated Sorted Array

> Search

+ 二分查找

```c
int search(int* A, int n, int target) {
    int a = 0, b = n;
    while(a<b){
        int c = a+(b-a)/2;
        if(A[c]==target){
            return c;
        }else if(A[a]<=A[c]){
            if(A[a]<=target && target<A[c])
                b = c;
            else
                a = c + 1;
        }else{
            if(A[c]<target && target<=A[b-1])
                a = c + 1;
            else
                b = c;
        }
    }
    return -1;
}
```

### 34. Search for a Range

> Search

+ 二分查找

```cpp
class Solution {
    int lower(vector<int>& nums, int target){
        int a = 0, b = nums.size();
        while(a<b){
            int c = (a+b)/2;
            if(nums[c]<target){
                a = c + 1;
            }else{
                b = c;
            }
        }
        return b;   
    }
    int upper(vector<int>& nums, int target){
        int a = 0, b = nums.size();
        while(a<b){
            int c = (a+b)/2;
            if(nums[c]<=target){
                a = c + 1;
            }else{
                b = c;
            }
        }
        return a-1;
    }
public:
    vector<int> searchRange(vector<int>& nums, int target) {
        int low = lower(nums,target);
        int high = upper(nums,target);
        if(low<=high)
            return {lower(nums,target), upper(nums,target)};
        else
            return {-1, -1};
    }
};
```

### 35. Search Insert Position

+ 注意右边界是否包含
  + 以及终止条件，和连续相等元素的处理

```c
int searchInsert(int* nums, int numsSize, int target) {
    int a = 0, b = numsSize;
    while(a<b){
        int c = (a+b)/2;
        if(nums[c]==target){
            return c;
        }else if(nums[c]<target){
            a = c + 1;
        }else{
            b = c;
        }
    }
    return a;
}
```

### 36. Valid Sudoku

+ 判断数独局面是否正确
三个条件

```cpp
class Solution {
public:
    bool isValidSudoku(vector<vector<char>>& board) {
        bool flag[9];
        memset(flag, 0, sizeof(bool)*9);
        for(int i=0; i<9; i++){
            for(int j=0; j<9; j++){
                if(board[i][j]=='.')
                    continue;
                if(flag[board[i][j]-'1'])
                    return false;
                flag[board[i][j]-'1'] = true;
            }
            memset(flag, 0, sizeof(bool)*9);
            for(int j=0; j<9; j++){
                if(board[j][i]=='.')
                    continue;
                if(flag[board[j][i]-'1'])
                    return false;
                flag[board[j][i]-'1'] = true;
            }
            memset(flag, 0, sizeof(bool)*9);
            for(int j=0; j<9; j++){
                int x=(i%3)*3+j%3;
                int y=(i/3)*3+j/3;
                if(board[x][y]=='.')
                    continue;
                if(flag[board[x][y]-'1'])
                    return false;
                flag[board[x][y]-'1'] = true;                
            }
            memset(flag, 0, sizeof(bool)*9);
        }
        return true;
    }
};
```


### 37. Sudoku Solver

+ 回溯
+ 有其他高效的算法

```cpp
class Solution {
public:
    void solveSudoku(vector<vector<char>>& board) {
        unsigned t[3][9] = {0};
        for(int y=0; y<9; y++)
            for(int x=0; x<9; x++){
                int z = x/3 + y/3*3;
                if(board[y][x]!='.'){
                    int b = board[y][x]-'1';
                    t[0][x] |= (1<<b);
                    t[1][y] |= (1<<b);
                    t[2][z] |= (1<<b);
                }
                 
            }
        function<bool(int)> f = [&](int k){
            if(k==81){
                return true;
            }
            int x = k%9, y = k/9;
            if(board[y][x]!='.')
                return f(k+1);
            int z = x/3 + y/3*3;
            
            for(int i=0; i<9; i++){
                if (t[0][x]&(1<<i)||t[1][y]&(1<<i)||t[2][z]&(1<<i))
                    continue;
                t[0][x] |= (1 << i);
                t[1][y] |= (1 << i);
                t[2][z] |= (1 << i);
                board[y][x] = i + '1';
                if(f(k + 1))
                    return true;;
                board[y][x] = '.';
                t[0][x] &= ~(1 << i);
                t[1][y] &= ~(1 << i);
                t[2][z] &= ~(1 << i);                
            }
            return false;
        };
        f(0);
    }
};
```


### 38. Count and Say

+ 字符串

```cpp
class Solution {
public:
    string countAndSay(int n) {
        string s("1");
        while(--n){
            string s2;
            for(auto it=s.begin(); it!=s.end();){
                char ch = *it;
                auto it2 = find_if(it, s.end(), [ch](char x){return x!=ch;});
                int count = distance(it, it2);
                s2 += '0'+count;
                s2 += ch;
                it = it2;
            }
            swap(s, s2);
        }
        return s;
    }
};
```

### 39. Combination Sum

+ 排列组合类型的问题，递归/回溯法
+ 该类某项可出现任意多次
+ 组合问题各组合升序排列

```cpp
class Solution {
public:
    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
        vector<vector<int>> result;
        int n = candidates.size();
        int sum = 0;
        vector<int> item;
        function<void(int)> loop = [&](int i){
            if(sum>target)
                return;
            if(sum==target){
                result.push_back(item);
                return;
            }
            for(int j=i;j<n;j++){
                int x = candidates[j];
                sum += x;
                item.push_back(x);
                loop(j);
                sum -= x;
                item.pop_back();
            }
        };
        loop(0);
        return result;
    }
};
```

### 40. Combination Sum II

+ 排列组合类的问题
+ 相比 `39. Combination Sum` 这题有重复元素
  + 重复元素可以用哈希表或者排序来处理

```cpp
class Solution {
public:
    vector<vector<int>> combinationSum2(vector<int>& candidates, int target) {
        vector<vector<int>> result;
        sort(begin(candidates), end(candidates));
        const int n = candidates.size();
        vector<int> item;
        function<void(int,int)> loop = [&](int i, int sum){
            if(sum==target){
                result.push_back(item);
                return;
            }
            int y = -1;
            for(int j=i; j<n; j++){
                int x = candidates[j];
                if(x==y)
                    continue;
                if(sum+x>target)
                    break;
                item.push_back(x);
                loop(j+1, sum+x);
                item.pop_back();
                y = x;
            }
        };
        loop(0, 0);
        return result;
    }
};
```

```cpp
class Solution {
public:
    vector<vector<int>> combinationSum2(vector<int>& candidates, int target) {
        vector<vector<int>> result;
        sort(begin(candidates), end(candidates));
        const int n = candidates.size();
        vector<int> item;
        function<void(int,int)> loop = [&](int i, int sum){
            if(sum==target){
                result.push_back(item);
                return;
            }
            for(int j=i; j<n; j++){
                int x = candidates[j];
                if(j!=i && x==candidates[j-1])
                    continue;
                if(sum+x>target)
                    break;
                item.push_back(x);
                loop(j+1, sum+x);
                item.pop_back();
            }
        };
        loop(0, 0);
        return result;
    }
};
```


### 41. First Missing Positive

+ 题目限制挺具体的
+ 数组排列为 `[1,2,3,...]`
  + 满足 `A[i]=i+1`
  + 不满足则 `i` 和 `A[i]-1` 交换

```cpp
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        int n = nums.size();
        for(int i=0; i<n; i++)
            while(nums[i]>0 && nums[i]<=n && nums[i]!=nums[nums[i]-1])
                swap(nums[i],nums[nums[i]-1]);
        for(int i=0; i<n; i++)
            if(nums[i]!=i+1)
                return i+1;
        return n+1;
    }
};
```

### 42. Trapping Rain Water

> Array

+ 数组，双指针（下标）

```cpp
class Solution {
public:
    int trap(vector<int>& height) {
        int i = 0, j = height.size()-1;
        int a = 0;
        int h = 0;
        while(i<j){
            if(height[i]<height[j]){
                h = max(h, height[i]);
                a += h - height[i];
                i++;
            }else{
                h = max(h, height[j]);
                a += h - height[j];
                j--;
            }
        }
        return a;
    }
};
```

### 43. Multiply Strings

> 整数

+ 大数
+ 可以 4 个十进制位一个 32 位整型

```c
char* multiply(char* num1, char* num2) {
    int n1 = strlen(num1);
    int n2 = strlen(num2);
    int n3 = n1 + n2;
    char *num3 = (char*)calloc(n3+1, sizeof(char));
    for(int i=0; i<n1; i++){
        int a = num1[n1-i-1]-'0';
        int c = 0;
        for(int j=0; j<n2; j++){
            int b = num2[n2-j-1]-'0';
            int k = n3 - i - j - 1;
            c += a*b + num3[k];
            num3[k] = c%10;
            c /= 10;
        }
        num3[n3-n2-i-1] += c;
    }
    char *p = num3;
    for(int i=0; i<n3-1; i++){
        if(*p!=0)
            break;
        p++;
    }
    for(char *q=p; q<num3+n3; q++)
        *q += '0';
    return p;
}
```

### 44. Wildcard Matching

+ 字符串搜索
+ 通配符
+ 遇到星号时，记录下位置

```cpp
class Solution {
    bool isMatch(const char* s, const char* p){
        bool star = false;
        const char *ss=s, *pp=p;
        for(;;){    
            if(*s==0){
                while(*p=='*')
                    p++;
                return *p==0;
            }else if(*p=='?'){
                if(*s==0)
                    return false;
                s++, p++;       
            }else if(*p=='*'){
                while(*++p=='*')
                    ;
                star = true;
                ss=s, pp=p;
            }else if(*p==*s){
                s++, p++;
            }else if(star){
                ss++;
                s=ss, p=pp;
            }else{
                return false;
            }
        }
    }
public:
    bool isMatch(string s, string p) {
        return isMatch(s.c_str(), p.c_str());
    }
};
```

### 45. Jump Game II

```cpp
class Solution {
public:
    int jump(vector<int>& nums) {
        int step = 0;
        int dist = 0;
        int arri = 0;
        for(int i=0; i<nums.size(); i++){
            if(i>arri){
                arri = dist;
                step += 1;
            }
            dist = max(dist , nums[i]+i);
        }
        return step;
    }
};
```

### 46. Permutations

+ 排列组合问题，求全排列
+ 递归/回溯

```cpp
class Solution {
public:
    vector<vector<int>> permute(vector<int>& nums) {
        vector<vector<int>> result;
        function<void(int)> loop = [&](int i){
            if(i==nums.size()){
                result.push_back(nums);
                return;
            }
            for(int j=i; j<nums.size(); j++){
                swap(nums[i],nums[j]);
                loop(i+1);
                swap(nums[i],nums[j]);
            }
        };
        loop(0);
        return result;
    }
};
```

### 47. Permutations II

+ 排列组合，全排列，有重复元素

```cpp
class Solution {
public:
    vector<vector<int>> permuteUnique(vector<int>& nums) {
        vector<vector<int>> result;
        if(nums.empty())
            return result;
        unordered_map<int,int> h;
        for(int x: nums)
            h[x]++;
        vector<int> item;
        function<void(int)> loop = [&](int i){
            if(i==nums.size()){
                result.push_back(item);
                return;
            }
            for(auto p: h){
                if(p.second){
                    item.push_back(p.first);
                    h[p.first]--;
                    loop(i+1);
                    h[p.first]++;
                    item.pop_back();
                }
            }
        };
        loop(0);
        return result;
    }
};
```

### 48. Rotate Image

+ 二维数组中元素交换
+ 区分尺寸奇偶
+ 也可以做两次镜像。

```cpp
class Solution {
public:
    void rotate(vector<vector<int>>& matrix) {
        int n = matrix.size();
        int s = n - 1;
        int e = n&1 ? n/2+1 : n/2;
        for(int i=0; i<e; i++)
            for(int j=0; j<n/2; j++){
                int t = matrix[i][j];
                matrix[i][j] = matrix[s-j][i];
                matrix[s-j][i] = matrix[s-i][s-j];
                matrix[s-i][s-j] = matrix[j][s-i];
                matrix[j][s-i] = t;
            }
    }
};
```

### 49. Group Anagrams

+ 实现 group 函数
可以利用哈希表或者排序，需要自行实现转化为key

```cpp
class Solution {
public:
    vector<vector<string>> groupAnagrams(vector<string>& strs) {
        unordered_map<string,vector<string>> h;
        for(auto& s:strs){
            auto k = s;
            sort(begin(k),end(k));
            h[k].push_back(s);
        }
        vector<vector<string>> xs;
        for(auto it = h.begin(); it!=h.end(); ++it){
            vector<string> x;
            for(auto& e: it->second)
                x.push_back(e);
            xs.push_back(x);
        }
        return xs;
    }
};
```


### 50. Pow(x, n)

+ 递归
+ 无符号数的位移
  + C 用操作数的类型
  + Java 里用操作符区分
+ 分奇偶
+ 有点小问题。

要点
位移：无符号位移高位补0，有符号位移补最高位。正数对应除以2。

```c
double myPow(double x, int n)
{
    int neg = n<0;
    unsigned exp = neg ? -(unsigned)n : n;
    double y = 1;
    while(exp)
    {
        if(exp&1)
            y *= x;
        x *= x;
        exp >>= 1;
    }
    return neg ? 1/y : y;
}
```


```c
class Solution {
public:
    double myPow(double x, int n) {
        printf("n: %d\n",n);
        if(n==0)
            return 1;
        if(n==-1)
            return 1/x;
        double f = myPow(x,n>>1);
        return n%2 ? f*f*x : f*f;
    }
};
```

注意 C 的整数除法是向下取整的

### 51. N-Queens

+ 八皇后
+ 求全部解
+ 回溯

```cpp
class Solution {
    vector<vector<string>> ans;
    int n;
    vector<bool> f1, f2, f3;
    vector<int> path;
    void f(int i){
        if(i==n){
            vector<string> item(n);
            for(int i=0; i<n ;i++){
                string line(n, '.');
                line[path[i]] = 'Q';
                swap(item[i], line);
            }
            ans.push_back(item);
            return;
        }
        for(int j=0; j<n; j++){
            if(f1[j] || f2[i+j] || f3[n-i+j])
                continue;
            path[i] = j;
            f1[j] = f2[i+j] = f3[n-i+j] = true;
            f(i+1);
            f1[j] = f2[i+j] = f3[n-i+j] = false;
        }
    }    
public:
    vector<vector<string>> solveNQueens(int n) {
        this->n = n;
        f1.resize(n, false);
        f2.resize(2*n+1, false);
        f3.resize(2*n+1, false);
        path.resize(n, false);
        f(0);
        return ans;
    }
};
```



### 52. N-Queens II

+ 八皇后
同上一题，返回解的个数

```cpp
class Solution {
    int count;
    int n;
    vector<bool> f1, f2, f3;
    void f(int i){
        if(i==n){
            count++;
            return;
        }
        for(int j=0; j<n; j++){
            if(f1[j] || f2[i+j] || f3[n-i+j])
                continue;
            f1[j] = f2[i+j] = f3[n-i+j] = true;
            f(i+1);
            f1[j] = f2[i+j] = f3[n-i+j] = false;
        }
    }
public:
    int totalNQueens(int n) {
        count = 0;
        this->n = n;
        f1.resize(n, false);
        f2.resize(2*n+1, false);
        f3.resize(2*n+1, false);
        f(0);
        return count;
    }
};
```

### 53. Maximum Subarray

+ 数组，动态规划
+ 挺有趣的一道题！

```cpp
class Solution {
public:
    int maxSubArray(vector<int>& nums) {
        int m = INT_MIN;
        int d = 0;
        for(int x: nums){
            d = max(d+x, x);
            m = max(m, d);
        }
        return m;
    }
};
```

### 54. Spiral Matrix

+ 按照题意实现，小心不要越界

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* spiralOrder(int** matrix, int matrixRowSize, int matrixColSize) {
    int *result = (int*)malloc(sizeof(int)*(matrixRowSize*matrixColSize));
    int *s = result;
    int left = 0, right = matrixColSize-1;
    int top = 0, bottom = matrixRowSize-1;
    for(;left<=right && top<=bottom;){
        for(int i=left; i<=right; i++)
            *s++ = matrix[top][i];
        for(int i=top+1; i<=bottom; i++)
            *s++ = matrix[i][right];
        if(top==bottom || left==right)
            break;
        for(int i=right-1; i>=left; i--)
            *s++ = matrix[bottom][i];
        for(int i=bottom-1; i>=top+1; i--)
            *s++ = matrix[i][left];
        left++, right--, top++, bottom--;
    }
    return result;
}
```


### 55. Jump Game

+ 题目要求判断是否能抵达终点

```cpp
class Solution {
public:
    bool canJump(vector<int>& nums) {
        int dist = 0;
        for(int i=0; i<=dist; i++){
            dist = max(dist, nums[i]+i);
            if(dist>=nums.size()-1)
                return true;
        }
        return false;
    }
};
```

### 56. Merge Intervals

```cpp
/**
 * Definition for an interval.
 * struct Interval {
 *     int start;
 *     int end;
 *     Interval() : start(0), end(0) {}
 *     Interval(int s, int e) : start(s), end(e) {}
 * };
 */
class Solution {
public:
    vector<Interval> merge(vector<Interval>& intervals) {
        vector<Interval> result;
        sort(begin(intervals),end(intervals),
            [](Interval& a,Interval& b){return a.start<b.start;});
        for(auto& x: intervals){
            if(result.empty())
                result.push_back(x);
            else if(x.start <= result.back().end)
                result.back().end = max(x.end, result.back().end);
            else
                result.push_back(x);
        }
        return result;
    }
};
```

### 57. Insert Interval

+ 一次移除一个元素不好。

```cpp
/**
 * Definition for an interval.
 * struct Interval {
 *     int start;
 *     int end;
 *     Interval() : start(0), end(0) {}
 *     Interval(int s, int e) : start(s), end(e) {}
 * };
 */
class Solution {
public:
    vector<Interval> insert(vector<Interval>& intervals, Interval newInterval) {
        for(auto it = intervals.begin(); it!=intervals.end();){
            if(newInterval.end < it->start){
                intervals.insert(it, newInterval);
                return intervals;
            }else if(newInterval.start <= it->end){
                newInterval.start = min(newInterval.start, it->start);
                newInterval.end = max(newInterval.end, it->end);
                it = intervals.erase(it);
            }else{
                ++it;
            }
        }
        intervals.push_back(newInterval);
        return intervals;
    }
};
```

```cpp
/**
 * Definition for an interval.
 * struct Interval {
 *     int start;
 *     int end;
 *     Interval() : start(0), end(0) {}
 *     Interval(int s, int e) : start(s), end(e) {}
 * };
 */
class Solution {
public:
    vector<Interval> insert(vector<Interval>& intervals, Interval newInterval) {
        vector<Interval> result;
        auto it=intervals.begin();
        while(it!=intervals.end()){
            if(newInterval.end < it->start){
                break;
            }else if(newInterval.start <= it->end){
                newInterval.start = min(newInterval.start, it->start);
                newInterval.end = max(newInterval.end, it->end);
            }else{
                result.push_back(*it);
            }
            ++it;
        }
        result.push_back(newInterval);
        while(it!=intervals.end()){
            result.push_back(*it);
            ++it;
        }
        return result;
    }
};
```


### 58. Length of Last Word

```cpp
class Solution {
public:
    int lengthOfLastWord(string s) {
        int y = 0;
        int count = 0;
        for(auto p = s.c_str();*p;p++){
            if(count!=0)
                y = 0;
            if(*p==' '){
                if(count!=0){
                    y = count;
                    count = 0;
                }
            }else
                count++;
        }
        return count ? count : y;
    }
};
```

### 59. Spiral Matrix II

+ 拿之前那题改一下，读变成写
+ 对照 `54. Spiral Matrix`

```c
/**
 * Return an array of arrays.
 * Note: The returned array must be malloced, assume caller calls free().
 */
int** generateMatrix(int n) {
    int **matrix = (int**)malloc(sizeof(int*)*n);
    for(int i=0; i<n ;i++)
        matrix[i] = (int*)malloc(sizeof(int)*n);
    int count = 1;
    int left = 0, right = n-1;
    int top = 0, bottom = n-1;
    for(;left<=right && top<=bottom;){
        for(int i=left; i<=right; i++)
            matrix[top][i] = count++;
        for(int i=top+1; i<=bottom; i++)
            matrix[i][right] = count++;
        if(top==bottom || left==right)
            break;
        for(int i=right-1; i>=left; i--)
            matrix[bottom][i] = count++;
        for(int i=bottom-1; i>=top+1; i--)
            matrix[i][left] = count++;
        left++, right--, top++, bottom--;
    }
    return matrix;
}
```

### 60. Permutation Sequence

排列组合

+ n 个元素有 n! 个排列，n-1 个元素有 (n-1)! 个排列
+ 取模/整数除法运算是对从 0 开始的整数

```cpp
char* getPermutation(int n, int k) {
    char *s = (char*)malloc(sizeof(char)*(n+1));
    s[n] = 0;
    for(int i=0; i<n; i++)
        s[i] = '1' + i;
    int a = 1;
    for(int i=2; i<n; i++)
        a *= i;
    k--;
    for(int i=0; k; i++){
        int j = k/a;
        char t = s[i+j];
        for(int p=i+j; p>i; p--)
            s[p] = s[p-1];
        s[i] = t;
        k %= a;
        a /= n-1-i;
    }
    return s;
}
```

### 61. Rotate List

+ 链表

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* rotateRight(ListNode* head, int k) {
        if(!head || !k)
            return head;
        ListNode** p = &head;
        int n = 0;
        while(*p){
            n++;
            p = &(*p)->next;
        }
        *p = head;
        for(int c=n-k%n; c--;)
            p = &(*p)->next;
        head = *p;
        *p = NULL;
        return head;
    }
};
```

### 62. Unique Paths


+ 排列组合
+ 动态规划

```c
int nchoosek(int n, int k){
    long long res = 1;
    for(int i=0;i<k;i++)
        res *= n-i;
    for(int i=1;i<=k;i++)
        res /= i;
    return res;
}
int uniquePaths(int m, int n) {
    return nchoosek(m+n-2, (m<n ? m : n)-1);
}
```

### 63. Unique Paths II

+ 动态规划，挺有趣的一道题

```c
int uniquePathsWithObstacles(int** obstacleGrid, int obstacleGridRowSize, int obstacleGridColSize) {
    int *d = (int*)malloc(sizeof(int)*obstacleGridColSize);
    memset(d,0,sizeof(int)*obstacleGridColSize);
    d[0] = 1 - obstacleGrid[0][0];
    for(int y=0; y<obstacleGridRowSize; y++){
        d[0] = d[0] ? 1-obstacleGrid[y][0] : 0;
        for(int x=1; x<obstacleGridColSize; x++)
            d[x] = obstacleGrid[y][x] ? 0 : (d[x-1]+d[x]);
    }
    return d[obstacleGridColSize-1];
}
```


### 64. Minimum Path Sum

+ 动态规划
+ 递推关系 `D[i][j] = grid[i][j] + min(D[i-1][j], D[i][j-1])`

```c
int minPathSum(int** grid, int gridRowSize, int gridColSize) {
    int D[gridColSize];
    D[0] = grid[0][0];
    for(int i=1; i<gridColSize; i++)
        D[i] = grid[0][i] + D[i-1];
    for(int i=1; i<gridRowSize; i++){
        D[0] += grid[i][0];
        for(int j=1; j<gridColSize; j++)
            D[j] = grid[i][j] + (D[j]<=D[j-1] ? D[j] : D[j-1]);
    }
    return D[gridColSize-1];
}
```

### 65. Valid Number

+ 状态机，正则表达式

```c
bool isNumber(char* s) {
    char* e;
    double a = strtof(s, &e);
    if(e==s)
        return false;
    while(isspace(*e))
        e++;
    return *e==0;
}
```

### 66. Plus One

+ 挺有趣的题，大数和排列组合的题目中会用到。

```cpp
class Solution {
public:
    vector<int> plusOne(vector<int>& digits) {
        for(int i=digits.size()-1; i>=0; i--){
            if(digits[i]<9){
                digits[i]++;
                return digits;
            }
            digits[i] = 0;
        }
        digits.insert(digits.begin(), 1);
        return digits;
    }
};
```

```cpp
class Solution {
public:
    vector<int> plusOne(vector<int>& digits) {
        vector<int> result(digits.size());
        int carry = 1;
        for(int i=digits.size()-1; i>=0; i--){
            int digit = digits[i] + carry;
            result[i] = digit%10;
            carry = digit/10;
        }
        if(carry)
            result.insert(result.begin(), carry);
        return result;
    }
};
```

### 67. Add Binary

+ 大数

```cpp
class Solution {
public:
    string addBinary(string a, string b) {
        string c;
        int m = a.size(), n = b.size();
        int carry = 0;
        int i = m-1, j = n-1;
        for(int k=0, e=max(m,n); k<e; k++){
            carry += i>=0 && a[i--]=='1';
            carry += j>=0 && b[j--]=='1';
            c += '0'+(carry&1);
            carry >>= 1;
        }
        if(carry)
            c += '1';
        reverse(c.begin(), c.end());
        return c;
    }
};
```

### 68. Text Justification

+ 细节略多

```cpp
class Solution {
public:
    vector<string> fullJustify(vector<string>& words, int maxWidth) {
        vector<string> ans;
        int start = 0;
        int size = 0;
        for(int i=0; i<words.size(); i++){
            string line;
            size += words[i].size();
            int c = i - start - 1;
            if(size+c>=maxWidth){
                size = words[i].size();
                int space = maxWidth;
                for(int j=start; j<i; j++)
                    space -= words[j].size();
                line += words[start++];
                if(c==0){
                    line.append(space, ' ');
                }else{
                    for(; start<i; c--){
                        int r = space/c+!!(space%c);
                        line.append(r, ' ');
                        space -= r;
                        line += words[start++];
                    }
                }
                ans.push_back(line);
            }
        }
        if(start<words.size()){
            string line;
            for(int i=start;i<words.size(); i++){
                if(!line.empty())
                    line += ' ';
                line += words[i];
            }
            line.append(maxWidth-line.size(), ' ');
            ans.push_back(line);
        }
        return ans;
    }
};
```

### 69. Sqrt(x)

+ 二分法
+ 牛顿法

```c
int mySqrt(int x) {
    int a = 1, b = x;
    while(a<=b){
        int c = (a+b)/2;
        if(c==x/c)
            return c;
        else if(c<x/c)
            a = c+1;
        else
            b = c-1;
    }
    return b;
}
```

### 70. Climbing Stairs

+ 斐波那契数列
  + 下标为台阶个数，值为路径个数
  + 满足 a_n = a_{n-1}+a_{n-2}, a_1=1, a_2=2

```c
int climbStairs(int n) {
    int a = 0, b = 1;
    while(n--){
        int c = a+b;
        a = b, b = c;
    }
    return b;
}
```

### 71. Simplify Path

+ 栈

```cpp
class Solution {
public:
    string simplifyPath(string path) {
        vector<string> stack;
        auto it = path.begin();
        while(it!=path.end()){
            ++it;
            auto end = find(it,path.end(),'/');
            string s(it, end);
            if(s==".."){
                if(!stack.empty())
                    stack.pop_back();
            }else if(!s.empty() && s!="."){
                stack.push_back(s);
            }
            it = end;
        }
        if(stack.empty())
            return "/";
        string result;
        for(auto& s: stack){
            result += "/";
            result += s;
        }
        return result;
    }
};
```

### 72. Edit Distance

> DP

+ 编辑距离
+ 动态规划，按字符
  + 相等 `d[i][j] = d[i-1][j-1]`
  + 替换 `d[i][j] = d[i-1][j-1]+1`
  + 添加 `d[i][j] = d[i][j-1]+1`
  + 删除 `d[i][j] = d[i-1][j]+1`
+ 写成递归的形式或迭代的形式

动规

```cpp
class Solution {
public:
    int minDistance(string word1, string word2) {
        vector<int> d(word2.size()+1);
        for(int i=0; i<=word2.size(); i++)
            d[i] = i;
        for(int i=1; i<=word1.size(); i++){
            int c = d[0];
            d[0] = i;
            for(int j=1; j<=word2.size() ;j++){
                int t = d[j];
                if(word1[i-1]==word2[j-1])
                    d[j] = c;
                else
                    d[j] = min(c, min(d[j-1],d[j])) + 1;
                c = t;
            }
        }
        return d[word2.size()];
    }
};
```

递归

```cpp
class Solution {
public:
    int minDistance(string word1, string word2) {
        map<pair<int,int>,int> h;
        function<int(int,int)> d = [&](int i, int j)->int{
            if(h.count({i,j}))
                return h[{i,j}];
            if(i==word1.size())
                return word2.size()-j;
            if(j==word2.size())
                return word1.size()-i;
            int a = (word1[i]==word2[j] ? 0: 1)+d(i+1, j+1);
            int b = 1 + d(i+1, j);
            int c = 1 + d(i, j+1);
            return h[{i,j}] = min(a, min(b, c));
        };
        return d(0,0);
    }
};
```

### 73. Set Matrix Zeroes

+ 为了不另开空间，第一行第一列先扫一遍，然后用来做记录。

```cpp
void setZeroes(int** matrix, int matrixRowSize, int matrixColSize) {
    int row = 1, col = 1;
    for(int i=0;i<matrixRowSize;i++)
        if(matrix[i][0]==0){
            col = 0;
            break;
        }
    for(int i=0; i<matrixColSize; i++)
        if(matrix[0][i]==0){
            row = 0;
            break;
        }
    for(int i=0;i<matrixRowSize;i++)
        for(int j=0; j<matrixColSize; j++)
            if(matrix[i][j]==0)
                matrix[i][0] = matrix[0][j] = 0;
    for(int i=1;i<matrixRowSize;i++)
        if(matrix[i][0]==0)
            for(int j=0;j<matrixColSize;j++)
                matrix[i][j] = 0;
    for(int i=1;i<matrixColSize;i++)
        if(matrix[0][i]==0)
            for(int j=0;j<matrixRowSize;j++)
                matrix[j][i] = 0;                
    if(row==0)
        for(int i=0; i<matrixColSize; i++)
            matrix[0][i] = 0;
    if(col==0)
        for(int i=0;i<matrixRowSize;i++)
            matrix[i][0] = 0;
}
```

### 74. Search a 2D Matrix

+ 二分查找
+ 这题直接按照一维就可以了。

```c
bool searchMatrix(int** matrix, int m, int n, int target) {
    int a = 0, b = m*n;
    while(a<b){
        int c = (a+b)/2;
        int mid = matrix[c/n][c%n];
        if(mid==target)
            return true;
        else if(mid<target)
            a = c + 1;
        else
            b = c;
    }
    return false;
}
```

### 75. Sort Colors

+ 题目要求不要用排序函数
+ 这道题正好只有三个元素要排序
  + 数组遍历过程中往两端插入

```cpp
class Solution {
public:
    void sortColors(vector<int>& nums) {
        int l = 0, r = nums.size()-1;
        for(int i=l; i<=r;){
            switch(nums[i]){
                case 0:
                    swap(nums[i], nums[l++]);
                case 1:
                    i++;
                    break;
                case 2:
                    swap(nums[i], nums[r--]);
                    break;
            }
        }
    }
};
```

### 76. Minimum Window Substring

+ 双指针
+ 收缩比扩展好实现

```cpp
class Solution {
public:
    string minWindow(string s, string t) {
        int start = 0;
        int size = INT_MAX;
        int h[128] = {0};
        for(char ch: t)
            h[ch]++;
        int d[128] = {0};
        int count = 0;
        for(int i=0, j=0;i<s.size(); i++){
            if(h[s[i]]){
                d[s[i]]++;
                if(d[s[i]]<=h[s[i]])
                    count++;
                if(count==t.size()){
                    while(d[s[j]]>h[s[j]] || h[s[j]]==0)
                        d[s[j++]]--;
                    if(i-j+1<size){
                        size = i-j+1;
                        start = j;
                    }
                }
            }
        }
        return size==INT_MAX ? "" : s.substr(start,size);
    }
};
```

### 77. Combinations

+ 排列组合问题，组合是全排列中升序的排列
+ 该题的序列是从 1 开始的

```cpp
class Solution {
public:
    vector<vector<int>> combine(int n, int k) {
        vector<vector<int>> result;
        vector<int> item(k);
        function<void(int,int)> loop = [&](int i, int x){
            if(i==k){
                result.push_back(item);
                return;
            }
            for(int j=x;j<=n;j++){
                item[i] = j;
                loop(i+1,j+1);
            }
        };
        loop(0, 1);
        return result;
    }
};
```

### 78. Subsets

+ 排列组合问题
+ 二进制位表示集合

```cpp
class Solution {
public:
    vector<vector<int>> subsets(vector<int>& nums) {
        vector<vector<int>> result;
        for(int i=0, n=(1<<nums.size()); i<n; i++){
            vector<int> item;
            for(int j=0; j<nums.size(); j++)
                if((i>>j)&1)
                    item.push_back(nums[j]);
            result.push_back(item);
        }
        return result;
    }
};
```

### 79. Word Search

+ 图的深度优先搜索
+ 本题中要求路径无环，矩阵按行储存

```c
bool f(char** board, int boardRowSize, int boardColSize, char* word,int x,int y,bool** visited) {
    if(*word==0)
        return true;
    if(x<0 || x>= boardColSize || y<0 || y>=boardRowSize)
        return false;
    if(visited[y][x])
        return false;
    if(board[y][x]==*word){
        visited[y][x] = true;
        bool result = (
            f(board, boardRowSize, boardColSize, word+1, x-1, y, visited)||
            f(board, boardRowSize, boardColSize, word+1, x+1, y, visited)||
            f(board, boardRowSize, boardColSize, word+1, x, y-1, visited)||
            f(board, boardRowSize, boardColSize, word+1, x, y+1, visited)
        );
        visited[y][x] = false;
        return result;
    }
    return false;
}
bool exist(char** board, int boardRowSize, int boardColSize, char* word) {
    bool **visited = (bool**)malloc(sizeof(bool*)*boardRowSize);
    for(int i=0;i<boardRowSize;i++)
        visited[i] = (bool*)calloc(1, sizeof(bool*)*boardColSize);
    for(int y=0; y<boardRowSize; y++)
        for(int x=0; x<boardColSize; x++)
            if(f(board, boardRowSize, boardColSize, word, x, y, visited))
                return true;
    return false;
}
```

### 80. Remove Duplicates from Sorted Array II

+ 有序数组，重复元素相邻

```c
int removeDuplicates(int* nums, int numsSize) {
    int *p = nums;
    int item = -1, count = 0;
    for(int i=0; i<numsSize; i++){
        if(nums[i]==item){
            if(count==2)
                continue;
            count++;
        }else{
            item = nums[i];
            count = 1;
        }
        *p++=nums[i];
    }
    return p - nums;
}
```

### 81. Search in Rotated Sorted Array II

> Search

+ 二分搜索，旋转后的有序数组
+ 比之前的题目多了：有重复元素

```c
bool search(int* A, int n, int target) {
    int a = 0, b = n;
    while(a<b){
        int c = a+(b-a)/2;
        if(A[c]==target){
            return true;
        }else if(A[a]==A[c]){
            a++;
        }else if(A[a]<A[c]){
            if(A[a]<=target && target<A[c])
                b = c;
            else
                a = c + 1;
        }else{
            if(A[c]<target && target<=A[b-1])
                a = c + 1;
            else
                b = c;
        }
    }
    return false;  
}
```

### 82. Remove Duplicates from Sorted List II

+ 链表节点操作

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* deleteDuplicates(ListNode* head) {
        ListNode** p = &head;
        while(*p){
            ListNode* q = (*p)->next; 
            if(q && q->val==(*p)->val){
                q = q->next;
                while(q && q->val==(*p)->val)
                    q = q->next;
                *p = q;
            }else
                p = &(*p)->next;
        }
        return head;
    }
};
```

### 83. Remove Duplicates from Sorted List

+ 前面有题目是数组，这次是链表。

```cpp
class Solution {
public:
    ListNode* deleteDuplicates(ListNode* head) {
        for(auto p = head; p; p = p->next){
            auto q = p->next;
            while(q && q->val==p->val)
                q = q->next;
            p->next = q;
        }
        return head;
    }
};
```

### 84. Largest Rectangle in Histogram

+ 最大矩形
+ Stack，大于则入栈，小于则合并，最后合并全部。

```cpp
class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int ans = 0;
        stack<int> s;
        heights.push_back(0);
        for(int i=0; i<heights.size();i++){
            while(!s.empty() && heights[i]<=heights[s.top()]){
                int j = s.top();
                s.pop();
                int width = s.empty() ? i : i-s.top()-1;
                ans = max(ans, heights[j]*width);
            }
            s.push(i);
        }
        return ans;
    }
};
```

### 85. Maximal Rectangle

+ 用 `84. Largest Rectangle in Histogram` 改改
+ 也可以用动态规划

```cpp
class Solution {
public:
    int maximalRectangle(vector<vector<char>>& matrix) {
        int row = matrix.size();
        if(row==0)
            return 0;
        int col = matrix[0].size();
        vector<int> heights(col+1, 0);
        int ans = 0;
        for(int y=0;y<row; y++){
            for(int x=0; x<col; x++)
                heights[x] = matrix[y][x]=='1' ? heights[x] + 1 : 0;
            stack<int> s;
            for(int i=0; i<heights.size();i++){
                while(!s.empty() && heights[i]<=heights[s.top()]){
                    int j = s.top();
                    s.pop();
                    int width = s.empty() ? i : i-s.top()-1;
                    ans = max(ans, heights[j]*width);
                }
                s.push(i);
            }
        }
        return ans;
    }
};
```

### 86. Partition List

+ 链表节点操作
+ 链表追加，可以用一个空的头节点

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
typedef struct ListNode Node;
void list_append(Node*** tail, Node* node){
    **tail = node;
    *tail = &node->next;
}
struct ListNode* partition(struct ListNode* head, int x) {
    Node* list1 = NULL;
    Node* list2 = NULL;
    Node** append1 = &list1;
    Node** append2 = &list2;
    for(; head; head=head->next)
        list_append(head->val<x ? &append1 : &append2, head);
    list_append(&append2, NULL);
    list_append(&append1, list2);
    return list1;
}
```

### 87. Scramble String

> DP

+ 动态规划

```cpp
class Solution {
public:
    bool isScramble(string s1, string s2) {
        map<tuple<int,int,int>,bool> m;
        function<bool(int,int,int)> f = [&](int a, int b, int c){
            //printf("%d %d %d\n",a,b,c);
            if(c==1)
                return s1[a]==s2[b];
            auto t = make_tuple(a, b, c);
            auto it = m.find(t);
            if(it!=m.end())
                return it->second;
            for(int i=1; i<c; i++){
                if(f(a,b,i) && f(a+i,b+i,c-i))
                    return m[t] = true;
                if(f(a,b+c-i,i) && f(a+i,b,c-i))
                    return m[t] = true;
            }
            return m[t] = false; 
        } ;
        if(s1.size()!=s2.size())
            return true;
        return f(0,0,s1.size());
    }
};
```

### 88. Merge Sorted Array

+ 有序数组归并
+ 这题是在数组中插入另一个数组

```c
void merge(int* nums1, int m, int* nums2, int n) {
    int* s = nums1 + m + n-1;
    int i = m-1, j = n-1;
    while(i>=0 && j>=0)
        *s-- = nums1[i] > nums2[j] ? nums1[i--] : nums2[j--];
    while(j>=0)
        *s-- = nums2[j--];
}
```

### 89. Gray Code

```cpp
class Solution {
public:
    vector<int> grayCode(int n) {
        vector<int> ans;
        for(int i=0,e=1<<n; i<e; i++)
            ans.push_back((i>>1)^i);
        return ans;
    }
};
```

### 90. Subsets II

+ 递归 + 回溯
  + 或者自行用栈实现
+ 先统计重复元素个数

```cpp
class Solution {
public:
    vector<vector<int>> subsetsWithDup(vector<int>& nums) {
        vector<vector<int>> result;
        unordered_map<int,int> h;
        for(int x: nums)
            h[x]++;
        vector<int> keys;
        for(auto p: h)
            keys.push_back(p.first);
        vector<int> stack;
        stack.push_back(-1);
        while(!stack.empty()){
            int n = stack.size();
            stack.back()++;
            if(stack.back()>h[keys[n-1]]){
                stack.pop_back();
            }else if(n==keys.size()){
                vector<int> item;
                for(int j=0; j<n; j++)
                    for(int k=0; k<stack[j]; k++)
                        item.push_back(keys[j]);
                result.push_back(item);
            }else{
                stack.push_back(-1);
            }
        }
        return result;
    }
};
```

### 91. Decode Ways

+ 回溯，动态规划
```cpp
class Solution {
public:
    int numDecodings(string s) {
        int a = 1, b = 1, c = 0;
        char p = 0;
        for(char ch: s){
            c = 0;
            if(ch!='0')
                c += b;
            if((p=='2'&&ch<='6')||(p=='1'))
                c += a;
            p = ch;
            a = b;
            b = c;
        }
        return c;
    }
};
```
### 92. Reverse Linked List II

+ 挺有趣的一道题
+ 在逆置链表的基础上改一下

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
    ListNode* reverse(ListNode* head){
        ListNode* prev = NULL;
        while(head){
            auto next = head->next;
            head->next = prev;
            prev = head;
            head = next;
        }
        return prev;
    }
public:
    ListNode* reverseBetween(ListNode* head, int m, int n) {
        ListNode** p = &head;
        for(int i=1; i<m; i++)
            p = &(*p)->next;
        ListNode* first = *p;
        ListNode* last = *p;
        for(int i=m; i<n; i++)
            last = last->next;
        ListNode* next = last->next;        
        last->next = NULL;
        *p = reverse(*p);
        first->next = next;
        return head;
    }
};
```

### 93. Restore IP Addresses

+ 回溯

```cpp
class Solution {
public:
    vector<string> restoreIpAddresses(string s) {
        vector<string> result;
        vector<int> path;
        function<void(int,int)> f = [&](int i, int x){
            if(i==s.size()){
                if(path.size()==4 && x==0){
                    char b[s.size()+4];
                    sprintf(b,"%d.%d.%d.%d",path[0],path[1],path[2],path[3]);
                    result.push_back(b);
                }
                return;
            }
            int y = x*10 + (s[i]-'0');
            if(y>=256)
                return;
            if(y!=0)
                f(i+1, y);
            if(path.size()<4){
                path.push_back(y);
                f(i+1, 0);
                path.pop_back();
            }
        };
        f(0, 0);
        return result;
    }
};
```

### 94. Binary Tree Inorder Traversal

+ 重点问题！
+ 二叉树中序遍历
  + LNR，根节点在左右节点之间访问
  + 对排序二叉树树得到升序序列
+ 递归，非递归
  + 先访问最左边的节点
  + 记录出栈顺序

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
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> result;
        stack<TreeNode*> s;
        TreeNode* p = root;
        while(p || !s.empty()){
            if(p){
                s.push(p);
                p = p->left;
            }else{
                p = s.top();
                s.pop();
                result.push_back(p->val);
                p = p->right;
            }
        }
        return result;
    }
};
```

### 95. Unique Binary Search Trees II

+ 挺有趣的题目

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
    vector<TreeNode*> generateTrees(int begin, int end) {
        vector<TreeNode*> result;
        if(begin==end)
            result.push_back(NULL);
        else
            for(int i=begin; i<end; i++)
                for(auto left: generateTrees(begin,i))
                    for(auto right: generateTrees(i+1, end)){
                        auto node = new TreeNode(i);
                        node->left = left;
                        node->right = right;
                        result.push_back(node);
                    }
        return result;
    }
public:
    vector<TreeNode*> generateTrees(int n) {
        if(n==0)
            return {};
        return generateTrees(1, n+1);
    }
};
```

### 96. Unique Binary Search Trees

+ 动态规划
+ 以上一题为基础
+ 选一个根节点，个数为左子树乘以右子树，然后求和

```
class Solution {
public:
    int numTrees(int n) {
        vector<int> f(n+1);
        f[0] = f[1] = 1;
        for(int i=2; i<=n; i++)
            for(int j=1; j<=i; j++)
                f[i] += f[j-1]*f[i-j];
        return f[n];
    }
};
```

### 97. Interleaving String

> DP

动态规划

```cpp
class Solution {
public:
    bool isInterleave(string s1, string s2, string s3) {
        int l1 = s1.size();
        int l2 = s2.size();
        int l3 = s3.size();
        if(l1+l2!=l3)
            return false;
        vector<bool> d(l1+1);
        d[0] = true;
        for(int i=0; i<l1; i++)
            d[i+1] = d[i] && s1[i]==s3[i];
        for(int i=0; i<l2; i++){
            d[0] = d[0] && s2[i]==s3[i];
            for(int j=0; j<l1; j++){
                char c = s3[i+j+1];
                d[j+1] = (d[j] && s1[j]==c) || (d[j+1] && s2[i]==c);
            }
        }
        return d[l1];
    }
};
```


### 98. Validate Binary Search Tree

+ 检查是否为二叉搜索树
  + 节点满足大小升序关系
+ 二叉树中序遍历
  + 递归，非递归实现

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
    int *prev;
    bool f(TreeNode* node){
        if(!node)
            return true;
        if(!f(node->left))
            return false;
        if(prev && *prev>=node->val)
            return false;
        prev = &node->val;
        if(!f(node->right))
            return false;
        return true;
    }
public:
    bool isValidBST(TreeNode* root) {
        prev = NULL;
        return f(root);
    }
};
```

### 99. Recover Binary Search Tree

+ 二叉树搜索树中序遍历得到升序序列
+ 用递归不符合题目 O(1) 空间的目标

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
    TreeNode* prev = NULL;
    TreeNode* broken = NULL;
    TreeNode* broken2 = NULL;
    bool f(TreeNode* node){
        if(!node)
            return false;
        if(f(node->left))
            return true;
        if(prev && prev->val>node->val){
            if(broken==NULL){
                broken = prev;
                broken2 = node;
            }else{
                broken2 = node;
                return true;
            }
        }
        prev = node;
        if(f(node->right))
            return true;
        return false;
    }
public:
    void recoverTree(TreeNode* root) {
        f(root);
        swap(broken->val, broken2->val);
    }
};
```

### 100. Same Tree

+ 二叉树
+ 递归遍历

```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
bool isSameTree(struct TreeNode* p, struct TreeNode* q) {
    if(p && q)
        return (
            p->val == q->val && 
            isSameTree(p->left, q->left) &&
            isSameTree(p->right, q->right)
        );
    else
        return p==NULL && q==NULL;
}
```

### 101. Symmetric Tree

+ 题目要求两种解法


递归

```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
 
bool isMirror(struct TreeNode* t1, struct TreeNode* t2){
    if(!t1 && !t2)
        return true;
    if(!t1 || !t2)
        return false;
    if(t1->val!=t2->val)
        return false;
    return isMirror(t1->left, t2->right) && isMirror(t1->right, t2->left);
}
bool isSymmetric(struct TreeNode* root) {
    return root ? isMirror(root->left, root->right) : true;
}
```

迭代

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
public:
    bool isSymmetric(TreeNode* root) {
        if(!root)
            return true;
        stack<TreeNode*> q;
        q.push(root->left);
        q.push(root->right);
        while(!q.empty()){
            auto a = q.top();
            q.pop();
            auto b = q.top();
            q.pop();
            if(!a && !b)
                continue;
            if(!a || !b)
                return false;
            if(a->val!=b->val)
                return false;
            q.push(a->left);
            q.push(b->right);
            q.push(b->left);
            q.push(a->right);
        }
        return true;
    }
};
```

这题 LeetCode 目前给的答案不太好

### 102. Binary Tree Level Order Traversal

+ 二叉树层次遍历
+ 队列，广度优先

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
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> result;
        vector<int> line;
        queue<TreeNode*> q;
        q.push(root);
        q.push(NULL);
        for(;;){
            TreeNode* node = q.front();
            q.pop();
            if(node){
                line.push_back(node->val);
                if(node->left)
                    q.push(node->left);
                if(node->right)
                    q.push(node->right);
            }else{
                if(line.empty())
                    break;
                result.push_back(line);
                line.clear();
                q.push(NULL);
            }
        }
        return result;
    }
};
```

### 103. Binary Tree Zigzag Level Order Traversal

+ 二叉树层次遍历

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
public:
    vector<vector<int>> zigzagLevelOrder(TreeNode* root) {
        vector<vector<int>> result;
        queue<TreeNode*> q;
        bool r = false;
        if(root)
            q.push(root);
        while(!q.empty()){
            vector<int> item;
            int n = q.size();
            while(n--){
                auto node = q.front();
                q.pop();
                item.push_back(node->val);
                if(node->left)
                    q.push(node->left);
                if(node->right)
                    q.push(node->right);
            }
            if(r)
                reverse(item.begin(), item.end());
            result.push_back(item);
            r = !r;
        }
        return result;
    }
};
```

### 104. Maximum Depth of Binary Tree

+ 二叉树遍历

```cpp
class Solution {
public:
    int maxDepth(TreeNode* root) {
        if(root==NULL)
            return 0;
        return 1 + max(maxDepth(root->left),maxDepth(root->right));        
    }
};
```

### 105. Construct Binary Tree from Preorder and Inorder Traversal

+ 二叉树遍历，逆
+ 递归

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
public:
    TreeNode* buildTree(vector<int>& preorder, vector<int>& inorder) {
        function<TreeNode*(int,int,int)> build = [&](int i, int j, int n)->TreeNode*{
            if(n==0)
                return nullptr;
            int val = preorder[i];
            int left_size = find(inorder.begin()+j,inorder.end(),val)-inorder.begin()-j;
            int right_size = n-left_size-1;
            cout<<val<<left_size<<right_size<<endl;
            auto node = new TreeNode(val);
            node->left = build(i+1, j, left_size);
            node->right = build(i+left_size+1, j+left_size+1, right_size);
            return node;
        };
        return build(0,0, preorder.size());
    }
};
```

### 106. Construct Binary Tree from Inorder and Postorder Traversal

+ 同上

```c
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
int find(int *xs, int x){
    for(int i=0;;i++)
        if(xs[i]==x)
            return i;
}
struct TreeNode *build(int *inorder,int *postorder,int n){
    if(n==0)
        return NULL;
    int value = postorder[n-1];
    int left_length = find(inorder, value);
    int right_length = n - left_length - 1;
    struct TreeNode *node = (struct TreeNode*)malloc(sizeof(struct TreeNode));
    node->val = value;
    node->left = build(inorder, postorder, left_length);
    node->right = build(inorder+left_length+1, postorder+left_length, right_length);
    return node;
}
struct TreeNode* buildTree(int* inorder, int inorderSize, int* postorder, int postorderSize) {
    return build(inorder, postorder, inorderSize);
}
```

### 107. Binary Tree Level Order Traversal II

+ 二叉树
+ 广度优先搜索，层次遍历
+ 这题要求输出逆序

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
public:
    vector<vector<int>> levelOrderBottom(TreeNode* root) {
        vector<vector<int>> result;
        queue<TreeNode*> q;
        if(root)
            q.push(root);
        while(!q.empty()){
            int n = q.size();
            vector<int> item;
            while(n--){
                auto node = q.front();
                q.pop();
                item.push_back(node->val);
                if(node->left)
                    q.push(node->left);
                if(node->right)
                    q.push(node->right);
            }
            result.push_back(item);
        }
        reverse(result.begin(), result.end());
        return result;
    }
};
```

### 108. Convert Sorted Array to Binary Search Tree

+ 二分搜索
+ 递归，构建搜索树

```cpp
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
struct TreeNode* sortedArrayToBST(int* nums, int numsSize) {
    if(numsSize==0)
        return NULL;
    typedef struct TreeNode Node;
    Node* node = (Node*)malloc(sizeof(Node));
    node->val = nums[numsSize/2];
    node->left = sortedArrayToBST(nums, numsSize/2);
    node->right = sortedArrayToBST(nums+numsSize/2+1, numsSize-numsSize/2-1);
    return node;
}
```

### 109. Convert Sorted List to Binary Search Tree

+ 递归
+ 按中序遍历从有序序列中取元素

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
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
    TreeNode* f(ListNode** node, int a, int b){
        if(a>=b)
            return NULL;
        int c = a+(b-a)/2;
        auto tree_node = new TreeNode(-1);
        tree_node->left = f(node, a, c);
        tree_node->val = (*node)->val;
        *node = (*node)->next;
        tree_node->right = f(node, c+1, b);
        return tree_node;
    }
public:
    TreeNode* sortedListToBST(ListNode* head) {
        int n = 0;
        for(auto p=head; p; p=p->next)
            n++;
        return f(&head, 0, n);
    }
};
```

### 110. Balanced Binary Tree

+ 递归+短路

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
    bool isBalanced(TreeNode* root, int* depth) {
        if(!root){
            *depth = 0;
            return true;
        }
        int left_depth, right_depth;
        if(!isBalanced(root->left, &left_depth))
            return false;
        if(!isBalanced(root->right, &right_depth))
            return false;
        if(abs(left_depth-right_depth)>1)
            return false;
        *depth = max(left_depth, right_depth)+1;
        return true;
    }    
public:
    bool isBalanced(TreeNode* root) {
        int depth;
        return isBalanced(root, &depth);
    }
};
```

### 111. Minimum Depth of Binary Tree

+ 二叉树
+ 递归

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
public:
    int minDepth(TreeNode* root) {
        if(root==nullptr)
            return 0;
        if(root->left==nullptr)
            return minDepth(root->right)+1;
        if(root->right==nullptr)
            return minDepth(root->left)+1;
        return min(minDepth(root->left), minDepth(root->right)) + 1;
    }
};
```

### 112. Path Sum

+ 二叉树，短路

```cpp
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */
bool hasPathSum(struct TreeNode* root, int sum) {
    if(!root)
        return false;
    sum -= root->val;
    if(!root->left && !root->right)
        return sum==0;
    return hasPathSum(root->left, sum) || hasPathSum(root->right, sum);
}
```

### 113. Path Sum II

+ 二叉树，叶节点，路径

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
public:
    vector<vector<int>> pathSum(TreeNode* root, int sum) {
        vector<vector<int>> result;
        vector<int> path;
        function<void(TreeNode*,int)> f = [&](TreeNode* node,int sum){
            if(!node)
                return;
            sum -= node->val;
            path.push_back(node->val);
            if(!node->left && !node->right){
                if(sum==0)
                    result.push_back(path);
            }else{
                f(node->left, sum);
                f(node->right, sum);
            }
            path.pop_back();
        };
        f(root, sum);
        return result;
    }
};
```

### 114. Flatten Binary Tree to Linked List

> Tree

+ 先序

```
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
    TreeNode* f(TreeNode* node,TreeNode* tail){
        if(!node)
            return tail;
        node->right = f(node->left, f(node->right, tail));
        node->left = NULL;
        return node;
    }
public:
    void flatten(TreeNode* root) {
        f(root, NULL);
    }
};
```

### 115. Distinct Subsequences

+ 动态规划
+ 返回子序列个数
  + 递归前缀的部分

```cpp
class Solution {
public:
    int numDistinct(string s, string t) {
        vector<int> d(t.size()+1, 0);
        d[0] = 1;
        for(int i=0; i<s.size(); i++)
            for(int j=t.size(); j>0; j--)
                if(s[i]==t[j-1])
                    d[j] += d[j-1];
        return d[t.size()];
    }
};
```

### 116. Populating Next Right Pointers in Each Node

+ 这题的输入限定为满二叉树（最后一层也是满的的完全二叉树）。
+ 题目要求不开空间，

```cpp
/**
 * Definition for binary tree with next pointer.
 * struct TreeLinkNode {
 *  int val;
 *  TreeLinkNode *left, *right, *next;
 *  TreeLinkNode(int x) : val(x), left(NULL), right(NULL), next(NULL) {}
 * };
 */
class Solution {
public:
    void connect(TreeLinkNode *root) {
        if(!root)
            return;
        TreeLinkNode* next_level = root;
        for(TreeLinkNode* node;;){
            node = next_level;
            next_level = node->left;
            if(!next_level)
                break;
            TreeLinkNode* prev = NULL;
            while(node){
                if(prev)
                    prev->next = node->left;
                node->left->next = node->right;
                prev = node->right;
                node = node->next;
            }
        }
    }
};
```

### 117. Populating Next Right Pointers in Each Node II

+ 上一题的超集

```cpp
/**
 * Definition for binary tree with next pointer.
 * struct TreeLinkNode {
 *  int val;
 *  TreeLinkNode *left, *right, *next;
 *  TreeLinkNode(int x) : val(x), left(NULL), right(NULL), next(NULL) {}
 * };
 */
class Solution {
public:
    void connect(TreeLinkNode *root) {
        TreeLinkNode *next_level = root;
        while(next_level){
            auto node = next_level;
            next_level = NULL;
            TreeLinkNode *prev = NULL;
            while(node){
                if(node->left){
                    if(prev)
                        prev->next = node->left;
                    if(!next_level)
                        next_level = node->left;
                    prev = node->left;
                }
                if(node->right){
                    if(prev)
                        prev->next = node->right;
                    if(!next_level)
                        next_level = node->right;
                    prev = node->right;
                }
                node = node->next;
            }
        }
    }
};
```

### 118. Pascal's Triangle

```cpp
class Solution {
public:
    vector<vector<int>> generate(int numRows) {
        vector<vector<int>> result;
        if(numRows==0)
            return result;
        result.push_back({1});
        for(int i=1;i<numRows;i++){
            auto& last = result.back();
            vector<int> row(i+1);
            row[0] = 1;
            for(int j=0; j<i; j++)
                row[j+1] = last[j] + last[j+1];
            row[i] = 1;
            result.push_back(row);
        }
        return result;
    }
};
```
### 119. Pascal's Triangle II

```c
class Solution {
public:
    vector<int> getRow(int rowIndex) {
        vector<int> row(rowIndex+1, 0);
        row[0] = 1;
        for(int i=0; i<rowIndex; i++)
            for(int j=i+1;j>0;j--)
                row[j] += row[j-1];
        return row;
    }
};
```

### 120. Triangle

+ 动态规划

```cpp
class Solution {
public:
    int minimumTotal(vector<vector<int>>& triangle) {
        vector<int> d = triangle.back();
        for(int i=triangle.size()-2; i>=0; i--){
            for(int j=0; j<i+1; j++){
                d[j] = triangle[i][j] + min(d[j],d[j+1]);
            }
        }
        return d[0];
    }
};
```

### 121. Best Time to Buy and Sell Stock

+ 一次买，一次卖
  + 先买后卖，低买高卖
  + 遍历序列，记录当前的最小值
  
```cpp
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        if(prices.size()<=1)
            return 0;
        int lowest = prices[0], profit = 0;
        for(int x: prices){
            lowest = min(lowest, x);
            profit = max(x-lowest, profit);
        }
        return profit;
    }
};
```

```
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        if(prices.size()<=1)
            return 0;
        int lowest = INT_MAX, profit = 0;
        for(int x: prices){
            lowest = min(lowest, x);
            profit = max(x-lowest, profit);
        }
        return profit;
    }
};
```

### 122. Best Time to Buy and Sell Stock II

+ 要求买入前已经卖出

```cpp
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int profit = 0;
        for(int i=1; i<prices.size(); i++)
            profit += max(prices[i]-prices[i-1], 0);
        return profit;
    }
};
```

### 123. Best Time to Buy and Sell Stock III

+ 最多两次交易
+ 前后扫两趟，分治

```cpp
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int n = prices.size();
        if(n<=1)
            return 0;
        vector<int> profit1(n, 0);
        vector<int> profit2(n, 0);
        int lowest = prices[0];
        for(int i=1; i<n; i++){
            lowest = min(lowest, prices[i]);
            profit1[i] = max(prices[i]-lowest, profit1[i-1]);
        }
        cout<<profit1[n-1]<<lowest<<endl;
        int highest = prices[n-1];
        for(int i=n-2; i>=0; i--){
            highest = max(highest, prices[i]);
            profit2[i] = max(highest-prices[i], profit2[i+1]);
        }
        cout<<profit2[0]<<highest<<endl;
        int profit = INT_MIN;
        for(int i=0; i<n; i++){
            profit = max(profit, profit1[i]+profit2[i]);
        }
        return profit;
    }
};
```

### 124. Binary Tree Maximum Path Sum

+ 加正数会变大

```
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
    int ans = INT_MIN;
    int f(TreeNode* node){
        if(node){
            int val = node->val;
            int left = max(f(node->left), 0);
            int right = max(f(node->right), 0);
            ans = max(ans, left+right+val);
            return max(left,right)+val;
        }else{
            return 0;
        }
    }
public:
    int maxPathSum(TreeNode* root) {
        f(root);
        return ans;
    }
};
```

### 125. Valid Palindrome


```cpp
class Solution {
public:
    bool isPalindrome(string s) {
        if(s.empty())
            return true;
        for(int i=0, j=s.size()-1;;i++,j--){
            while(!isalnum(s[i]))
                i++;
            while(!isalnum(s[j]))
                j--;
            if(i>=j)
                break;
            if(toupper(s[i])!=toupper(s[j]))
                return false;                
        }
        return true;
    }
};
```
### 126. Word Ladder II

+ 图

```cpp
class Solution {
    template<class Callback>
    inline void transform(string word,Callback callback){
        for(int i=0; i<word.size(); i++){
            char c = word[i];
            for(char j='a';j<='z';j++){
                if(j!=c){
                    word[i] = j;
                    callback(word);
                }
            }
            word[i] = c;
        }        
    }
public:
    vector<vector<string>> findLadders(string beginWord, string endWord, unordered_set<string> &wordList) {
        unordered_map<string,int> dist;
        unordered_map<string,vector<string>> path;
        queue<string> q;
        q.push(beginWord);
        dist[beginWord] = 1;
        while(!q.empty()){
            auto x = q.front();
            q.pop();
            cout<<x<<endl;
            if(x==endWord)
                break;
            transform(x, [&](const string& word){
                if(wordList.count(word)){
                    if(dist[word]==0){
                        dist[word] = dist[x]+1;
                        q.push(word);
                    }
                    if(dist[word]==dist[x]+1)
                        path[word].push_back(x);
                }
            });
        }
        vector<vector<string>> result;
        vector<string> item;
        function<void(const string&)> buildPath = [&](const string& node){
            if(node==beginWord){
                auto item2 = item;
                item2.push_back(node);
                reverse(begin(item2),end(item2));
                result.push_back(item2);
                return;
            }
            item.push_back(node);
            for(auto& s:path[node])
                buildPath(s);
            item.pop_back();
        };
        buildPath(endWord);
        return result;        
    }
};
```



### 127. Word Ladder

+ 图论，广度优先搜索
  + 用队列实现
+ 这题给个测试用例单词很短，但是单词数量很多
  + 比如说有个 5 的字符长度（5*25=125个变换），2370 个单词的
  + 这种情况下用字符串两两比较会超时
  
```cpp
class Solution {
    bool adjacent(const string& s1, const string& s2){
        if(s1.size()!=s2.size())
            return false;
        int count = 0;
        for(int i=0; i<s1.size() && count<2; i++){
            if(s1[i]!=s2[i])
                count++;
        }
        return count==1;
    }
public:
    int ladderLength(string beginWord, string endWord, unordered_set<string>& wordList) {
        unordered_map<string,int> dist;
        queue<string> q;
        q.push(beginWord);
        dist[beginWord] = 1;
        while(!q.empty()){
            auto x = q.front();
            q.pop();
            if(x==endWord)
                break;
            string o = x;
            for(int i=0; i<x.size(); i++){
                char c = x[i];
                for(char j='a';j<='z';j++){
                    if(j!=c){
                        x[i] = j;
                        if(wordList.count(x) && !dist[x]){
                            q.push(x);
                            dist[x] = dist[o]+1;
                        }
                    }
                }
                x[i] = c;
            }
            // for(auto v: wordList){
            //     if(!dist[v] && adjacent(x,v)){
            //         q.push(v);
            //         dist[v] = dist[x]+1;
            //     }
            // }
        }
        return dist[endWord];
    }
};
```

### 128. Longest Consecutive Sequence

+ 要求 O(N)

```cpp
class Solution {
    unordered_map<int,int> h;
    int ds_find(int x){
        if(h[x]!=x)
            h[x] = ds_find(h[x]);
        return h[x];
    }
    void ds_union(int x, int y){
        h[ds_find(x)] = ds_find(y);
    }
public:
    int longestConsecutive(vector<int>& nums) {
        for(int x: nums)
            h[x] = x;
        for(int x: nums){
            if(h.count(x+1))
                ds_union(x, x+1);
            if(h.count(x-1))
                ds_union(x, x-1);
        }
        unordered_map<int,int> a;
        for(auto p: h)
            a[ds_find(p.second)]++;
        int ans = 0;
        for(auto p: a)
            ans = max(ans, p.second);
        return ans;
    }
};
```

### 129. Sum Root to Leaf Numbers

+ 二叉树

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
public:
    int sumNumbers(TreeNode* root) {
        function<int(TreeNode*,int)> f = [&](TreeNode* node,int num){
            if(!node)
                return 0;
            num = num*10 + node->val;
            if(!node->left && !node->right)
                return num;
            return f(node->left, num)+f(node->right, num);
        };
        return f(root, 0);
    }
};
```

### 130. Surrounded Regions

+ 递归会爆栈，
  +  LeetCode 显示 RunTime Error

```cpp
class Solution {
public:
    void solve(vector<vector<char>>& board) {
        int m = board.size();
        if(m==0)
            return;
        int n = board[0].size();
        function<void(int,int)> f = [&](int x, int y){
            if(board[y][x]=='O'){
                board[y][x] = 'T';
                if(y+1 < m-1)
                    f(x, y+1);
                if(y-1 > 0)
                    f(x, y-1);
                if(x+1 < n-1)
                    f(x+1, y);
                if(x-1 > 0)
                    f(x-1, y);
            }
        };
        for(int i=0; i<n; i++){
            f(i, 0);
            f(i, m-1);
        }
        for(int j=0; j<m; j++){
            f(0, j);
            f(n-1, j);
        }
        for(auto& xs: board)
            for(auto& x: xs)
                if(x=='O')
                    x = 'X';
                else if(x=='T')
                    x = 'O';
    }
};
```

### 131. Palindrome Partitioning

> Backtracking

+ 深度优先搜索
+ 动态规划

```
class Solution {
    bool  isPalindrome(const string& s, int start, int last){
        while(start<last){
            if(s[start]!=s[last])
                return false;
            start++, last--;
        }
        return true;
    }
public:
    vector<vector<string>> partition(string s) {
        vector<vector<string>> result;
        //unordered_map<string,vector<string>> h;
        vector<string> path;
        function<void(int)> f = [&](int i){
            if(i==s.size()){
                result.push_back(path);
                return;
            }
            for(int j=i; j<s.size(); j++){
                if(isPalindrome(s,i,j)){
                    path.push_back(s.substr(i,j-i+1));
                    f(j+1);
                    path.pop_back();
                }
            }
        };
        f(0);
        return result;
    }
};
```

### 132. Palindrome Partitioning II

+ 求最小割数
+ 长度 n 最多 n-1 个割
+ 一个字串可以递归分解为一个回文子串和另一个字串

```cpp
class Solution {
public:
    int minCut(string s) {
        int n = s.size();
        vector<int> c(n+1);
        vector<vector<bool>> d(n,vector<bool>(n));
        for(int i=0; i<=n; i++)
            c[i] = i - 1;
        for(int i=0; i<n; i++)
            for(int j=i; j>=0; j--)
                if(s[j]==s[i] && (i-j<3 || d[j+1][i-1])){
                    d[j][i] = true;
                    c[i+1] = min(c[i+1], c[j]+1);
                }
        return c[n];
    }
};
```

```
class Solution {
public:
    int minCut(string s) {
        int n = s.size();
        vector<int> c(n+1);
        vector<vector<bool>> d(n,vector<bool>(n));
        for(int i=0; i<=n; i++)
            c[i] = i - 1;
        for(int i=0; i<n; i++)
            for(int j=0; j<=i; j++)
                if(s[j]==s[i] && (i-j<3 || d[j+1][i-1])){
                    d[j][i] = true;
                    c[i+1] = min(c[i+1], c[j]+1);
                }
        return c[n];
    }
};
```

### 133. Clone Graph


+ 图
+ 哈希表
+ 递归

```cpp
/**
 * Definition for undirected graph.
 * struct UndirectedGraphNode {
 *     int label;
 *     vector<UndirectedGraphNode *> neighbors;
 *     UndirectedGraphNode(int x) : label(x) {};
 * };
 */
class Solution {
public:
    UndirectedGraphNode *cloneGraph(UndirectedGraphNode *node) {
        unordered_map<UndirectedGraphNode*,UndirectedGraphNode*> h;
        function<UndirectedGraphNode*(UndirectedGraphNode*)> f = [&](UndirectedGraphNode* node){
            auto it = h.find(node);
            if(it!=h.end())
                return it->second;
            auto new_node = new UndirectedGraphNode(node->label);
            h[node] = new_node;
            for(auto e: node->neighbors)
                new_node->neighbors.push_back(f(e));
            return new_node;
        };
        return node ? f(node) : nullptr;
    }
};
```

### 134. Gas Station

+ 一趟
+ 有两个目标
  1. 判断是否能完成
  2. 寻找起点

```cpp
class Solution {
public:
    int canCompleteCircuit(vector<int>& gas, vector<int>& cost) {
        int a = 0, d = 0;
        int start = 0;
        for(int i=0; i<gas.size(); i++){
            d += gas[i] - cost[i];
            if(d<0){
                a += d;
                d = 0;
                start = i+1;
            }
        }
        return a+d>=0 ? start : -1;
    }
};
```

### 135. Candy

+ 记录变化量

```c
int candy(int* ratings, int ratingsSize) {
    int a, *d = (int*)calloc(ratingsSize,sizeof(int));
    a = 1;
    for(int i=1; i<ratingsSize; i++){
        if(ratings[i] > ratings[i-1]){
            if(d[i]<a)
                d[i] = a;
            a++;
        }else{
            a = 1; 
        }
    }
    a = 1;
    for(int i=ratingsSize-2; i>=0; i--){
        if(ratings[i] > ratings[i+1]){
            if(d[i]<a)
                d[i] = a;
            a++;
        }else{
            a = 1;
        }
    }
    int sum = ratingsSize;
    for(int i=0; i<ratingsSize; i++){
        sum += d[i];
    }
    return sum;
}
```

### 136. Single Number

+ 整数的位运算
+ 异或运算，和零异或为自己，和自己异或为 0

```c
int singleNumber(int* nums, int numsSize) {
    int x = 0;
    for(int i=0; i<numsSize; i++)
        x ^= nums[i];
    return x;
}
```

### 137. Single Number II

+ 二进制位加法
  + 异或运算得到值，与运算得到进位
+ 本题得到 0b11 时再取模

```cpp
class Solution {
public:
    int singleNumber(vector<int>& nums) {
        int a=0, b=0;
        for(int x: nums){
            b ^= a&x;
            a ^= x;
            int c = ~(a&b);
            a &= c;
            b &= c;
        }
        return a;
    }
};
```

### 138. Copy List with Random Pointer

+ 图的复制

```c
/**
 * Definition for singly-linked list with a random pointer.
 * struct RandomListNode {
 *     int label;
 *     struct RandomListNode *next;
 *     struct RandomListNode *random;
 * };
 */
struct RandomListNode *copyRandomList(struct RandomListNode *head) {
    typedef struct RandomListNode Node;
    if(!head)
        return NULL;
    for(Node* node=head; node;){
        Node* copy = (Node*)malloc(sizeof(Node));
        *copy = *node;
        node->next = copy;
        node = copy->next;
    }
    for(Node* node=head; node;){
        Node* copy = node->next;
        if(copy->random)
            copy->random = copy->random->next;
        node = copy->next;
    }
    Node *head2 = head->next;
    for(Node *node = head; node;){
        Node *node2 = node->next;
        Node *next = node2->next;
        node->next = next;
        node2->next = next ? next->next : NULL;
        node = next;
    }
    return head2;
}
```


```cpp
/**
 * Definition for singly-linked list with a random pointer.
 * struct RandomListNode {
 *     int label;
 *     RandomListNode *next, *random;
 *     RandomListNode(int x) : label(x), next(NULL), random(NULL) {}
 * };
 */
class Solution {
public:
    RandomListNode *copyRandomList(RandomListNode *head) {
        unordered_map<RandomListNode*,RandomListNode*> h;
        auto get = [&](RandomListNode* node)->RandomListNode*{
            if(!node)
                return NULL;
            auto it = h.find(node);
            if(it!=h.end())
                return it->second;
            else{
                return h[node] = new RandomListNode(node->label);
            }
        };
        for(auto p=head; p; p=p->next){
            auto node_clone = get(p);
            node_clone->random = get(p->random);
            node_clone->next = get(p->next);
        }
        return h[head];
    }
};
```


### 139. Word Break

+ 动态规划
+ 分词/递归

```cpp
class Solution {
public:
    bool wordBreak(string s, vector<string>& wordDict) {
        unordered_set<string> dict;
        for(auto& x: wordDict)
            dict.insert(x);
        vector<bool> d(s.size()+1, false);
        d[0] = true;
        for(int i=1;i<=s.size();i++)
            for(int j=i-1;j>=0;j--)
                if(d[j] && dict.count(s.substr(j, i-j))){
                    d[i] = true;
                    break;
                }
        return d.back();
    }
};
```

```cpp
class Solution {
public:
    bool wordBreak(string s, vector<string>& wordDict) {
        unordered_set<string> dict;
        int len = 0;
        for(auto& x: wordDict){
            dict.insert(x);
            len = max(len,(int)x.size());
        }
        unordered_map<int,bool> m;
        function<bool(int)> f = [&](int i){
            if(i==s.size())
                return true;
            auto it = m.find(i);
            if(it!=m.end())
                return it->second;
            for(int j=i+1; j<=s.size() && j-i<=len; j++)
                if(dict.count(s.substr(i,j-i)) && f(j))
                    return m[i] = true;
            return m[i] = false;
        };
        return f(0);
    }
};
```

### 140. Word Break II

```cpp
class Solution {
public:
    vector<string> wordBreak(string s, vector<string>& wordDict) {
        unordered_set<string> dict;
        for(auto& x: wordDict)
            dict.insert(x);
        int n = s.size();
        vector<vector<int>> edge(n+1,vector<int>());
        edge[0].push_back(0);
        for(int i=1; i<=n; i++)
            for(int j=i-1; j>=0; j--)
                if(edge[j].size() && dict.count(s.substr(j, i-j))){
                    edge[i].push_back(j);
                    printf("(%d->%d)\n",j,i);
                }
        vector<string> result;
        vector<string> path;
        function<void(int)> f = [&](int i){
            if(i==0){
                string item;
                for(int j=path.size()-1; j>=0; j--){
                    item += path[j];
                    item += ' ';
                }
                item.pop_back();
                result.push_back(item);
                return;
            }
            for(auto j: edge[i]){
                path.push_back(s.substr(j, i-j));
                f(j);
                path.pop_back();
            }
        };
        f(n);
        return result;
    }
};
```

### 141. Linked List Cycle

+ 链表，双指针

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    bool hasCycle(ListNode *head) {
        auto fast = head, slow = head;
        while(fast && fast->next){
            fast = fast->next->next;
            slow = slow->next;
            if(fast==slow)
                return true;
        }
        return false;
    }
};
```

### 142. Linked List Cycle II

> List

+ 链表

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode *detectCycle(ListNode *head) {
        auto fast = head, slow = head;
        while(fast && fast->next){
            fast = fast->next->next;
            slow = slow->next;
            if(fast==slow){
                auto node = head;
                while(node!=slow){
                    slow = slow->next;
                    node = node->next;
                }
                return node;
            }
        }
        return NULL;        
    }
};
```

### 143. Reorder List

+ 链表
+ 原地逆置+链表合并+快慢双指针

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
    ListNode* nreverse(ListNode* head){
        ListNode* prev = NULL;
        while(head){
            auto next = head->next;
            head->next = prev;
            prev = head;
            head = next;
        }
        return prev;
    }
    void merge(ListNode* head1,ListNode* head2){
        while(head2){
            auto next1 = head1->next;
            auto next2 = head2->next;
            head1->next = head2;
            head2->next = next1;
            head1 = next1;
            head2 = next2;
        }
    }
    ListNode* cut(ListNode* head){
        auto fast = head, slow = head;
        while(fast && fast->next){
            fast = fast->next->next;
            slow = slow->next;
        }
        auto head2 = slow->next;
        slow->next = NULL;
        return head2;
    }
public:
    void reorderList(ListNode* head) {
        if(head)
            merge(head,nreverse(cut(head)));
    }
};
```

### 144. Binary Tree Preorder Traversal

+ 重点问题！
+ 二叉树先序遍历
  + NLR，先访问根节点
+ 递归，非递归实现
  + 出栈顺序

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
public:
    vector<int> preorderTraversal(TreeNode* root) {
        vector<int> result;
        stack<TreeNode*> s;
        if(root)
            s.push(root);
        while(!s.empty()){
            TreeNode* node = s.top();
            s.pop();
            result.push_back(node->val);
            if(node->right)
                s.push(node->right);
            if(node->left)
                s.push(node->left);
        }
        return result;
    }
};
```

### 145. Binary Tree Postorder Traversal

> Tree

+ 二叉树后序遍历的迭代实现

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
public:
    vector<int> postorderTraversal(TreeNode* root) {
        vector<int> result;
        stack<TreeNode*> s;
        TreeNode *p = root;
        TreeNode *q = NULL;
        for(;;){
            if(p){
                s.push(p);
                p = p->left;
            }else if(!s.empty()){
                p = s.top();
                if(q==p->right || !p->right){
                    result.push_back(p->val);
                    q = p;
                    s.pop();
                    p = NULL;
                }else{
                    p = p->right;
                }
            }else{
                break;
            }
        }
        return result;
    }
};
```

### 146. LRU Cache

+ 需要在 O(1) 时间找到链表中的节点并移动到头部
  + 利用双向链表和哈希表
  + c++ 的 splice 用来把另一个链表中的元素插入该位置前

```cpp
class LRUCache{
    int capacity;
    unordered_map<int,list<pair<int,int>>::iterator> h;
    list<pair<int,int>> l;
public:
    LRUCache(int capacity) {
        this->capacity = capacity;
    }
    
    int get(int key) {
        auto it = h.find(key);
        if(it==h.end())
            return -1;
        l.splice(l.begin(), l, it->second);
        return it->second->second;
    }
    
    void set(int key, int value) {
        auto it = h.find(key);
        if(it!=h.end()){
            it->second->second = value;
            l.splice(l.begin(), l, it->second);
        }else{
            if(l.size()==capacity){
                h.erase(l.back().first);
                l.pop_back();
            }
            l.push_front(make_pair(key, value));
            h[key] = l.begin(); 
        }
    }
};
```

### 147. Insertion Sort List

+ 数组一般从后往前插

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* insertionSortList(ListNode* head) {
        ListNode* list = NULL;
        auto node = head;
        while(node){
            auto next = node->next;
            auto p = &list;
            while(*p && node->val > (*p)->val)
                p = &(*p)->next;
            node->next = *p;
            *p = node;
            node = next;
        }
        return list;
    }
};
```

### 148. Sort List

+ 链表
+ 归并排序
+ 结合前面的题目
  + `21. Merge Two Sorted Lists`，直接搬过来递归使用
  + `143. Reorder List`，那题有两个节点的话不用断开，这题要。

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
    ListNode* cut(ListNode* head){
        auto fast = head, slow = head;
        while(fast && fast->next && fast->next->next){
            fast = fast->next->next;
            slow = slow->next;
        }
        auto head2 = slow->next;
        slow->next = NULL;
        return head2;
    }
    ListNode* nmerge(ListNode* head1,ListNode* head2){
        ListNode* head = NULL;
        ListNode** append = &head; 
        for(;;){
            if(!head1){
                *append = head2;
                break;
            }
            if(!head2){
                *append = head1;
                break;
            }
            if(head1->val < head2->val){
                *append = head1;
                head1 = head1->next;
            }else{
                *append = head2;
                head2 = head2->next;
            }
            append = &(*append)->next;
        }
        return head;
    }
public:
    ListNode* sortList(ListNode* head) {
        if(!head || !head->next)
            return head;
        auto head2 = cut(head);
        return nmerge(sortList(head),sortList(head2));
    }
};
```

### 149. Max Points on a Line

+ 注意出现重合的点的情况
  + [[1,1],[1,1],[1,1]]
+ 该题的坐标是整数

```cpp
/**
 * Definition for a point.
 * struct Point {
 *     int x;
 *     int y;
 *     Point() : x(0), y(0) {}
 *     Point(int a, int b) : x(a), y(b) {}
 * };
 */
class Solution {
public:
    int maxPoints(vector<Point>& points) {
        int n = points.size();
        if(n<=2)
            return points.size();
        int m = 2;
        for(int i=0; i<n; i++){
            int start = 2;
            for(int j=i+1; j<n-1; j++){
                int dx = points[j].x-points[i].x;
                int dy = points[j].y-points[i].y;
                if(dx==0 && dy==0){
                    start++;
                    continue;
                }
                int bdx = dx*points[i].y - dy*points[i].x; 
                int count = start;
                for(int k=j+1; k<n; k++){
                    if(dx==0){
                        if(points[k].x == points[j].x)
                                count++;
                    }else{
                        if(dx*points[k].y==dy*points[k].x+bdx)
                                count++;
                    }
                }
                m = max(m, count);
            }
            m = max(m, start);
        }
        return m;
    }
};
```

### 150. Evaluate Reverse Polish Notation

+ Stack

```c
int evalRPN(char** tokens, int tokensSize) {
    int size = 3;
    int* stack = (int*)malloc(sizeof(int)*size);
    int *p = stack;
    for(int i=0; i<tokensSize; i++){
        char *token = tokens[i];
        if(token[0] && !token[1]){
            switch(token[0]){
                case '+':
                    p[-2] += p[-1];
                    p--;
                    continue;
                case '-':
                    p[-2] -= p[-1];
                    p--;
                    continue;
                case '*':
                    p[-2] *= p[-1];
                    p--;
                    continue;
                case '/':
                    p[-2] /= p[-1];
                    p--;
                    continue;
            }
        }
        if(p-stack==size){
            stack = realloc(stack,sizeof(int)*(size*2));
            p = stack+size;
            size *= 2;
        }
        *p++ = atoi(token);
    }
    int ans = p[-1];
    free(stack);
    return ans;
}
```

### 151. Reverse Words in a String

> Application

+ 逆置
+ 原地，一趟。

```
class Solution {
    void reverse(string& s, int i, int j){
        while(i<j)
            swap(s[i++],s[j--]);
    }
    void compact(string& s){
        int k = 0;
        for(int i=0; i<s.size(); i++)
            if(s[i]!=' '){
                if(k!=0)
                    s[k++] = ' ';
                int j = i;
                while(j<s.size() && s[j]!=' ')
                    s[k++] = s[j++];
                i = j;
            }
        s.resize(k);
    }
public:
    void reverseWords(string &s) {
        compact(s);
        ::reverse(s.begin(), s.end());
        int start = 0;
        while(start<s.size() && s[start]==' ')
            start++;
        for(int i=0; i<s.size(); i++){
            if(s[i]==' '){
                reverse(s, start, i-1);
                start = i+1;
            }
        }
        reverse(s, start, s.size()-1);
    }
};
```

### 152. Maximum Product Subarray

+ 积最大
+ 正负

```
class Solution {
public:
    int maxProduct(vector<int>& nums) {
        int m = INT_MIN;
        int a = 1, b = 1;
        for(int x: nums){
            int c = max(x, max(a*x, b*x));
            b = min(x, min(a*x, b*x));
            m = max(m, c);
            a = c;
        }
        return m;
    }
};
```

### 153. Find Minimum in Rotated Sorted Array


这个解答有问题。。。

```cpp
class Solution {
public:
    int findMin(vector<int>& nums) {
        int a = 0, b = nums.size();
        while(a<b){
            int c = (a+b-1)/2;
            if(nums[a]<=nums[b-1]){
                return nums[a];
            }else if(nums[c]>nums[b-1]){
                a = c + 1;
            }else{
                b = c + 1;
            }
        }
        return INT_MIN;
    }
};
```

### 154. Find Minimum in Rotated Sorted Array II

+ 有重复元素

```cpp
class Solution {
public:
    int findMin(vector<int>& nums) {
        int a = 0, b = nums.size()-1;
        while(a<b){
            int c = (a+b)/2;
            if(nums[a]<nums[b])
                break;
            else if(nums[c]>nums[b])
                a = c + 1;
            else if(nums[a]>nums[c])
                b = c;
            else
                a++;
        }
        return nums[a];
    }
};
 
```

```cpp
class Solution {
public:
    int findMin(vector<int>& nums) {
        int a = 0, b = nums.size();
        while(b-a>1){
            int c = (a+b-1)/2;
            if(nums[a]<nums[b-1])
                break;
            else if(nums[c]>nums[b-1])
                a = c + 1;
            else if(nums[a]>nums[c])
                b = c + 1;
            else
                a++;
        }
        return nums[a];
    }
};
```

### 155. Min Stack

+ 栈，先进先出
+ 用另一个栈记录最小元素
+ STL 中空栈取元素是未定义行为

```cpp
class MinStack {
    stack<int> _stack;
    stack<int> _stack_min;
public:
    /** initialize your data structure here. */
    MinStack() {
        
    }
    
    void push(int x) {
        _stack.push(x);
        if(_stack_min.empty() || x<=_stack_min.top())
            _stack_min.push(x);
    }
    
    void pop() {
        int x = _stack.top();
        _stack.pop();
        if(!_stack_min.empty() && x==_stack_min.top())
            _stack_min.pop();
    }
    
    int top() {
        return _stack.top();
    }
    
    int getMin() {
        return _stack_min.top();
    }
};

/**
 * Your MinStack object will be instantiated and called as such:
 * MinStack obj = new MinStack();
 * obj.push(x);
 * obj.pop();
 * int param_3 = obj.top();
 * int param_4 = obj.getMin();
 */
```

### 160. Intersection of Two Linked Lists

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
    int list_length(ListNode* head){
        int n=1;
        while(head){
            n++;
            head = head->next;
        }
        return n;
    }
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        int lenA = list_length(headA);
        int lenB = list_length(headB);
        if(lenA>lenB){
            for(int i=lenA-lenB; i>0; i--)
                headA = headA->next;
        }else{
            for(int i=lenB-lenA; i>0; i--)
                headB = headB->next;
        }
        while(headA!=headB){
            headA = headA->next;
            headB = headB->next;
        }
        return headA;
    }
};
```

### 162. Find Peak Element

+ 二分查找
+ 找极大值
+ 越界为负无穷

```cpp
class Solution {
public:
    int findPeakElement(vector<int>& nums) {
        auto less = [&](int i, int j){
            if(i==-1 || i==nums.size())
                return true;
            if(j==-1 || j==nums.size())
                return false;
            return nums[i] < nums[j];  
        };
        int a = 0, b = nums.size();
        while(a<b){
            int c = (a+b)/2;
            if(less(c-1,c) && less(c, c+1))
                a = c + 1;
            else if(less(c+1, c) && less(c, c-1))
                b = c;
            else if(less(c+1, c) && less(c-1, c))
                return c;
            else
                b = c;
        }
        return -1;
    }
};
```

### 164. Maximum Gap

> Sort

+ 先排序 O(N)，后查找 O(N)

```c
//http://zh.wikipedia.org/zh-cn/%E5%9F%BA%E6%95%B0%E6%8E%92%E5%BA%8F
void radixsort(int data[], int n){
    int m = 0;
    for(int i=0;i<n;i++)
        if(data[i]>m)
            m = data[i];
    int *tmp = (int*)malloc(sizeof(int)*n);
    memset(tmp, 0, sizeof(int)*n);
    int count[10] = {0};
    for(unsigned radix=1;radix<=m;radix*=10){
        for(int i=0;i<10;i++)
            count[i] = 0;
        for(int i=0; i<n; i++)
            count[(data[i]/radix)%10]++;
        for(int i=1; i<10; i++)
            count[i] += count[i-1];
        for(int i=n-1; i>=0; i--)
            tmp[--count[(data[i]/radix)%10]] = data[i];
        for(int i=0; i<n; i++)
            data[i] = tmp[i];
    }
    free(tmp);
}
int maximumGap(int num[], int n) {
    if(n<2)
        return 0;
    radixsort(num,n);
    int pred = num[0];
    int max = 0;
    for(int i=1;i<n;i++){
        int curr = num[i];
        int delta = curr>pred ? curr-pred : pred-curr;
        if(delta>max)
            max = delta;
        pred = curr;
    }
    return max;
}
```

### 165. Compare Version Numbers

```
int compareVersion(char* version1, char* version2) {
    while(*version1 || *version2){
        int a = strtol(version1,&version1,10);
        int b = strtol(version2,&version2,10);
        if(*version1=='.')version1++;
        if(*version2=='.')version2++;
        if(a<b)return -1;
        if(a>b)return 1;
    }
    return 0;
}
```

### 166. Fraction to Recurring Decimal


```cpp
class Solution {
    void append(string& s, unsigned n){
        stringstream ss;
        ss << n;
        s += ss.str();         
    }
public:
    string fractionToDecimal(int numerator, int denominator) {
        string s;
        if(numerator==0)
            return "0";
        if((numerator^denominator)&(1<<31))
             s += "-";
        long long a = llabs((long long)numerator), b = llabs((long long)denominator);
        append(s, a/b); 
        a %= b;
        if(a!=0){
            s.push_back('.');
            unordered_map<unsigned,int> h;
            for(int i=s.size(); a; i++){
                if(h.count(a)){
                    s.insert(h[a], "(");
                    s.push_back(')');
                    break;
                }
                h[a] = i;
                a *= 10;
                append(s, a/b);
                a %= b;
            }
        }
        return s;
    }
};
```

### 167. Two Sum II - Input array is sorted

+ 这题没意思

```
class Solution {
public:
    vector<int> twoSum(vector<int>& numbers, int target) {
        int i = 0, j = numbers.size()-1;
        while(i<j){
            int s = numbers[i] + numbers[j];
            if(s==target)
                return {i+1, j+1};
            else if(s<target)
                i++;
            else
                j--;
        }
        return {0,0};
    }
};
```

### 168. Excel Sheet Column Title

```
class Solution {
public:
    string convertToTitle(int n) {
        string s;
        while(n){
            n--;
            s += 'A'+ n%26;
            n /= 26;
        }
        reverse(s.begin(), s.end());
        return s;
    }
};
```

### 169. Majority Element

+ 数组老题，题干有若干假设

```c
int majorityElement(int* nums, int numsSize) {
    int x = nums[0];
    int count = 1;
    for(int i=1; i<numsSize; i++){
        if(nums[i]==x){
            count++;
        }else{
            count--;
            if(count==0){
                x = nums[i];
                count=1;
            }
        }
    }
    return x;
}
```

### 171. Excel Sheet Column Number

```c
int titleToNumber(char* s) {
    int n = 0;
    for(;*s;s++)
        n = n*26+*s-'A'+1;
    return n;
}
```

### 172. Factorial Trailing Zeroes

> 索引：整数

+ 求区间上因子5的个数

```c
int trailingZeroes(int n) {
    int a = 0;
    while(n>=5){
        n /= 5;
        a += n;
    }
    return a;
}
```

### 173. Binary Search Tree Iterator

+ 二叉树的中序遍历
+ 写成外迭代器的形式

```cpp
/**
 * Definition for binary tree
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class BSTIterator {
    stack<TreeNode*> s;
public:
    BSTIterator(TreeNode *root) {
        auto p = root;
        while(p){
            s.push(p);
            p = p->left;
        }
    }

    /** @return whether we have a next smallest number */
    bool hasNext() {
        return !s.empty();
    }

    /** @return the next smallest number */
    int next() {
        auto p = s.top();
        s.pop();
        int val = p->val;
        p = p->right;
        while(p){
            s.push(p);
            p = p->left;
        }
        return val;
    }
};

/**
 * Your BSTIterator will be called like this:
 * BSTIterator i = BSTIterator(root);
 * while (i.hasNext()) cout << i.next();
 */
```


### 174. Dungeon Game

> DP

+ 深搜，符合DP的两个条件
+ 路径上一直大于零。

```
class Solution {
public:
    int calculateMinimumHP(vector<vector<int>>& dungeon) {
        int m = dungeon.size();
        int n = dungeon[0].size();
        int d[n];
        d[n-1] = max(-dungeon[m-1][n-1], 0);
        for(int j=n-2;j>=0;j--)
            d[j] = max(d[j+1]-dungeon[m-1][j], 0);
        for(int i=m-2;i>=0;i--){
            d[n-1] = max(d[n-1]-dungeon[i][n-1], 0);
            for(int j=n-2;j>=0;j--){
                int cost = dungeon[i][j];
                d[j] = min(d[j]-cost, d[j+1]-cost);
                d[j] = max(d[j], 0);
            }
        }
        return d[0]+1;
    }
};
```

### 179. Largest Number


```cpp
class Solution {
public:
    string largestNumber(vector<int>& nums) {
        vector<string> xs;
        for(int x: nums){
            stringstream ss;
            ss << x;
            xs.push_back(ss.str());
        }
        sort(begin(xs), end(xs),[](const string& a, const string& b){
            return a+b > b+a;
        });
        if(xs.size()==0 || xs[0]=="0")
            return "0";
        stringstream ss;
        for(auto& x: xs)
            ss << x;
        return ss.str();
    }
};
```

### 187. Repeated DNA Sequences

+ 查找

```cpp
class Solution {
public:
    vector<string> findRepeatedDnaSequences(string s) {
        vector<string> result;
        unordered_map<char, int> m = {{'A',0},{'C',1},{'G',2},{'T',3}};
        unordered_map<int, int> h;
        int key = 0;
        for(int i=0; i<9; i++)
            key = (key<<2) | m[s[i]];
        for(int i=9; i<s.size(); i++){
            key = ((key<<2) | m[s[i]]) & ((1<<20) - 1);
            if(++h[key]==2)
                result.push_back(s.substr(i-9, 10));
        }
        return result;
    }
};
```


### 188. Best Time to Buy and Sell Stock IV

+ 买卖交替
+ k 很大的情况
+ k==2 的情况

```cpp
class Solution {
public:
    int maxProfit(int k, vector<int>& prices) {
        if(k>=prices.size()/2){
            int ans = 0;
            for(int i=1; i<prices.size(); i++){
                int d = prices[i] - prices[i-1];
                ans += max(d, 0);
            }
            return ans;
        }        
        vector<int> l(k+1);
        vector<int> g(k+1);
        for(int i=1; i<prices.size();i++){
            int d = prices[i] - prices[i-1];
            for(int j=k; j>=1; j--){
                l[j] = max(g[j-1]+max(d,0), l[j]+d);
                g[j] = max(g[j], l[j]);
            }
        }
        return g[k];
    }
};
```

### 189. Rotate Array

> Array

+ 数组问题
+ 三次逆置

```c
void reverse(int* nums, int i, int j){
    for(; i<j; i++,j--){
        int t = nums[i];
        nums[i] = nums[j];
        nums[j] = t;
    }
}
void rotate(int* nums, int numsSize, int k) {
    k %= numsSize;
    if(k==0)
        return;
    reverse(nums,0,numsSize-k-1);
    reverse(nums,numsSize-k,numsSize-1);
    reverse(nums,0,numsSize-1);
}
```


### 190. Reverse Bits

```
uint32_t reverseBits(uint32_t n) {
    int a = 0;
    for(int i=0; i<32; i++){
        a <<= 1;
        a |= n&1;
        n >>= 1;
    }
    return a;
}
```

### 191. Number of 1 Bits

+ 整数位运算经典题
+ 一次迭代去掉一个最低位的1
  + 发生二进制减法借位

```c
int hammingWeight(uint32_t n) {
    int count = 0;
    while(n){
        count++;
        n &= n-1;
    }
    return count;
}
```

### 198. House Robber

> DP

+ 应用题，动态规划

```cpp
class Solution {
public:
    int rob(vector<int>& nums) {
        int n = nums.size();
        if(n==0)
            return 0;
        if(n==1)
            return nums[0];
        vector<int> d(n);
        d[0] = nums[0];
        d[1] = max(d[0], nums[1]);
        for(int i=2; i<nums.size(); i++)
            d[i] = max(d[i-1], d[i-2]+nums[i]);
        return d[n-1];
    }
};
```

### 199. Binary Tree Right Side View

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
public:
    vector<int> rightSideView(TreeNode* root) {
        vector<int> result;
        queue<TreeNode*> q;
        if(root)
            q.push(root);
        while(!q.empty()){
            result.push_back(q.back()->val);
            int n = q.size();
            while(n--){
                auto node = q.front();
                q.pop();
                if(node->left)
                    q.push(node->left);
                if(node->right)
                    q.push(node->right);
            }
        }
        return result;
    }
};
```

### 200. Number of Islands

> Graph

```
void fill(char **grid, int m, int n, int y, int x) {
    if(grid[y][x]=='1'){
        grid[y][x] = '0';
        if(y>0)
            fill(grid, m, n, y-1, x);
        if(y+1<m)
            fill(grid, m, n, y+1, x);
        if(x>0)
            fill(grid, m, n, y, x-1);
        if(x+1<n)
            fill(grid, m, n, y, x+1);
    }
}
int numIslands(char** grid, int gridRowSize, int gridColSize) {
    int count = 0;
    for(int y=0;y<gridRowSize;y++)
        for(int x=0;x<gridColSize;x++){
            if(grid[y][x]=='1'){
                fill(grid, gridRowSize, gridColSize, y, x);
                count++;
            }
        }
    return count;
}
```

### 201. Bitwise AND of Numbers Range

> Integer

+ 位运算的转化，覆盖区间上的数

```cpp
class Solution {
public:
    int rangeBitwiseAnd(int m, int n) {
        unsigned b = -1;
        while((m&b)!=(n&b))
            b <<= 1;
        return m&b;
    }
};
```

### 202. Happy Number

```cpp
class Solution {
    int next(int x){
        int y = 0;
        while(x){
            y += (x%10)*(x%10);
            x /= 10;
        }
        return y;
    }
public:
    bool isHappy(int n) {
        unordered_map<int,bool> h;
        while(n!=1){
            if(h.count(n))
                return false;
            h[n] = true;
            n = next(n);
        }
        return true;
    }
};
```

### 203. Remove Linked List Elements

```
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* removeElements(ListNode* head, int val) {
        auto list = &head;
        while(*list){
            if((*list)->val==val)
                *list = (*list)->next;
            else
                list = &(*list)->next;
        }
        return head;
    }
};
```

### 204. Count Primes

+ 质数
+ 筛

```c
int countPrimes(int n) {
    int count = 0;
    bool h[n];
    memset(h,-1,sizeof(bool)*n);
    h[0] = h[1] = 0;
    for(int i=2; i<n; i++)
        if(h[i])
            for(int j=i<<1; j<n; j+=i)
                h[j] = 0;
    for(int i=0; i<n; i++)
        if(h[i])
            count++;
    return count;
}
```

### 205. Isomorphic Strings


```c
bool isIsomorphic(char* s, char* t) {
    char h[128] = {0}, r[128] = {0};
    while(*s){
        if(h[*s] == 0 && r[*t]==0){
            h[*s] = *t;
            r[*t] = *s;
        }else if(h[*s]!=*t)
            return false;
        s++, t++;
    }
    return true;
}
```

### 206. Reverse Linked List

+ 链表经典问题
+ 原地逆置链表

```cpp
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = NULL;
        while(head){
            ListNode* next = head->next;
            head->next = prev;
            prev = head;
            head = next;
        }
        return prev;
    }
};
```

### 207. Course Schedule

> Graph

+ 有趣的题目
+ 有向图拓扑排序，判断是否有环
  + 用深度优先搜索实现

```cpp
class Solution {
public:
    bool canFinish(int numCourses, vector<pair<int, int>>& prerequisites) {
        unordered_map<int,int> h;
        function<bool(int)> f = [&](int x){
            if(h[x]==1)
                return true;
            if(h[x]==2)
                return false;
            h[x] = 1;
            for(auto p: prerequisites)
                if(p.first==x){
                    if(f(p.second))
                        return true;
                }
            h[x] = 2;
            return false;
        };
        for(int i=0; i<numCourses; i++)
            if(f(i))
                return false;
        return true;
    }
};
```
### 208. Implement Trie (Prefix Tree)

+ 字符串查找，前缀
+ 后面有个题目会用到这个数据结构

```cpp
class Trie {
    struct Node{
        Node* next[26];
        bool term;
        Node(){
            memset(this,0,sizeof(Node));
        }
    };
    Node* root;
public:
    /** Initialize your data structure here. */
    Trie() {
        root = new Node();
    }
    
    /** Inserts a word into the trie. */
    void insert(string word) {
        Node* node = root;
        for(char c: word){
            Node*& next = node->next[c-'a'];
            if(!next)
                next = new Node();
            node = next;
        }
        node->term = true;
    }
    
    /** Returns if the word is in the trie. */
    bool search(string word) {
        Node* node = root;
        for(char c: word){
            node = node->next[c-'a'];
            if(!node)
                return false;            
        }
        return node->term;
    }
    
    /** Returns if there is any word in the trie that starts with the given prefix. */
    bool startsWith(string prefix) {
        Node* node = root;
        for(char c: prefix){
            node = node->next[c-'a'];
            if(!node)
                return false;
        }
        return true;
    }
};

/**
 * Your Trie object will be instantiated and called as such:
 * Trie obj = new Trie();
 * obj.insert(word);
 * bool param_2 = obj.search(word);
 * bool param_3 = obj.startsWith(prefix);
 */
```

### 209. Minimum Size Subarray Sum

> Array

+ 双指针

```cpp
class Solution {
public:
    int minSubArrayLen(int s, vector<int>& nums) {
        int len = nums.size()+1;
        int sum = 0;
        int j = 0;
        for(int i=0; i<nums.size(); i++){
            sum += nums[i];
            while(j<i && sum-nums[j]>=s){
                sum -= nums[j];
                j++;
            }
            if(sum>=s)
                len = min(len, i-j+1);
            printf("%d->%d: %d %d\n",j,i,sum,len);
        }
        return len==nums.size()+1 ? 0 : len;
    }
};
```

### 210. Course Schedule II

+ 有其他实现方式

```cpp
class Solution {
public:
    vector<int> findOrder(int numCourses, vector<pair<int, int>>& prerequisites) {
        vector<int> ans;
        unordered_map<int,int> h;
        function<bool(int)> f = [&](int x){
            if(h[x]==1)
                return true;
            if(h[x]==2)
                return false;
            h[x] = 1;
            for(auto p: prerequisites)
                if(p.first==x){
                    if(f(p.second))
                        return true;
                }
            h[x] = 2;
            ans.push_back(x);
            return false;
        };
        for(int i=0; i<numCourses; i++)
            if(f(i))
                return {};
        return ans;
    }
};
```

### 211. Add and Search Word - Data structure design

+ Trie (Prefix Tree) 
+ DFS

```cpp
class WordDictionary {
    struct TrieNode{
        TrieNode* next[26];
        bool term;
        TrieNode(){
            memset(this,0,sizeof(TrieNode));
        }
    };
    TrieNode* root;
public:
    /** Initialize your data structure here. */
    WordDictionary() {
        root = new TrieNode();
    }
    
    /** Adds a word into the data structure. */
    void addWord(string word) {
        auto node = root;
        for(char c: word){
            auto& next = node->next[c-'a'];
            if(!next)
                next = new TrieNode();
            node = next;
        }
        node->term = true;        
    }
    
    /** Returns if the word is in the data structure. A word could contain the dot character '.' to represent any one letter. */
    bool search(string word) {
        return _search(word.c_str(), root);
    }
    bool _search(const char* s, TrieNode* root){
        for(;;)
            if(*s==0){
                return root->term;
            }else if(*s=='.'){
                for(int i=0; i<26; i++){
                    if(root->next[i] && _search(s+1, root->next[i]))
                        return true;
                }
                return false;
            }else{
                root = root->next[*s-'a'];
                s++;
                if(root==NULL)
                    return false;
            }
    }
};

/**
 * Your WordDictionary object will be instantiated and called as such:
 * WordDictionary obj = new WordDictionary();
 * obj.addWord(word);
 * bool param_2 = obj.search(word);
 */
```

### 212. Word Search II

+ http://algobox.org/word-search-ii/

```cpp
class Solution {
    struct TrieNode{
        TrieNode* next[26];
        const char* term;
        TrieNode(){
            memset(this,0,sizeof(TrieNode));
        }
    };
    TrieNode* root = new TrieNode();
    void insert(string& word) {
        auto node = root;
        for(char c: word){
            auto& next = node->next[c-'a'];
            if(!next)
                next = new TrieNode();
            node = next;
        }
        node->term = word.c_str();
        printf("> %s\n",node->term);
    }
public:
    vector<string> findWords(vector<vector<char>>& board, vector<string>& words) {
        for(auto& word: words){
            insert(word);
        }
        int m = board.size();
        int n = board[0].size();
        vector<string> ans;
        function<void(int,int,TrieNode*)> f = [&](int y, int x, TrieNode* node){
            char c = board[y][x];
            if(c==0)
                return;
            auto next = node->next[c-'a'];
            if(next==NULL)
                return;
            if(next->term){
                ans.push_back(next->term);
                next->term = NULL;
            }                
            board[y][x] = 0;
            if(x>0)
                f(y, x-1, next);
            if(x+1<n)
                f(y, x+1, next);
            if(y>0)
                f(y-1, x, next);
            if(y+1<m)
                f(y+1, x, next);
            board[y][x] = c;
        };
        for(int y=0;y<m;y++){
            for(int x=0;x<n;x++){
                f(y, x, root);
            }
        }
        return ans;
    }
};
```

### 213. House Robber II

> DP

+ 参考 `198. House Robber`
+ 区别：环，分两种情况断开
+ http://m.blog.csdn.net/article/details?id=50386750

```cpp
class Solution {
    int rob1(vector<int>& nums, int s, int n) {
        if(n==1)
            return nums[s];
        vector<int> d(n);
        d[0] = nums[s];
        d[1] = max(d[0], nums[s+1]);
        for(int i=2; i<n; i++)
            d[i] = max(d[i-1], d[i-2]+nums[s+i]);
        return d[n-1];
    }    
public:
    int rob(vector<int>& nums) {
        int n = nums.size();
        if(n==0)
            return 0;
        if(n==1)
            return nums[0];
        return max(rob1(nums,0,n-1),rob1(nums,1,n-1));
    }
};
```

```cpp
class Solution {
    int rob1(vector<int>& nums, int s, int n) {
        if(n==1)
            return nums[s];
        int a = 0, b = 0;
        for(int i=0; i<n; i++){
            int c = max(b, a+nums[s+i]);
            a = b;
            b = c;
        }
        return b;
    }    
public:
    int rob(vector<int>& nums) {
        int n = nums.size();
        if(n==0)
            return 0;
        if(n==1)
            return nums[0];
        return max(rob1(nums,0,n-1),rob1(nums,1,n-1));
    }
};
```

### 214. Shortest Palindrome

+ 题目要求在前面添加字符
+ 前缀，KMP
+ 动态规可以么？
+ http://www.jianshu.com/p/787b0499d871


```cpp
class Solution {
public:
    string shortestPalindrome(string s) {
        auto s2 = s;
        reverse(s2.begin(),s2.end());
        string m = s + "#" + s2;
        int n = m.size();
        int b[n+1];
        int i = 0, j = -1;
        b[i] = j;
        while(i<n){
            while(j>=0 && m[i]!=m[j])
                j = b[j];
            i++, j++;
            b[i] = j;
        }
        return s2.substr(0, s.size()-b[n]) + s;
    }
};
```
### 215. Kth Largest Element in an Array

> Sort

+ 题目是查找，用排序
+ quicksort
+ heap

```
class Solution {
    int partition(vector<int>& A, int a, int b){
        int pivot = A[b];
        int i = a;
        for(int j=a;j<b;j++)
            if(A[j]<pivot){
                swap(A[i], A[j]);
                i++;
            }
        swap(A[i], A[b]);
        return i;
    }
    int search(vector<int>& nums, int a, int b, int k){
        if(a<=b){
            int p = partition(nums, a, b);
            int rest = b - p;
            if(k-1==rest)
                return nums[p];
            else if(k<=rest)
                return search(nums, p+1, b, k);    
            else
                return search(nums, a, p-1, k-rest-1);
        }
        return -1;
    }
public:
    int findKthLargest(vector<int>& nums, int k) {
        return search(nums, 0, nums.size()-1, k);
    }
};
```

```cpp
class Solution {
    int partition(vector<int>& A, int a, int b){
        int pivot = A[b];
        int i = a;
        for(int j=a;j<b;j++)
            if(A[j]<pivot){
                swap(A[i], A[j]);
                i++;
            }
        swap(A[i], A[b]);
        return i;
    }
    int search(vector<int>& nums, int a, int b, int k){
        while(a<=b){
            int p = partition(nums, a, b);
            int rest = b - p;
            if(k-1==rest){
                return nums[p];
            }else if(k<=rest){
                a = p+1;
            }else{
                b = p-1;
                k = k-rest-1;
            }
        }
        return -1;
    }
public:
    int findKthLargest(vector<int>& nums, int k) {
        return search(nums, 0, nums.size()-1, k);
    }
};
```

### 216. Combination Sum III

+ 拿前面有道题题小改一下就行

```cpp
class Solution {
public:
    vector<vector<int>> combinationSum3(int k, int n) {
        vector<vector<int>> result;
        int sum = 0;
        vector<int> item;
        function<void(int)> loop = [&](int i){
            if(sum==n && item.size()==k){
                result.push_back(item);
                return;
            }
            if(sum>n || item.size()==k)
                return;
            for(int j=i;j<=9;j++){
                sum += j;
                item.push_back(j);
                loop(j+1);
                sum -= j;
                item.pop_back();
            }
        };
        loop(1);
        return result;        
    }
};
```

### 217. Contains Duplicate

+ 这题没意思，是前面的题目的简化版本

```
class Solution {
public:
    bool containsDuplicate(vector<int>& nums) {
        unordered_map<int,bool> h;
        for(int x: nums){
            if(h[x])
                return true;
            h[x] = true;
        }
        return false;
    }
};
```
### 218. The Skyline Problem

+ 排序拐点
+ 横坐标相同的点先插后删除

```cpp
class Solution {
public:
    vector<pair<int, int>> getSkyline(vector<vector<int>>& buildings) {
         vector<pair<int, int>> ans;
         vector<pair<int, int>> w;
         for(auto& x: buildings){
             w.push_back({x[0],-x[2]});
             w.push_back({x[1],x[2]});
         }
         sort(w.begin(),w.end());
         multiset<int> tree = {0};
         int prev = 0;
         for(auto& x: w){
             if(x.second<0)
                 tree.insert(-x.second);
             else
                 tree.erase(tree.find(x.second));
             int top = *tree.rbegin();
             if(top!=prev){
                ans.push_back({x.first, top});
                prev = top;
             };
         }
         return ans;
    }
};
```

### 219. Contains Duplicate II

```cpp
class Solution {
public:
    bool containsNearbyDuplicate(vector<int>& nums, int k) {
        unordered_map<int,int> h;
        for(int i=0; i<nums.size(); i++){
            auto it = h.find(nums[i]);
            if(it!=h.end() && i-it->second<=k)
                return true;
            h[nums[i]] = i;
        }
        return false;
    }
};
```

### 220. Contains Duplicate III

+ 滑动窗口
+ 用搜索树，或者哈希表

```cpp
class Solution {
public:
    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        multiset<long long> tree;
        for(int i=0; i<nums.size(); i++){
            long x = nums[i];
            if(i-k-1>=0)
                tree.erase(tree.lower_bound(nums[i-k-1]));
            auto it = tree.lower_bound(x-t);
            if(it!=tree.end() && distance(it, tree.upper_bound(x+t))>0)
                return true;

            tree.insert(nums[i]);
        }
        return false;
    }
};
```


+ lower_bound 返回大于等于的元素
```cpp
class Solution {
public:
    bool containsNearbyAlmostDuplicate(vector<int>& nums, int k, int t) {
        multiset<long long> tree;
        for(int i=0; i<nums.size(); i++){
            long x = nums[i];
            if(i-k-1>=0)
                tree.erase(tree.lower_bound(nums[i-k-1]));
            auto it = tree.lower_bound(x-t);
            if(it!=tree.end() && *it<=x+t)
                return true;
            tree.insert(nums[i]);
        }
        return false;
    }
};
```

### 221. Maximal Square

+ 挺标准的动态规划的题目
  + 非常标准
  + 画图推演一下

```cpp
class Solution {
public:
    int maximalSquare(vector<vector<char>>& matrix) {
        int m = matrix.size();
        if(m==0)
            return 0;
        int n = matrix[0].size();
        int ans = 0;
        vector<int> d(n, 0);
        for(int x=0;x<n;x++)
            if(matrix[0][x]-'0')
                ans = d[x] = 1;
        for(int y=1;y<m;y++){
            int c = d[0];
            d[0] = matrix[y][0]-'0';
            ans = max(ans, d[0]);
            for(int x=1;x<n;x++){
                int t = d[x];
                if(matrix[y][x]-'0'){
                    d[x] = min(c, min(d[x], d[x-1]))+1;
                    ans = max(ans, d[x]);
                }else{
                    d[x] = 0;
                }
                c = t;
            }
        }
        return ans*ans;
    }
};
```
### 222. Count Complete Tree Nodes

+ 很容易超时
+ 利用题目中完全二叉树的性质做优化
+ 满二叉树有 2^k-1 个节点

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
public:
    int countNodes(TreeNode* root) {
        int d1 = 0, d2 = 0;
        for(auto p=root; p; p=p->left)
            d1++;
        for(auto p=root; p; p=p->right)
            d2++;
        if(d1==d2)
            return pow(2, d1)-1;
        else
            return countNodes(root->left)+countNodes(root->right)+1;        
    }
};
```

### 223. Rectangle Area

+ 计算两个矩形的总面积
+ 可能有重叠部分

```
class Solution {
public:
    int computeArea(int A, int B, int C, int D, int E, int F, int G, int H) {
        int I = max(A,E), J = max(B,F), K= min(C,G), L=min(D,H);
        return (C-A)*(D-B)+(G-E)*(H-F)-( K>I && L>J ?(K-I)*(L-J) : 0);
    }
};
```

### 224. Basic Calculator

+ 题目给的是比较特殊的情况
+ 教科书 Stack/Queue 的章节有个中缀转后缀表达式的例子
+ 暂时不需要用编译原理中写 Parser 的算法
+ 题目假设输入都是有效的，省略了错误情况的处理
  + 分母（是分母！）为 0，括号不匹配，token 重复
+ 参考资料
  + https://en.wikibooks.org/wiki/Data_Structures/Stacks_and_Queues
  + http://en.wikipedia.org/wiki/Shunting-yard_algorithm
  + http://en.wikipedia.org/wiki/Operator-precedence_parser

```cpp
class Solution {
    int priority(char c){
        switch(c){
            case '+':
            case '-':
                return 1;
            case '*':
            case '/':
                return 2;
            default:
                return 0;
        }
    }
    void operate(){
        int y = nums.top();
        nums.pop();
        int x = nums.top();
        nums.pop();
        switch(ops.top()){
            case '+':
                nums.push(x+y);
                break;
            case '-':
                nums.push(x-y);
                break;
            case '*':
                nums.push(x*y);
                break;            
            case '/':
                nums.push(x/y);
                break;
        }
        ops.pop();
    }
    stack<int> nums;
    stack<char> ops;    
public:
    int calculate(string s) {
        char c;
        const char *p = s.c_str();
        while((c=*p)){
            printf("> %c\n",c);
            switch(c){
                case ' ':
                    p++;
                    break;
                case '+':
                case '-':
                case '*':
                case '/':
                    while(!ops.empty() && priority(c)<=priority(ops.top()))
                        operate();
                    ops.push(c);
                    p++;
                    break; 
                case '(':
                    ops.push(c);
                    p++;
                    break;
                case ')':
                    while(ops.top()!='(')
                        operate();
                    ops.pop();
                    p++;
                    break;
                default:
                    char *e;
                    int x = strtol(p, &e, 10);
                    nums.push(x);
                    p = e;
            }
        }
        while(!ops.empty())
            operate();
        return nums.top();
    }
};
```


+ 没有乘除法，只有加减和正整数，可以简化
+ 求和，带符号

```cpp
class Solution {
public:
    int calculate(string s) {
        int ans = 0;
        stack<int> signs;
        signs.push(1);
        int sign = 1;
        const char *p = s.c_str();
        char c;        
        for(;;){
            switch(*p){
                case 0:
                    goto end_for;
                case ' ':
                    p++;
                    break;
                case '+':
                    sign = 1;
                    p++;
                    break;
                case '-':
                    sign = -1;
                    p++;
                    break; 
                case '(':
                    signs.push(sign*signs.top());
                    sign = 1;
                    p++;
                    break;
                case ')':
                    signs.pop();
                    sign = 1;
                    p++;
                    break;
                default:
                    char *e;
                    int x = strtol(p, &e, 10);
                    ans += signs.top()*sign*x;
                    p = e;
            }
        }
        end_for:
        return ans;
    }
};
```

### 225. Implement Stack using Queues

+ 可以用 size(queue)
+ 出入有一个操作为 O(N)
+ 可以不需要额外空间

```cpp
class MyStack {
    queue<int> q1, q2;
public:
    /** Initialize your data structure here. */
    MyStack() {
        
    }
    
    /** Push element x onto stack. */
    void push(int x) {
        q2.push(x);
    }
    
    /** Removes the element on top of the stack and returns that element. */
    int pop() {
        while(q2.size()>1){
            q1.push(q2.front());
            q2.pop();
        }
        int y = q2.front();
        q2.pop();
        q1.swap(q2);
        return y;
    }
    
    /** Get the top element. */
    int top() {
        int y = pop();
        q2.push(y);
        return y;
    }
    
    /** Returns whether the stack is empty. */
    bool empty() {
        return q2.empty();
    }
};

/**
 * Your MyStack object will be instantiated and called as such:
 * MyStack obj = new MyStack();
 * obj.push(x);
 * int param_2 = obj.pop();
 * int param_3 = obj.top();
 * bool param_4 = obj.empty();
 */
```

### 226. Invert Binary Tree

+ 二叉树遍历

```cpp
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if(root==nullptr)
            return nullptr;
        swap(root->left, root->right);
        invertTree(root->left);
        invertTree(root->right);
        return root;
    }
};
```

### 227. Basic Calculator II

+ 前面那题的特例/子集
+ 不叫优化，叫简化/特殊化

```c
int calculate(char* s) {
    int ans = 0;
    int x = strtol(s,&s,10);
    while(*s){
        while(isspace(*s))
            s++;
        char op = *s++;
        int y = strtol(s,&s,10);
        switch(op){
            case '+':
                ans += x;
                x = y;
                break;
            case '-':
                ans += x;
                x = -y;
                break;
            case '*':
                x *= y;
                break;
            case '/':
                x /= y;
                break;
        }
    }
    ans += x;
    return ans;
}
```


```cpp
class Solution {
public:
    int calculate(string s) {
        stack<int> st;
        int x;
        const char *p = s.c_str();
        st.push(strtol(p,(char**)&p,10));
        while(*p){
            while(isspace(*p))
                p++;
            char op = *p++;
            int x, y = strtol(p,(char**)&p,10);
            switch(op){
                case '+':
                    st.push(y);
                    break;
                case '-':
                    st.push(-y);
                    break;
                case '*':
                    x = st.top();
                    st.pop();
                    st.push(x*y);
                    break;
                case '/':
                    x = st.top();
                    st.pop();
                    st.push(x/y);                
                    break;
            }
        }
        int ans = 0;
        while(!st.empty()){
            ans += st.top();
            st.pop();
        }
        return ans;
    }
};
```
### 228. Summary Ranges

```cpp
class Solution {
public:
    vector<string> summaryRanges(vector<int>& nums) {
        vector<string> ans;
        stringstream b;
        int s = 0;
        for(int i=1; s!=nums.size(); i++){
            if(i==nums.size() || nums[i]!=nums[i-1]+1){
                if(s==i-1){
                    ans.push_back(to_string(nums[i-1]));
                }else{
                    stringstream b;
                    b << nums[s] << "->" << nums[i-1];
                    ans.push_back(b.str());
                }
                s = i;
            }
        }
        return ans;
    }
};
```

### 229. Majority Element II

```cpp
class Solution {
public:
    vector<int> majorityElement(vector<int>& nums) {
        int a = 0, ca = 0;
        int b = 0, cb = 0;
        for(int x: nums){
            if(x==a){
                ca++;
            }else if(x==b){
                cb++;
            }else if(ca==0){
                a = x, ca = 1;
            }else if(cb==0){
                b = x, cb = 1;
            }else{
                cb--, ca--;
            }
        }
        ca = cb = 0;
        for(int x: nums){
            if(x==a)
                ca++;
            else if(x==b)
                cb++;
        }
        vector<int> ans;
        if(ca>nums.size()/3)
            ans.push_back(a);
        if(cb>nums.size()/3)
            ans.push_back(b);
        return ans;
    }
};
```

### 230. Kth Smallest Element in a BST

> Tree

+ 这题本身没什么，附加问挺有意思的
+ 依然基于排序二叉树的模版，针对题目做适当的优化
  + 在二叉树添加和查找的时候，在每个节点维持做节点个数。

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
    int count = 0;
    int ans;
    bool f(TreeNode* root){
        if(!root)
            return false;
        if(f(root->left))
            return true;
        count--;
        if(count==0){
            ans = root->val;
            return true;
        }
        if(f(root->right))
            return true;
        return false;
    }
public:
    int kthSmallest(TreeNode* root, int k) {
        count = k;
        f(root);
        return ans;
    }
};
```

### 231. Power of Two


+ 是 2, 4, 8, 16, 32, 64 ...
+ 利用二进制中 1 的个数的那题，判断最高位

```
class Solution {
public:
    bool isPowerOfTwo(int n) {
        return n>0 && !(n&(n-1));
    }
};
```
### 232. Implement Queue using Stacks

> Stack

+ 在函数式不可变的数据结构中用得到

```cpp
class Queue {
    stack<int> s1;
    stack<int> s2;
    void enq(){
        while(!s2.empty()){
            s1.push(s2.top());
            s2.pop();
        }
    }
public:
    // Push element x to the back of queue.
    void push(int x) {
        s2.push(x);
    }

    // Removes the element from in front of queue.
    void pop(void) {
        if(s1.empty())
            enq();
        s1.pop();
    }

    // Get the front element.
    int peek(void) {
        if(s1.empty())
            enq();
        return s1.top();
    }

    // Return whether the queue is empty.
    bool empty(void) {
        return s1.empty() && s2.empty();
    }
};
```

### 233. Number of Digit One

> Integer


```
class Solution {
public:
    int countDigitOne(int n) {
        int a=0, b=1, c=1;
        while(n){
            a += (n + 8) / 10 * b; 
            if(n%10==1)
                a += c;
            c += (n%10)*b;
            b *= 10;
            n /= 10;
        }
        return a;
    }
};
```
### 234. Palindrome Linked List

+ 拿前面有道链表题改改就行

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
    ListNode* cut(ListNode* head){
        if(!head)
            return NULL;
        auto slow = head, fast = head;
        while(fast && fast->next && fast->next->next){
            slow = slow->next;
            fast = fast->next->next;
        }
        auto head2 = slow->next;
        slow->next;
        return head2;
    }
    ListNode* reverse(ListNode* head){
        ListNode* prev = NULL;
        while(head){
            auto next = head->next;
            head->next = prev;
            prev = head;
            head = next;
        }
        return prev;        
    }
public:
    bool isPalindrome(ListNode* head) {
        auto head2 = reverse(cut(head));
        for(auto p=head,q=head2; p&&q; p=p->next,q=q->next)
            if(p->val!=q->val)
                return false;
        return true;
    }
};
```

### 235. Lowest Common Ancestor of a Binary Search Tree

+ 已知根节点
+ 利用二叉排序树的节点值的关系

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
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        for(;;)
            if(root->val > p->val && root->val > q->val){
                root = root->left;
            }else if(root->val < p->val && root->val < q->val){
                root = root->right;
            }else{
                return root;
            }
    }
};
```

### 236. Lowest Common Ancestor of a Binary Tree

+ 递归，验证左右节点是否为父节点
  + 都不是，则自己是
  + 有一个是，在那边

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
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        if(!root || root==p || root==q)
            return root;
        auto left = lowestCommonAncestor(root->left, p, q);
        auto right = lowestCommonAncestor(root->right, p, q);
        if(left && right)
            return root;
        return left ? left : right;
    }
};
```

### 237. Delete Node in a Linked List

```
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    void deleteNode(ListNode* node) {
        auto next = node->next;
        assert(next);
        *node = *next;
        delete next;
    }
};
```

### 238. Product of Array Except Self

+ 题目要求不用除法，那就左右来回两趟
  + 左边乘以右边

```
class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        int n = nums.size();
        vector<int> ans(n);
        int c = 1;
        for(int i=0; i<n; i++){
            ans[i] = c;
            c *= nums[i];
        }
        c = 1;
        for(int i=n-1; i>=0; i--){
            ans[i] *= c;
            c *= nums[i];
        }
        return ans;
    }
};
```

### 239. Sliding Window Maximum

+ 求滑动窗口中的最大值序列
+ 用 deque 可以 实现 O(N)
+ 用 heap O(N LOG K)，直接实现 O(KN)
+ http://articles.leetcode.com/sliding-window-maximum/
+ http://www.cnblogs.com/yrbbest/p/5004596.html

```cpp
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        if(nums.size()<k || k==0)
            return {};
        vector<int> m;
        deque<int> q;
        for(int i=0; i<k; i++){
            while(!q.empty() && nums[i]>=nums[q.back()])
                q.pop_back();
            q.push_back(i);
        }
        for(int i=k; i<nums.size(); i++){
            m.push_back(nums[q.front()]);
            while(!q.empty() && nums[i]>=nums[q.back()])
                q.pop_back();
            while(!q.empty() && q.front()<=i-k)
                q.pop_front();
            q.push_back(i);
        }
        m.push_back(nums[q.front()]);
        return m;
    }
};
```

### 240. Search a 2D Matrix II

+ 从右上角/左下角开始搜索，往左下/右上方向进行

```cpp
class Solution {
public:
    bool searchMatrix(vector<vector<int>>& matrix, int target) {
        int m = matrix.size();
        if(m==0)
            return false;
        int n = matrix[0].size();
        int x = n-1, y=0;
        while(y<m && x>=0){
            if(matrix[y][x]==target){
                return true;
            }if(matrix[y][x]<target)
                y++;
            else{
                x--;
            }
        }
        return false;
    }
};
```

### 241. Different Ways to Add Parentheses

> Search

+ 表达式语法树，这里是二叉树
  + 每个符号都有机会做根节点
+ 不要遗漏解，挺容易遗漏的
+ 求全部解，笛卡尔积
  + 递归函数返回数组，或者使用回调
  + 存在左右子树两个方向，都各有若干可能
    + 这是这道题有趣的地方

```cpp
class Solution {
    const char* s;
    void f(int a, int b, function<void(int)> c){
        bool flag = false;
        for(int i=a; i<=b; i++){
            switch(s[i]){
                case '+':
                    flag = true;
                    f(a,i-1,[&](int x){
                        f(i+1,b,[&](int y){
                            c(x+y);
                        });
                    });
                    break;
                case '-':
                    flag = true;
                    f(a,i-1,[&](int x){
                        f(i+1,b,[&](int y){
                            c(x-y);
                        });
                    });                
                    break;
                case '*':
                    flag = true;
                    f(a,i-1,[&](int x){
                        f(i+1,b,[&](int y){
                            c(x*y);
                        });
                    });                
                    break;
            }
        }
        if(!flag){
            c(strtol(s+a,0,10));
        }
    }
public:
    vector<int> diffWaysToCompute(string input) {
        vector<int> ans;
        this->s = input.c_str();
        f(0,input.size()-1,[&](int z){
            ans.push_back(z);
        });
        return ans;
    }
};
```


### 242. Valid Anagram

+ 排序，或者哈希

```
class Solution {
public:
    bool isAnagram(string s, string t) {
        sort(s.begin(), s.end());
        sort(t.begin(), t.end());
        return s==t;
    }
};
```

```
class Solution {
public:
    bool isAnagram(string s, string t) {
        unordered_map<char,int> h;
        for(char x: s)
            h[x]++;
        for(char x: t)
            h[x]--;
        for(auto p: h)
            if(p.second)
                return false;
        return true;
    }
};
```


## 索引

归类

## 解答 1.5

有锁的题放这里

## 解答 2


以下用来尝试一些不那么好的解法。

有的是不符合题目的全部要求，有的就是随手写写的。

部分题目的解答

用 Ruby 

扩展想法用，写一些并不一定完全复合题目要求。

注意

+ Ruby 负数除法的取整方向和 C 不一样

### 1. Two Sum

+ array + hash

```ruby
def two_sum(nums, target)
  h = {}
  for x, i in nums.each_with_index
    return h[x], i if h.key? x
    h[target-x] = i
  end
end
```

### 2. Add Two Numbers

```ruby
def add_two_numbers(l1, l2)
    list = node = ListNode.new(nil)
    c = 0
    while l1 || l2 || c!=0
        if l1
            c += l1.val
            l1 = l1.next
        end
        if l2
            c += l2.val
            l2 = l2.next
        end
        node.next = ListNode.new(c%10)
        c /= 10
        node = node.next
    end
    list.next
end
```

### 3. Longest Substring Without Repeating Characters

```ruby
# @param {String} s
# @return {Integer}
def length_of_longest_substring(s)
  ans = 0
  h = Hash.new(-1)
  j = -1
  for c, i in s.each_char.with_index
    j = [j, h[c]].max
    h[c] = i
    ans = [ans, i-j].max
  end
  ans
end
```


### 17. Letter Combinations of a Phone Number

+ 回溯
+ 这题每一步不需要加条件，后面的回溯题会先过滤路径上的点。
+ 回溯的每一项是“或”的关系

```ruby
# @param {String} digits
# @return {String[]}
def letter_combinations(digits)
    h = ["","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"]
    f = ->(s){
        if s.empty?
            [""]
        else
            h[s[0].to_i].chars.flat_map{|x|
                f.(s[1..-1]).map{|y|
                    x+y
                }
            }
        end
    }
    digits.empty? ? [] : f.(digits)
end
```

```ruby
# @param {String} digits
# @return {String[]}
def letter_combinations(digits)
    h = ["","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"]
    f = ->(i){
        if i==digits.size
            [""]
        else
            h[digits[i].to_i].chars.flat_map{|x|
                f.(i+1).map{|y|
                    x+y
                }
            }
        end
    }
    digits.empty? ? [] : f.(0)
end
```

上面这个以后删掉

```ruby
# @param {String} digits
# @return {String[]}
def letter_combinations(digits)
    return [] if digits.empty?
    h = ["","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"]
    ans = []
    path = []
    f = ->(i){
        if i==digits.size
            ans.push path*''
        else
            for c in h[digits[i].to_i].chars
                path.push c
                f.(i+1)
                path.pop
            end
        end
    }
    f.(0)
    ans
end
```

写成用 Stack 的形式

```ruby
# @param {String} digits
# @return {String[]}
def letter_combinations(digits)
    h = ["","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"]
    ans = []
    stack = []
    stack.push(-1)
    while !stack.empty?
        stack[-1] += 1
        p stack
        if stack[-1]>=h[digits[stack.size-1].to_i].size
            stack.pop
        elsif stack.size==digits.size
            ans.push stack.map.with_index{|x,i|
                h[digits[i].to_i][x]
            }*''
        else
            stack.push(-1)
        end
    end
    ans
end
```

```ruby
def letter_combinations(digits)
    h = ["","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"]
    return [] if digits.empty?
    ans = []
    stack = []
    stack.push(-1)
    path = []
    while x = stack.pop
        if stack.size==digits.size
            ans.push path*''
            path.pop
            next
        end
        x += 1
        if x>=h[digits[stack.size].to_i].size
            path.pop
        else
            path.push(h[digits[path.size].to_i][x])
            stack.push(x)
            stack.push(-1)
        end
    end
    ans
end
```

```ruby
def letter_combinations(digits)
    h = ["","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"]
    return [] if digits.empty?
    ans = []
    stack = []
    stack.push(-1)
    path = []
    while !stack.empty?
        if stack.size>digits.size
            ans.push path*''
            path.pop
            stack.pop
            next
        end
        stack[-1] += 1
        if stack[-1]>=h[digits[stack.size-1].to_i].size
            path.pop
            stack.pop
        else
            path.push(h[digits[path.size].to_i][stack[-1]])
            stack.push(-1)
        end
    end
    ans
end
```


```ruby
def letter_combinations(digits)
    h = ["","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz"]
    return [] if digits.empty?
    ans = []
    stack = []
    stack.push(-1)
    path = []
    while !stack.empty?
        if stack.size>digits.size
            ans.push path*''
            stack.pop
            next
        end
        o = stack[-1]
        stack[-1] += 1
        if stack[-1]>=h[digits[stack.size-1].to_i].size
            path.pop if o!=-1
            stack.pop
        else
            path.pop if o!=-1
            path.push(h[digits[path.size].to_i][stack[-1]])
            stack.push(-1)
        end
    end
    ans
end
```

### 38. Count and Say

```ruby
def count_and_say(n)
    (n-1).times.inject("1"){|a,b|a.chars.chunk(&:itself).map{|k,v|"#{v.size}#{k}"}*''}
end
```

### 49. Group Anagrams

```ruby
def group_anagrams(strs)
    strs.group_by{|x|x.chars.sort}.values
end
```

### 51. N-Queens

```ruby
def solve_n_queens(n)
  a = [nil]*n
  b = [false]*n
  c = [false]*(2*n-1)
  d = [false]*(2*n-1)
  ys = []
  f = ->(i){
    if i < n
      for j in 0...n
        unless b[j] || c[i+j] || d[i-j+n-1]
          a[i] = j
          b[j] = c[i+j] = d[i-j+n-1] = true
          f.(i + 1)
          b[j] = c[i+j] = d[i-j+n-1] = false
        end
      end
    else
      ys << a.collect{|x|
          line = "."*n
          line[x] = ?Q
          line
      }
    end
  }
  f[0]
  ys
end
```

### 65. Valid Number

```ruby
def is_number(s)
    s=~/^\s*[-+]?(\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?\s*$/ ? true : false;
end
```

### 66. Plus One

```ruby
def plus_one(digits)
    (digits.size-1).downto(0) do |i|
        if(digits[i]!=9)
            digits[i] += 1
            return digits
        end
        digits[i] = 0
    end
    digits.unshift(1)
    return digits
end
```

### 78. Subsets

```ruby
def subsets(nums)
    (1<<nums.length).times.map{|i|nums.select.with_index{|x,j|(i>>j)&1==1}}
end
```

### 94. Binary Tree Inorder Traversal


```ruby
def inorder_traversal(root)
    result = []
    stack = []
    node = root
    while node || !stack.empty?
        while node
            stack << node
            node = node.left
        end
        node = stack.pop
        result << node.val
        node = node.right
    end
    result
end
```

```ruby
def inorder_traversal(root)
    result = []
    stack = []
    node = root
    while true
        if node
            stack << node
            node = node.left
        elsif !stack.empty?
            node = stack.pop
            result << node.val
            node = node.right
        else
            break
        end
    end
    result
end
```

### 102. Binary Tree Level Order Traversal

+ 二叉树层次遍历

```ruby
def level_order(root)
    result = []
    queue = []
    queue << root if root
    until queue.empty?
        result << queue.map(&:val)
        queue.size.times do
            node = queue.shift
            queue << node.left if node.left
            queue << node.right if node.right
        end
    end
    result
end
```

### 144. Binary Tree Preorder Traversal

```ruby
def preorder_traversal(root)
    result = []
    stack = []
    stack << root if root
    while node = stack.pop
        result << node.val
        stack << node.right if node.right
        stack << node.left if node.left
    end
    result
end
```

### 145. Binary Tree Postorder Traversal

```ruby
def postorder_traversal(root)
    result = []
    stack = []
    node = root
    prev = nil
    while true
        if node
            stack << node
            node = node.left
        elsif !stack.empty?
            node = stack.last
            if prev==node.right || node.right.nil?
                result << node.val
                prev, node = node, nil
                stack.pop
            else
                node = node.right
            end
        else
            break
        end
    end
    result
end
```

### 146. LRU Cache

+ 正好 Ruby 的 Hash 中的元素保持插入顺序

```ruby
class LRUCache

    def initialize(capacity)
        @capacity = capacity
        @hash = {}
    end

    def get(key)
        value = @hash.delete(key)
        if value
            @hash[key] = value
        else
            -1
        end
    end

    def put(key, value)
        @hash.delete(key)
        @hash.shift if @hash.size==@capacity
        @hash[key] = value
    end

end
```

### 208. Implement Trie (Prefix Tree)

```ruby
class Trie

    def initialize()
        @root = {}
    end

    def insert(word)
        node = @root
        word.each_char do |c|
            node = node[c]||={}
        end
        node[nil] = true        
    end

    def search(word)
        node = @root
        word.each_char do |c|
            node = node[c] or return false
        end
        node[nil]==true
    end

    def starts_with(prefix)
        node = @root
        prefix.each_char do |c|
            node = node[c] or return false
        end
        true
    end

end
```

### 217. Contains Duplicate

```ruby
def contains_duplicate(nums)
    h = {}
    nums.each do |e|
        return true if h[e]
        h[e] = true
    end
    false
end
```

```ruby
def contains_duplicate(nums)
    nums.sort!
    for i in 1...nums.size
        return true if nums[i]==nums[i-1]
    end
    false
end
```

### 224. Basic Calculator

```ruby
def calculate(s)
    ans = 0
    stack = [1]
    sign = 1
    s.scan(/\d+|[+\-()]/) do |x|
        case x
        when ?+
            sign = stack.last
        when ?-
            sign = -stack.last
        when ?(
            stack << sign
            sign = stack.last
        when ?)
            stack.pop
        else
            ans += sign*x.to_i
        end
    end
    ans
end
```

### 227. Basic Calculator II

```ruby
def calculate(s)
    ans = 0
    e = s.scan(/\d+|[+\-*\/]/)
    x = e.shift.to_i
    while op = e.shift
        y = e.shift.to_i
        case op
        when ?+
            ans += x
            x = y
        when ?-
            ans += x
            x = -y
        when ?*
            x *= y
        when ?/
            x = x.fdiv(y).to_i
        end
    end
    ans += x
end
```

## 解答3

Java 和 JavaScript



## 分类

### C++11

+ 在 OJ 中 C++98 支持得最广泛
  + 出于速度和输出格式的考虑，用 printf
  + 目前 LeetCode 中用的是 C++11
+ LeetCode 的有些题目是针对 C++/Java 设计的
+ C 中字符串指针在 C++ 中只读时可以使用，可以转换为用下标
  + 数组也可以用指针，vector 只能用下标了。
  + C 的字符串后缀是递归的数据结构
+ 比 C++98 多了 hashtable
  + 有的情况可以用排序
    + 二分法查找
    + 重复元素相邻排列
  + 或者用数组
    + key 少的时候用下标
    + 线性探测法，特别是不删，有限的时也挺简单
+ vector尽量预先分配大小
+ 有 move 之后可以直接返回 vector 了
+ 比 Java 多了引用，链表问题中 next 的指针可以转换为添加一个头节点
+ 和 Python 相比，有大括号和分号
+ 内存管理，C++ 没有 Java 的 GC，相比 C 有 C++ 可以利用作用域
  + 算法题可以利用程序结束释放所有内存
+ IO 函数 C 比 C++ 快，所以为了充分利用运行时间，尽量用 C 的
+ 死循环或者复杂度太高会超时，下标越界或空指针会运行时错误
  + 越界错误有时候本地会继续运行会未报错
+ STL
  + C 的 string，qsort，bsearch
+ 假设 Accepted 的解答为结果正确的解答
  + LeetCode 有的题目在提交后会又有改动
  + 原先 C++ 参数传数组改为用 STL
  + 有个解答原来不超时的变得超时了
+ freebsd 可以看一些标准库的实现
+ 感觉最初 LeetCode 是一个可以刷题的 Blog
  + 老文 URL 改了，还可以看，感觉质量比更高
  + http://articles.leetcode.com/
+ 提交结果
  + Runtime Error 越界，爆栈，空指针
    + 后来开始返回错误信息了。。。
  + Time Limit Exceeded 复杂度，死循环
  
+ 参考资料
  + http://en.cppreference.com
  + LeetCode题解（灵魂机器） http://github.com/soulmachine/leetcode
    + 有的题目给出多种思路，并且把同类型的解答归类整理
    + 通过基础问题的扩展和组合可以应对更多的新的问题
  + MaskRay 的解答 http://github.com/MaskRay/LeetCode/
    + 技巧性非常强解法
  + LeetCode 的博客有一些解答，部分题目后面也有解答
    + 老的首页上的文章，目前在 http://articles.leetcode.com/
  + http://www.programcreek.com/2012/11/top-10-algorithms-for-coding-interview/
  + http://www.geeksforgeeks.org/  
  + http://bookshadow.com/leetcode/
    + Python 为主
  + http://blog.csdn.net/qq508618087/article/category/5910619
    + http://m.blog.csdn.net/blog/index?username=qq508618087&categoryid=5910619    
  + http://www.cnblogs.com/grandyang/p/4606334.html




  + 删掉，看更新 http://tigerhunter.gitbooks.io/crackingleetcodeincpp/
  + http://www.acmerblog.com/leetcode-solutions-6422.html

  + 删掉 http://www.cnblogs.com/yrbbest/
  + http://www.cnblogs.com/EdwardLiu/category/586733.html
  
  
  + http://blog.csdn.net/xudli
  + http://www.jianshu.com/nb/1330981

  + 删除 https://shenjie1993.gitbooks.io/leetcode-python/content/
  + http://blog.csdn.net/lanxu_yy/article/details/17848219



  + http://www.tangjikai.com/leetcode-solutions.html
  + 删除 http://algorithm.yuanbin.me/zh-hans/ 这个不太好。
  + 删除 http://lib.csdn.net/article/31/53561?knId=805
  + 删除 http://www.cnblogs.com/liujinhong/

+ 其他
  + 删掉，有了 http://m.blog.csdn.net/blog/index?username=qq508618087&categoryid=5910619

  + 删掉 http://blog.csdn.net/booirror
+ 一些解答

+ 其他解答
  
+ 没细看，或者不太好的解答
  + 删除 http://shenjie1993.gitbooks.io/leetcode-python/
  + https://asanchina.wordpress.com/category/leetcode/
  + http://www.tangjikai.com/leetcode-solutions.html
  + http://likemyblogger.blogspot.com/
  
+ LeetCode 的变化
  + 以前是不返回错误信息的。


## 总结

### 注意

+ 考虑边界情况和异常情况
  + 递归溢出
+ 自行设计测试用例，更多情况不像 LeetCode 有提供的可以依赖
+ 死循环的时候 Debug
+ 使用 printf scanf
+ 分析题干中的要求，运用基本的模型，分解为步骤的组合
  + 有时候题目对输入有限定
+ 用符合题目要求的，比较好实现的解答就可以了
+ 坑
  + .size() 为 unsigned，-1 会不对

### 问题

整数
+ 32位补码有符号整数范围 $[-2^{31},2^{31}-1]$ ，最小负数取相反数会溢出
+ 在 C 中负数取模为负数，不同语言有不同规则
+ 负数右移是除以2向下取整数，除法是向零取整数。
+ 有符号，无符号位移

数组/链表
+ 数组和链表都可以按顺序访问
  + 数组还可以按下标随机读写
  + 链表有节点指针变换的问题
  + 都可以插入排序、选择排序
+ 链表
  + 有时候可以构建一个额外的头结点
  + 注意元素个数为 0, 1, 2 的情况
+ 数组

栈，队列
+ 可以用数组或链表实现

树/二叉树
+ 递归遍历能应对大部分问题

图
+ 有些状态机可以作为图
+ 深度优先搜索用 Stack，广度优先搜索用 Queue
  + 取出元素时处理
  + 将相邻节点插入
    + 有环图已搜索过的相邻节点不再插入
+ 最短路径
  + 举例为 1 时 变成广度优先搜索
  + 使用优先级队列


查找
+ 二分查找

排序
+ 快排，堆排

回溯
+ 递归实现
+ 典型问题
  + 八皇后
  + 排列组合
  + 深度优先搜索
+ 短路可以通过检查返回值快速返回
+ 递归用栈写成迭代形式，并不能降低复杂度。
  + 对提交代码的结果没有影响，除非题目对实现方案有特定要求
  
+逻辑/搜索问题 and 和 or

+ 排列组合
  + 使用回溯法解答，通常写成递归形式
  + 集合是无序的
  + 全排列中升序的序列构成组合
  + 有重复元素时，重复元素的顺序改变同一个排列
  + 集合元素可以用转换为用下标（索引）表示

动态规划
+ 重叠

字符串
+ 作为数组问题处理
+ 实现 libc 如 函数 `strstr` `memmove`

质数/数论
+ 因式分解

C 语言
+ 有些 C 语言的问题没在数据结构书中出现，也有出现的
+ memmove

### 补充

C的输入输出语句

## CHANGELOG


