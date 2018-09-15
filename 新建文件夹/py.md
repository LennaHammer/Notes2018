# Python Tools and Principles


## 数学基础

### 向量

向量 
+ 向量加法 $\alpha+\beta$、数乘$k\alpha$
+ 基 a b 标准正交基
+ 坐标 (x,y)'  即 $c=xa+yb$、矩阵形式 y=Ax 列向量构成矩阵*列向量形式的坐标

线性运算
+ T(a+b) = T(a)+T(b)，T(ka)=kT(a)
+ 基变换，同一个向量在不同基下的坐标
+ 拉伸（对角矩阵）

矩阵分解
+ 相似，特征值不变
+ 合同，内积不变

内积
+ y=x'x

多项式
+ y = x'Ax+x'B+C

线性方程组与行列式
+ 解的结构，求解（上三角行列式）


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
+ 二维分布，函数的分布

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
+ 收敛性，收敛域
+ 幂级数，傅里叶级数

极限

微分
+ 定义，通过极限求微分，常见的微分，计算法则 多元微分 
+ 应用 导数（梯度） 极值（一元单调性，多元，最值） 零点存在（证明）
+ 多元微分的应用

积分
+ 微分的逆运算
+ 计算，一元，多元积分，面积 体积
+ 几何和物理应用 弧 面 体 上的积分 第一类，第二类（有方向）


微分方程
+ 求解（方程+初始值） 一阶 二阶


## 数值计算

求根


## ML

系数向量 点乘 特征向量 = 输出标量
系数向量 乘 特征矩阵 = 输出向量

$y = w \cdot x+b$

$y=\tanh(w\cdot x+b)$

y 的范围
+ 任何值
+ 0 ~ 1
+ -1 ~ +1

损失函数
+ $L=(y-\hat{y})^2$
+ 

罚项 正则项



最小二乘法
最大似然



## 模型


### 线性回归



PCA、SVD












## 统计学习

原理与模型


特征选择

回归（拟合，分类）

聚类（无监督学习）

最优化
损失函数
正则化
梯度下降

模型参数选择
+ 准确度
+ 召回率



## 统计（废弃）



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


### 回归

## 数值计算（废弃）

零点
极值
拟合
插值
矩阵
统计


## ML


### 特征提取和预处理

### 模型



### 调参
超参数
验证
损失函数 正则化
梯度下降



### 最优化

梯度下降
拟牛顿法

### 协同过滤




sklearn

from sklearn import linear_model

keras

pytorch

theao

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






NLTK

jieba





datetime.now().date() + timedelta(days=1)

```r
x <- 1:10
y <- 23*x+rnorm(length(x))
m <- lm(y~x)
summary(m)
par(mfrow=c(2, 2))
plot(m)
```

## 附录


### 安装

运行环境
+ Python3
+ Anaconda/Miniconda

安装第三方库
+ pip install ...
+ coda install ...


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





### stats

### image

imread
imshow




Octave

nnet Neural Network Package for Octave

### nnet

newff


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

requests

```python
import requests
session = requests.Session()
r = session.get(url, timeout=60)
r.raise_for_status()
print(r)


```

设置 headers

```python
HEADERS = {

}
requests.session.update('headers', HEADERS)
```

设置 cookies，会自动更新

```python

```

BeautifulSoup

```python
from bs4 import BeautifulSoup

doc = BeautifulSoup(text, 'lxml')
elements = doc.select(...)


```

requests_html

```python
session = requests_html.HTMLSession()
r = session.get(url, timeout=60)
r.raise_for_status()
title = r.html.find('title')[0]

```


Selenium

```python
from selenium import webdriver

browser = webdriver.Chrome()
browser.get("http://www.google.com")
element = browser.find_element_by...(...)
element.click()
```

### Socket

TCP ACK

### thread

pool
map

send、recv fork、join
### gevent

### OpenGL


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

### sklearn


步骤
1. 整理数据
2. 选择模型和超参数
3. 训练模型
4. 测试模型

步骤
1. 特征选择
2. 回归聚类
2. 超参数选择



数据类型 numpy



```python
#%%

# Loading a dataset
from sklearn import datasets
iris = datasets.load_iris()
X, y = iris.data, iris.target
print(X) # (n_samples, n_features)

# Estimator
from sklearn import svm
clf = svm.SVC(gamma=0.001, C=100.) # Choosing the parameters of the model
clf.fit(X[:-1], y[:-1])

# 预测
clf.predict(X[-1:])

# Model persistence
import pickle
s = pickle.dumps(clf)

# model selection 
cross_val_score(svc, X_digits, y_digits, cv=k_fold, n_jobs=-1)



```

Datasets
preprocessing
set_params


Estimators
+ parameters
+ 超参数


KNN k-Nearest neighbors classifier
Linear regression
Shrinkage and sparsity with logistic regression
Support vector machines


OneVsRest

Model selection

test set

Score

Cross-validation


Choosing the right estimator

挑选的步骤
1 问题类型，2 样本数，3 数据类型，4 效果如何


