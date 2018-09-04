# Python Tools and Principles


## 数学基础

### 向量

向量 
+ 向量加法、数乘 $c=xa+yb$、矩阵形式 c=Ax
+ 坐标 (x,y)' 基 a b 标准正交基
线性运算
+ T(a+b) = T(a)+T(b)
+ 基变换，同一个向量在不同基下的坐标
+ 拉伸（对角矩阵）
矩阵分解
+ 相似，特征值不变
+ 合同，内积不变
内积
+ y=x'x
多项式
+ y = x'Ax+x'B+C

### 统计

统计量（总体、样本）
+ 均值
+ 方差 标准差
+ 协方差 相关系数
+ 统计量的分布
分布
+ 大数定律，正态分布，叠加
+ 正态分布 3 sigma
+ 分布函数
参数估计
+ 最大似然估计
+ 区间估计
检验
+ 均值，方差，双侧
+ 显著性
概率问题的计算
+ 条件概率

### 微分

级数
+ 泰勒级数

极限

微分
+ 定义，通过极限求微分，常见的微分，法则
+ 应用
+ 多元微分的应用
积分
+ 微分的逆运算
+ 计算，多元积分
+ 几何和物理应用

微分方程
+ 求解


## 模型


### 线性回归



PCA、SVD












## 统计学习

原理与模型


特征选择

回归（拟合，分类）

聚类（无监督学习）

最优化
损失函数 正则化
梯度下降

模型参数选择
+ 准确度



## 统计



统计

总体 Population 

+ 标量
+ 期望 均值 mean e  $\mu$ 
+ 方差 variance $\sigma^2$
  + 标准差

样本 Sample

+ 样本均值 sample mean $\overline{X}$
+ 样本方差 $s^2$


分布
+ 概率
+ 正态分布 Normal distribution
  + Z检验 Z-test



统计学 - 维基百科，自由的百科全书
https://zh.wikipedia.org/wiki/%E7%BB%9F%E8%AE%A1%E5%AD%A6

central tendency
+ 均值  mean


众数mode：数据中出现频率最多的数字。
中位数：在 n 个数据由大到小排序后，位在中间的数字。
算术平均数：n个数据相加后除以n。
几何平均数：n个数据相乘后开 n 次方。
调和平均数：n个数据的倒数取算术平均，再取倒数。
平方平均数（也称“均方根”）：n 个数据的平方取算数平均，再开根号。
移动平均数

离散程度 dispersion
+ 方差 Variance var $\sigma^2$
  + “平方和的平均”减去“平均的平方”。
  + Population(总体) variance and sample variance
  + 样本方差 $s^2$  follows a scaled chi-squared distribution
  + Distribution of the sample variance
  + 标准差 Standard Deviation \sigma s 方差的算术平方根 相差k个标准差 x+-ks
+ 样本方差 #
  + 期望
  + 分布 follows a scaled chi-squared distribution 期望 方差
  
变异系数，又称“离散系数”（英文：coefficient of variation），是概率分布离散程度的一个归一化量度，其定义为标准差 {\displaystyle \ \sigma } \ \sigma 与平均值 {\displaystyle \ \mu } \ \mu 之比

range 最大值减最小值后所得数值。
四分位数 箱形图

Mean squared error MSE 均方误差
第一个估计函数为最大似然估计，它是有偏的，即偏差不为零，但是它的方差比第二个小。而第二个估计函数是无偏的。较大的方差某种程度上补偿了偏差，因此第二个估计函数的均方误差比第一个要大。

分布 distribution

+ 概率 
  + 归一条件（归一化，英语：be normalized 概率必须等于 {\displaystyle 1} 1 
+ 正态分布
  + Z检验 根据中央极限定理 p值 if the sample size is large or the population variance is known
 If the population variance is unknown (and therefore has to be estimated from the sample itself) and the sample size is not large (n < 30), the Student's t-test may be more appropriate.
单侧或双侧的p值可以用标准累积分布函数Φ来计算，分别为Φ(?Z)（上侧） Φ(Z)（下侧）和 2Φ(?|Z|) （双侧）。

+ 卡方分布 chi-squared distribution
+ t检验
  + 单样本检验：检验一个正态分布的总体的均值是否在满足零假设的值之内
  + 双样本检验：其零假设为两个正态分布的总体的均值之差为某实数
  + “配对”或者“重复测量”t检验：检验同一统计量的两次测量值之间的差异是否为零。
  + 检验一条回归线的斜率是否显著不为零。
+ F-分布 假设一系列服从正态分布的母体，都有相同的标准差 F检验的分子、分母其实各是一个卡方变数除以各自的自由度



联合分布 两个随机变量 X 和 Y
+ 协方差 Covariance  两个变量的变化趋势一致
  + 独立 => 0
  + 线性相关性 [－1, 1] 线性不相关 0
  + 协方差矩阵 列向量随机变量X 与Y，
  
零假设，在该假设中，所有因素对变量都不起任何作用。零假设H0认为被告是清白的，证据无法将其定罪。

误差
+ 第一型错误中零假设被错误地证伪，得出测试结果为“假阳性”。
+ 第二型错误中零假设没有被及时排除，母群体中的实际差异被错误判断为“假阴性”。

误差最小化，这种方法 被称之为“最小二乘法”。
区间估算 95%置信区间 贝叶斯概率
显著性差异

显著性差异
主条目：显著性差异
对于给出的问题，统计学很少回答简单的是或否。它的解释常常是以统计的显著性差异出现，汇报可以将零假设精确证伪的概率值（这也被称作是p值、假定值）。

