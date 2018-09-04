# C 语言

## 介绍

## 数据类型

基本类型

+ unsigned char 单字节,范围 0~255 
+ int
+ double

复合类型

+ 数组 array
+ 结构 struct
+ 地址 address p=&x *p=x

常量: 
+ 整型常量: 例如 -1,100,0x4000,'a' 
+ 字符串常量: 例如 "GVmaker" 

变量名命名规则

常量
`#define`

## 表达式

运算符和优先级
1. () 圆括号
[] 下标运算符
2. ! 逻辑非运算符
~ 按位取反运算符
++ 自增运算符
-- 自减运算符
- 负号运算符
* 地址运算符(不同于c,后面有详细介绍)
3. * 乘法运算符
/ 除法运算符
% 求余运算符
4. + 加法运算符
- 减法运算符
5. << 左移运算符
>> 右移运算符
6. == != >= <= > < 关系运算符
7. & 按位与运算符
| 按位或运算符
^ 按位异或运算符
8. && 逻辑与运算符
|| 逻辑或运算符
9. = 赋值运算符
所有2级运算符都是单目运算符.其余都是双目运算符.
除2级运算符外,所有运算的结合方向都是自左至右.

## 语句


### 控制语句

if () ~ else ~
for () ~
while () ~
do ~ while ()
continue
break
goto
return
switch () {case :~}


### 函数调用

printf("hello");

### 空语句

;

### 复合语句

{}


## 函数和编译预

```c
int add(int x,int y)
{
return x+y;
}
```

返回类型默认 int

编译预处理只支持下面格式: #define 标识符 整型常量

```c
#define NULL 0
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#define EOF -1
```

## 附录


### 字符的输入输出函数
void putchar(char c) 字符c输出到屏幕
void printf(addr format,args,...) 字符串输出到屏幕
char getchar() 等待用户输入一个字符
+ scanf


### 字符函数和字符串函数

int isalnum(char ch)
int isalpha(char ch)
int iscntrl(char ch)
int isdigit(char ch)
int isgraph(char ch)
int islower(char ch)
int isprint(char ch)
int ispunct(char ch)
int isspace(char ch)
int isupper(char ch)
int isxdigit(char ch)

int strlen(addr str)
int strcmp(addr str1,addr str2)
void strcat(addr str1,addr str2)
void strcpy(addr str1,addr str2)
addr strchr(addr str,char ch)
addr strstr(addr str1,addr str2)

char tolower(char ch)
char toupper(char ch)


### 文件操作函数

char fopen(addr filename,addr mode)
void fclose(char fp)

int fread(addr pt,int size,int n,char fp)
int fwrite(addr pt,int size,int n,char fp)
int putc(char ch,char fp)
int getc(char fp)

int fseek(char fp,long offset,char base)
long ftell(char fp)
int feof(char fp)
void rewind(char fp)


### 其他函数

void Delay(int ms) 延时ms个毫秒,ms最大取值32767(即:32.7秒).
void exit(int exitcode) 退出lava程序.exitcode为退出码

long abs(long x) 取x的绝对值
long rand() 返回一个32位的随机数
void srand(long x) 用x初始化随机数发生器
void Beep() 发出"滴"的声音

void memset(addr data,char val,int size) 把内存地址data开始的size个字节改写为val
void memcpy(addr data1,addr data2,int size) 把内存地址data2开始的size个字节复制
到内存地址data1处 说明:  src和dest所指内存区域不能重叠
void sprintf(addr str,addr format,args,...) 把一个格式字符串输出到str字符串.

time 时间 

### 相关工具

编译器 gcc
调试 gdb

### 程序及源码

## 参考资料

+ 文曲星LAVA语言使用教程