判别 聚类
回归 降维


数据
文本 Tokenizing  tf–idf
图像
数值


### PyGame

用途
+ 游戏
+ 交互


循环
+ 事件 鼠标，键盘，队列
+ 定时 30帧，更新游戏状态 可以读取按键状态
+ 渲染 可以跳过，且跳过时不会影响逻辑 可以读取按键状态



```python
import pygame

pygame.init()
# print(pygame.font.get_fonts())
screen = pygame.display.set_mode((480, 320))
screen.fill((255, 255, 255))

md = 0
ox = 0
oy = 0

while 1:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
        elif event.type == pygame.MOUSEBUTTONDOWN:
            md = 1
            ox, oy = event.pos
        elif event.type == pygame.MOUSEBUTTONUP:
            if md == 1:
                pygame.draw.line(screen, (0, 0, 0), (ox, oy), event.pos)
                md = 0
        elif event.type == pygame.MOUSEMOTION:
            if md == 1:
                pygame.draw.line(screen, (0, 0, 0), (ox, oy), event.pos)
                ox, oy = event.pos
    
    pygame.display.flip()
    pygame.time.wait(1000//30)

```


### NLTK

查找文章中某个单词出现的句子

```python
import nltk

text = nltk.corpus.gutenberg.raw('austen-emma.txt')
sents = nltk.sent_tokenize(text)
index = {}
porter = nltk.PorterStemmer()
for sent in sents:
    tokens = nltk.word_tokenize(sent)
    for word in tokens:
        stem = porter.stem(word)
        if stem not in index:
            index[stem] = []
        index[stem].append(sent)

print(index[porter.stem("influence")])

```

词性标注

```python
```

文章分类

```python
```

### PIL/Pillow




### OpenCV

人脸识别

```python
import numpy as np
import cv2

face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

img = cv2.imread('Lenna.png')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

faces = face_cascade.detectMultiScale(gray, 1.3, 5)
for (x,y,w,h) in faces:
    cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)

cv2.imshow('img',img)
cv2.waitKey(0)
cv2.destroyAllWindows()

```



### Sympy


符号计算

```python
from sympy import *

x = symbols('x')
print(diff(exp(x)*sin(x**2), x))
#  2*x*exp(x)*cos(x**2) + exp(x)*sin(x**2)

```


### Matplotlib

类似 Matlab 的绘图函数

```python
import numpy as np
from matplotlib import pyplot as plt

x = np.arange(0., 5., 0.1)
y = np.sin(x)
plt.plot(x, y)
plt.show()

```



## R


线性回归

```r
x <- 1:10
y <- 23*x+rnorm(length(x))
m <- lm(y~x)
summary(m)
par(mfrow=c(2, 2))
plot(m)
```

Residual standard error: 0.7298 on 8 degrees of freedom
Multiple R-squared:  0.9999,    Adjusted R-squared:  0.9999 
F-statistic: 8.26e+04 on 1 and 8 DF,  p-value: < 2.2e-16

pars

iris

罗吉斯特回归

非线性回归
最小二乘法
最大似然
假设验证

## 概念

### 梯度下降（最优化）

求函数的最小值

y=(x+1)^2+3

求导 y' = 2(x+1)=0
得 x=-1,y=3
y''=2

y=x^2+y^2

可求

### tf-idf

词频高的词可以作为文档的关键词，但是stop-words词频很高，所以利用语料库，

term frequency–inverse document frequency
利用语料库对文档中的词频修正
$ tf-idf=tf*idf $
文档
语料库
某词在文档中出现越多的，在语料库中出现越少，值越大 stop-words，小


### Perceptron

输入为向量，输出为 0 1
$ f(x) = \begin{cases}1 & \text{if }w \cdot x + b > 0\\0 & \text{otherwise}\end{cases} $
$ w \cdot x = \sum_{i=1}^m w_i x_i $


## Demo


## Processing


## 其他工具

maxima
Mathematica


synaptic xiapan


## Draft

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









# 科学计算笔记（废弃！）


### 数学

包括
+ 数值计算
+ 统计

### Matlab

### R

数据类型


vector

list

dataframe

model

### Mathematica

### Python 科学工具箱


侧重不同类型的问题有对应的解决方案

淡化库的细节

### 说明


发行版
+ Anaconda 
+ WinPython winpython.github.io

IDE
+ PyCharm

相关软件
+ matlab
+ Mathematica
+ R

## Scipy

http://www.scipy.org/

### NumPy

提供 `多维数组` 类型

基础

> Array 源于 APL 语言，在 Matlab 和 R中，
> 性能好于 python 内置的 list

二维数组进行矩阵运算

```python
import numpy as np
x = np.array([[1, 2], [3, 4]])
y = np.array([[1, 2, 3], [4, 5, 6]])
np.dot(x,y)
# array([[ 9, 12, 15],[19, 26, 33]])
```

数组上的标量函数对每个元素分别计算

```python
np.sin(np.array([0, np.pi/2]))
# array([ 0.,  1.])
```

