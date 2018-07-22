# Python Tools and Principles

## INSTALL



Python 3

```
pip install numpy
pip install ipython
```

Miniconda

```bash
coda install anaconda
```







## Database

sql

sqlite3

```python
import sqlite3
conn = sqlite3.connect("database.sqlite")
conn.execute("...")
conn.commit()
```



mysql

```python
import mysql.connector

conn = mysql.connector.connect(user='root', password='password', database='test')
cursor = conn.cursor(buffered=True, dictionary=True)
cursor.execute("select * from table1")
cursor.fetchall()
conn.commit()

```

cursor.lastrowid









## ͳ��

ԭ����ģ��





## stat



ͳ��

���� Population 

+ ����
+ ���� ��ֵ mean e  $\mu$ 
+ ���� variance $\sigma^2$
  + ��׼��

���� Sample

+ ������ֵ sample mean $\overline{X}$
+ �������� $s^2$


�ֲ�
+ ����
+ ��̬�ֲ� Normal distribution
  + Z���� Z-test



ͳ��ѧ - ά���ٿƣ����ɵİٿ�ȫ��
https://zh.wikipedia.org/wiki/%E7%BB%9F%E8%AE%A1%E5%AD%A6

central tendency
+ ��ֵ  mean


����mode�������г���Ƶ���������֡�
��λ������ n �������ɴ�С�����λ���м�����֡�
����ƽ������n��������Ӻ����n��
����ƽ������n��������˺� n �η���
����ƽ������n�����ݵĵ���ȡ����ƽ������ȡ������
ƽ��ƽ������Ҳ�ơ�������������n �����ݵ�ƽ��ȡ����ƽ�����ٿ����š�
�ƶ�ƽ����

��ɢ�̶� dispersion
+ ���� Variance var $\sigma^2$
  + ��ƽ���͵�ƽ������ȥ��ƽ����ƽ������
  + Population(����) variance and sample variance
  + �������� $s^2$  follows a scaled chi-squared distribution
  + Distribution of the sample variance
  + ��׼�� Standard Deviation \sigma s ���������ƽ���� ���k����׼�� x+-ks
+ �������� #
  + ����
  + �ֲ� follows a scaled chi-squared distribution ���� ����
  
����ϵ�����ֳơ���ɢϵ������Ӣ�ģ�coefficient of variation�����Ǹ��ʷֲ���ɢ�̶ȵ�һ����һ�����ȣ��䶨��Ϊ��׼�� {\displaystyle \ \sigma } \ \sigma ��ƽ��ֵ {\displaystyle \ \mu } \ \mu ֮��

range ���ֵ����Сֵ��������ֵ��
�ķ�λ�� ����ͼ

Mean squared error MSE �������
��һ�����ƺ���Ϊ�����Ȼ���ƣ�������ƫ�ģ���ƫ�Ϊ�㣬�������ķ���ȵڶ���С�����ڶ������ƺ�������ƫ�ġ��ϴ�ķ���ĳ�̶ֳ��ϲ�����ƫ���˵ڶ������ƺ����ľ������ȵ�һ��Ҫ��

�ֲ� distribution

+ ���� 
  + ��һ��������һ����Ӣ�be normalized ���ʱ������ {\displaystyle 1} 1 
+ ��̬�ֲ�
  + Z���� �������뼫�޶��� pֵ if the sample size is large or the population variance is known
 If the population variance is unknown (and therefore has to be estimated from the sample itself) and the sample size is not large (n < 30), the Student's t-test may be more appropriate.
�����˫���pֵ�����ñ�׼�ۻ��ֲ������������㣬�ֱ�Ϊ��(?Z)���ϲࣩ ��(Z)���²ࣩ�� 2��(?|Z|) ��˫�ࣩ��

+ �����ֲ� chi-squared distribution
+ t����
  + ���������飺����һ����̬�ֲ�������ľ�ֵ�Ƿ�������������ֵ֮��
  + ˫�������飺�������Ϊ������̬�ֲ�������ľ�ֵ֮��Ϊĳʵ��
  + ����ԡ����ߡ��ظ�������t���飺����ͬһͳ���������β���ֵ֮��Ĳ����Ƿ�Ϊ�㡣
  + ����һ���ع��ߵ�б���Ƿ�������Ϊ�㡣
+ F-�ֲ� ����һϵ�з�����̬�ֲ���ĸ�壬������ͬ�ı�׼�� F����ķ��ӡ���ĸ��ʵ����һ�������������Ը��Ե����ɶ�



���Ϸֲ� ����������� X �� Y
+ Э���� Covariance  ���������ı仯����һ��
  + ���� => 0
  + ��������� [��1, 1] ���Բ���� 0
  + Э������� �������������X ��Y��
  
����裬�ڸü����У��������ضԱ����������κ����á������H0��Ϊ��������׵ģ�֤���޷����䶨�

���
+ ��һ�ʹ���������豻�����֤α���ó����Խ��Ϊ�������ԡ���
+ �ڶ��ʹ����������û�б���ʱ�ų���ĸȺ���е�ʵ�ʲ��챻�����ж�Ϊ�������ԡ���

�����С�������ַ��� ����֮Ϊ����С���˷�����
������� 95%�������� ��Ҷ˹����
�����Բ���

�����Բ���
����Ŀ�������Բ���
���ڸ��������⣬ͳ��ѧ���ٻش�򵥵��ǻ�����Ľ��ͳ�������ͳ�Ƶ������Բ�����֣��㱨���Խ�����辫ȷ֤α�ĸ���ֵ����Ҳ��������pֵ���ٶ�ֵ����

�ع����
ʱ�����з���

�ֱ���decibel��������������ͬ��λ֮���������ĵ�λ
����ֵ��ο���ֵ֮�ȼ������10�Ķ������ٳ���10

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
+ ����ͼ
+ ֱ��ͼ

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



�����ھ�



## ML

sklearn

from sklearn import linear_model

keras

pytorch



## Vision



### PIL

image magic

### OpenCV

`import cv2` 

 ��д��ʾ

+ imread
+ imshow
+ imwrite

ɫ��

+ cvtColor  `gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)`

��ͼ

filter

��ֵ

�任

+ ����任



+ ����ʶ�� haarcascades
+ ��Ե��� Canny



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