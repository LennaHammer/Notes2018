# Py Tools and Principles

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



Flask



Django







opencv



pytorch



## stats



pandas

```python
def read_csv(filename):
    pass

```



sklearn



## Image



opencv



## ML





# NLP

NLTK



jieba

