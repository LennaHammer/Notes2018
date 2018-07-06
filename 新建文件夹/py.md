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
cursor = conn.cursor(buffered=True)
cursor.execute("select * from table1")
cursor.fetchall()
conn.commit()

```

cursor.lastrowid



## Web

requests

```python
import requests
session = requests.Session()

def http_get(url):
	r = session.get(url,timeout=60)
	r.raise_for_status()
	return r
```

ajax



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











## stat

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



pandas

```python
def read_csv(filename):
    pass

```

plot

## ML

sklearn

keras

pytorch

## Image



opencv

opencv







## NLP



NLTK

jieba



 datetime.now().date() + timedelta(days=1)