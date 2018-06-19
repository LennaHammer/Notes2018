#!python3
## see https://github.com/kennethreitz/requests-html/blob/master/requests_html.py

import sys
import os
import re
import requests
import requests_html
from bs4 import BeautifulSoup
import tempfile
import unittest
import w3lib
import w3lib.encoding
import collections
import functools

class Response:
    def __init__(self, r: requests.Response):
        r.raise_for_status()
        self._r = r
        self._doc = None

    # def set_encoding(self, encoding='utf-8'):
    #     if encoding:
    #         self._r.encoding = encoding

    @property
    def document(self):
        if self._doc is None:
            data = self._r.content
            # w3lib.encoding.http_content_type_encoding
            source = w3lib.encoding.html_to_unicode(None, data)[1]
            print(type(source))
            self._doc = BeautifulSoup(source, 'lxml')
        return self._doc

    @property
    def title(self) -> str:
        return self.document.select("title", limit=1)[0].text

    @property
    def data(self) -> bytes:
        return self._r.content

    def __str__(self):
        return str(self._r)

    def extract_attrs(self, selector, attr_name):
        xs = self.document.select(selector)
        return [x[attr_name] for x in xs]

    def next_page(self):
        return None


class WebSession:
    HEADERS = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8',
        'Accept-Encoding': 'gzip, deflate',
        'Accept': '*/*',
        'Connection': 'keep-alive'
    }

    def __init__(self,encoding=None):
        self._session = s = requests_html.HTMLSession()
        # self._session.mount()
        s.mount('http://', requests.adapters.HTTPAdapter(max_retries=5))
        s.mount('https://', requests.adapters.HTTPAdapter(max_retries=5))
        # HTTPAdapter(max_retries=retries))
        # self.session.headers.update(self.HEADERS)
        # print(self.session.headers)

    def get(self, url):
        r = self._session.get(url, timeout=60)
        r.raise_for_status()
        assert r.status_code==200
        return Response(r)

    def set_cookies(self, obj):
        pass


session = WebSession()


def expand_url(urls):
    return []


def escape_filename(filename, max_length=None):
    if max_length:
        filename = filename[:max_length]
    filename = re.sub(r'', lambda m: '1', filename)
    return filename


def safe_write(filename: str, data: bytes):
    path = os.path.dirname(filename)
    temp = tempfile.TemporaryFile("wb", dir=path)
    with open(temp, 'wb') as f:
        f.write(data)
        # os.fsync(f.fileno())
    os.rename(temp, filename)


def retry(foo, times=3, ignore=None):
    exc = None
    for i in range(times):
        try:
            return foo()
        except Exception as e:
            print(e)
            exc = e
    if not ignore and exc:
        raise exc


def http_get(url):
    return retry(lambda: session.get(url))


def download_file(url, out, overwrite=None):
    if not overwrite and os.path.exists(out):
        return
    data = session.get(url).data
    safe_write(out, data)


class Utils:
    @staticmethod
    def append_line(filename: str, line: str):
        raise NotImplementedError

class WebTask:
    def __init__(self, urls, name):
        self._urls = collections.deque(urls)
        self._table = Table(name) if name else None

    def put_item(self,key,values):
        self._table.put(key,values)

    def put_url(self,url):
        self._urls.append(url)

    def run(self, callback):
        s = WebSession()
        while self._urls:
            url = self._urls.popleft()
            if url in self._table:
                continue
            response = s.get(url)
            values = callback(self, response)
            if values:
                self.put_item(url, values)

    @classmethod
    def decorator(cls,urls,out=None):
        o = cls(urls,out)
        def d(f):
            return f

        d

def apply(f):
    f()


@apply
@WebTask.decorator(["http://www.baidu.com"],None)
def dd(task,response):
    print(response)


class Table:
    def __init__(self, filename):
        self._filename = filename
        self._keys = set()
        if filename is not None:
            if os.path.exists(filename):
                with open(filename, 'r', encoding='utf-8') as f:
                    for line in f:
                        line = line.rstrip("\n")
                        if line.isspace():
                            continue
                        key = line.split("\t", 1)[0]
                        self._keys.add(key)
            self._out = open(filename, 'a', encoding='utf-8')

    @staticmethod
    def _escape(text: str):
        assert isinstance(text, str)
        return text.replace("\t", "\\t").replace("\n", "\\n")

    def has(self, key: str):
        assert isinstance(key, str)
        return key in self._keys

    def __contains__(self, item):
        return self.has(item)

    def put(self, key, values):
        key = self._escape(key)
        row = [key, *map(self._escape, values)]
        line = ("\t".join(row)) + "\n"
        if self._filename:
            self._out.write(line)
            self._out.flush()
            self._keys.add(key)
        else:
            print(line)


class T(unittest.TestCase):
    def test_a(self):
        self.assertEqual(Table._escape("1\t2\n3"), r"1\t2\n3")

    def test_b(self):
        self.assertEqual(http_get("https://www.baidu.com").title, "百度一下，你就知道")


if __name__ == '__main__':
    unittest.main()