回归分析
时间序列分析

分贝（decibel）是量度两个相同单位之数量比例的单位
测量值与参考量值之比计算基于10的对数，再乘以10

https://github.com/python/cpython/blob/3.7/Lib/statistics.py





statistics

1. sampling
1. descriptive statistics
1. analysis of variance anova
1. correlation
1. covariance
1. exponential smoothing
1. moving average
1. regression
1. paired t-test
1. F-test
1. z-test
1. chi-square Test







Excel

+ sort
+ filter
+ range
+ pivot table
+ validity
+ subtotal
+ form
+ group outline

chart
+ 折线图
+ 直方图

pandas

```python
def read_csv(filename):
    pass

```

plot



dates = pd.date_range('1950-01', periods = input_data.shape[0], freq = 'M')

timeseries.plot()

plt.figure()
timeseries.plot()
plt.show()



数据挖掘


## 拟合

## ML

sklearn

from sklearn import linear_model

keras

pytorch

指标


## Vision



### PIL/pillow

image magic

### OpenCV

`import cv2` 

 读写显示

+ imread
+ imshow
+ imwrite

色彩

+ cvtColor  `gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)`

绘图

filter

阈值

变换

+ 仿射变换



+ 人脸识别 haarcascades
+ 边缘检测 Canny



https://www.yiibai.com/opencv/opencv_writing_image.html



## NLP



NLTK

jieba



## Web

requests

```python
import requests
session = requests.Session()

def http_get(url):
	r = session.get(url, timeout=60)
	r.raise_for_status()
	return r
```

ajax

```python
class RestClient:
    
    def __init__(self, host):
        self._host = host
        self._s = requests_html.HTMLSession()


    def get(self, path, data=None):
        r = self._s.get(self._host+path, params=data)
        return r.status_code, r.json()


    def post(self, path, data=None):
        r = self._s.post(self._host+path, json=data)
        return r.status_code, r.json()
    
    
```



BeautifulSoup

```python
from bs4 import BeautifulSoup

doc = BeautifulSoup(text, 'lxml')
elements = doc.select(...)


```

requests_html



Selenium

```python
from selenium import webdriver

browser = webdriver.Chrome()
browser.get("http://www.google.com")
element = browser.find_element_by...(...)
element.click()
```







Django



Flask





draft



datetime.now().date() + timedelta(days=1)

```r
x <- 1:10
y <- 23*x+rnorm(length(x))
m <- lm(y~x)
summary(m)
par(mfrow=c(2, 2))
plot(m)
```

## 数据库接口

sql

## 工具箱





## 附录

### 安装

Python 3

```
pip install numpy
pip install ipython
```

Miniconda

```bash
coda install anaconda
```




## Matlab

版本 5.3 7.1


### 绘图
折线图 plot

其他类型
+ bar
+ pie
+ mesh
+ area
+ hist
+ scatter 散点图
+ surf
+ contour


newff


### stats

### image

imread
imshow


Octave

nnet Neural Network Package for Octave

### nnet

## Python



### sqlite3

```python
import sqlite3
conn = sqlite3.connect("database.sqlite")
conn.execute("...")
conn.commit()
```

### mysql

```python
import mysql.connector

conn = mysql.connector.connect(user='root', password='password', database='test')
cursor = conn.cursor(buffered=True, dictionary=True)
cursor.execute("select * from table1")
cursor.fetchall()
conn.commit()

```

cursor.lastrowid


### requests


### Socket

TCP ACK

### thread

pool
map


## OpenGL


```python

from OpenGL.GL import *
from OpenGL.GLU import *
from OpenGL.GLUT import *
import sys
import numpy as np
 
# 画圆
def circle(x, y, r, n):
    theta = np.linspace(0, 2*np.pi, n)
    x = x + r * np.cos(theta)
    y = y + r * np.sin(theta)
    return x, y
def plotfunc():
    glClear(GL_COLOR_BUFFER_BIT)        # 清除之前缓存
 
    glPointSize(3.0)                    # 设置点大小
    glColor3f(1.0, 0.0, 0.0)            # 设置点颜色
    glBegin(GL_POINTS)                  # 此次开始，设置此次画的几何图形
    x, y = circle(0, 0, 1, 100)
    for x_, y_ in zip(x, y):
        glVertex2f(x_, y_)
    glEnd()                             # 此次结束
 
    glFlush()                           # 刷新屏幕
 
if __name__ == '__main__':
    glutInit(sys.argv)  #初始化
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB) #设置显示模式
    glutInitWindowPosition(100, 100)    #窗口打开的位置，左上角坐标在屏幕坐标
    glutInitWindowSize(900, 600)        #窗口大小
    glutCreateWindow(b"Function Plotter")   #窗口名字，二进制
    glutDisplayFunc(plotfunc)           #设置当前窗口的显示回调
    glClearColor(1.0, 1.0, 1.0, 1.0)    # 设置背景颜色
    gluOrtho2D(-5.0, 5.0, -5.0, 5.0)    # 设置显示范围
    glutMainLoop()                      # 启动循环


```

## Processing


## 其他
maxima

synaptic

## 

Basic statistics
Pipelines
Extracting, transforming and selecting features
Classification and Regression
Clustering
Collaborative filtering
Frequent Pattern Mining
Model selection and tuning
Advanced topics


Data types
Basic statistics
Classification and regression
Collaborative filtering
Clustering
Dimensionality reduction
Feature extraction and transformation
Frequent pattern mining
Evaluation metrics
PMML model export
Optimization (developer)

imagemagic