维数不一致时自动扩充

```python
np.array([1, 2, 3]) + 1
# array([2, 3, 4])
np.array([[1, 2], [3, 4]]) + np.array([1,2])
# array([[2, 4],[4, 6]])
```

注意：
切片是共享数据的

### SciPy

最优化

### Matplotlib

Pyplot 模块，提供了类似 Matlab 的绘图函数
不过认为没有 ggplot2 美观好用

```python
import numpy as np
from matplotlib import pyplot as plt
x = np.arange(0., 5., 0.1)
plt.plot(x, np.sin(x))
plt.show()
```

### IPython

提供交互环境

Notebook
+ http://try.jupyter.org/


  https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks
  https://github.com/jdwittenauer/ipython-notebooks

### Sympy

http://www.sympy.org/

符号计算

```python
from sympy import *
x = symbols('x')
print(diff(exp(x)*sin(x**2), x))
#  2*x*exp(x)*cos(x**2) + exp(x)*sin(x**2)
```

### pandas

用于处理数据表，提供 DataFrame，类似 Excel 和 SQL
基于 Numpy，和矩阵相比，表格有表头，列的类型相同
用于处理数据与分析

> 类似 R 中 `data.frame`

```
import pandas as pd
read_table
datetime
```

## NLP

### NLTK

Natural Language Processing with Python

http://nltk.org/book
http://www.nltk.org/howto/



词性标注

**例子1**

查找文章中某个单词出现的句子

> 涉及 1.分词 2.分句 3.提取词干

```python
import nltk
text = nltk.corpus.gutenberg.raw('austen-emma.txt')
sents = nltk.sent_tokenize(text)
index = {}
porter = nltk.PorterStemmer()
for sent in sents:
    tokens = nltk.word_tokenize(sent)
    for word in tokens:
        stem = porter.stem(word)
        if stem not in index:
            index[stem] = []
        index[stem].append(sent)
print(index[porter.stem("influence")])
```


例子2 词性标注

```

```


例子2
文章分类
```

```

### jieba

## Image

### OpenCV


http://docs.opencv.org/3.2.0/d6/d00/tutorial_py_root.html

OpenCV 的 Python 绑定用到 numpy 的矩阵上

numpy 和 opencv 的矩阵运算的函数都可以使用


**人脸识别**

```python
import numpy as np
import cv2
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
img = cv2.imread('Lenna.png')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
faces = face_cascade.detectMultiScale(gray, 1.3, 5)
for (x,y,w,h) in faces:
    cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)
cv2.imshow('img',img)
cv2.waitKey(0)
cv2.destroyAllWindows()
```

### pillow

可以进行简单的文件读写


## ML

### scikit-learn

http://scikit-learn.org/


fit/predict


tf-idf


sklearn 的模型提供 `fit/learn` 的接口
输入的矩阵，是 matlab 的转置

```python
from sklearn import datasets
iris = datasets.load_iris()
x, y = iris.data, iris.target

from sklearn import svm
m = svm.SVC()
m.fit(x[:-1], y[:-1])
m.predict(x[-1:])==y[-1:]

from sklearn.model_selection import cross_val_score
cross_val_score(m, x, y)
```


```python
digits = datasets.load_digits()
x, y = digits.data, digits.target
```

datasets.fetch_mldata('MNIST original')



### theano
### keras



## Web

### Requests

### BeautifulSoup

### Selenium

载入浏览器，并模拟操作

> Selenium 本身支持多种语言，和多种浏览器

模拟Forrm操作

获取Cookies可以用 requests模块读取内容

## UI

### Web

### TK

## 内置库

socket


## 其他

## Java

### CoreNLP
### Elasticsearch




### 线性回归

```r
x <- 1:10
y <- 23*x+rnorm(length(x))
m <- lm(y~x)
summary(m)
par(mfrow=c(2, 2))
plot(m)
```

Residual standard error: 0.7298 on 8 degrees of freedom
Multiple R-squared:  0.9999,    Adjusted R-squared:  0.9999 
F-statistic: 8.26e+04 on 1 and 8 DF,  p-value: < 2.2e-16

pars

iris




## 数学原理


### 最优化

求函数的最小值

y=(x+1)^2+3

求导 y' = 2(x+1)=0
得 x=-1,y=3
y''=2

y=x^2+y^2

可求

### tf–idf

词频高的词可以作为文档的关键词，但是stop-words词频很高，所以利用语料库，

term frequency–inverse document frequency
利用语料库对文档中的词频修正
$ tf-idf=tf*idf  $
文档
语料库
某词在文档中出现越多的，在语料库中出现越少，值越大 stop-words，小



### 降维

## 数学模型

### Perceptron

输入为向量，输出为 0 1
$ f(x) = \begin{cases}1 & \text{if }w \cdot x + b > 0\\0 & \text{otherwise}\end{cases} $
$ w \cdot x = \sum_{i=1}^m w_i x_i $


学习

http://www.mathworks.com/help/nnet/ref/perceptron.html


### Feedforward neural network



