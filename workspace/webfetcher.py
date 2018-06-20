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
import typing


# import selenium


class Response:
    def __init__(self, r: requests.Response):
        r.raise_for_status()
        self._r = r
        self._doc = None

    @property
    def document(self):
        if self._doc is None:
            data: bytes = self._r.content
            # w3lib.encoding.http_content_type_encoding
            source: str = w3lib.encoding.html_to_unicode(None, data)[1]
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

    def __init__(self, encoding=None, headers=None, cookies=None):
        self._session = s = requests_html.HTMLSession()
        s.mount('http://', requests.adapters.HTTPAdapter(max_retries=5))
        s.mount('https://', requests.adapters.HTTPAdapter(max_retries=5))
        self._encoding = encoding
        if headers:
            self.session.headers.update(headers)
        if cookies:
            pass

        # print(self.session.headers)

    def __del__(self):
        self._session.close()

    def get(self, url):
        r = self._session.get(url, timeout=60)
        r.raise_for_status()
        assert r.status_code == 200
        return Response(r)


class BrowserSession:
    def __init__(self):
        self._driver = selenium.webdriver.Chrome()


session = WebSession()


def expand_url(urls):
    raise NotImplementedError
    return []


def escape_filename(filename, max_length=None):
    if max_length:
        filename = filename[:max_length]
    raise NotImplementedError
    filename = re.sub(r'', lambda m: '1', filename)
    return filename


def safe_write(filename: str, data: bytes):
    path = os.path.dirname(filename)
    temp = tempfile.NamedTemporaryFile("wb", dir=path, delete=False, suffix=".tmp")
    temp.write(data)
    os.fsync(temp.fileno())
    temp.close()
    os.rename(temp.name, filename)


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


def log(s):
    print(s)


def download_file(url, out, overwrite=None):
    if not overwrite and os.path.exists(out):
        log(f"skip {url}")
        return
    log(f"DOWNLOAD: {url} -> {out}")
    data = session.get(url).data
    safe_write(out, data)


class Utils:
    @staticmethod
    def append_line(filename: str, line: str):
        with open(filename, 'at', encoding='utf-8', newline="\n") as f:
            print(line, file=f)

    @staticmethod
    def unique(xs):
        return list({x: 1 for x in xs}.keys())

    @staticmethod
    def apply(f):
        return f()

    @staticmethod
    def expand_url(urls):
        """
        see man curl
        """
        raise NotImplementedError
        return Utils.unique([])

    @staticmethod
    def read_lines(filename, tab=None):
        lines = []
        with open(filename, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.rstrip("\n")
                if not line:
                    continue
                if tab:
                    line = line.split("\t")
                lines.append(line)
        return lines

    @staticmethod
    def write_lines(filename, xs):
        with open(filename, 'w', encoding='utf-8', newline="\n") as f:
            for x in xs:
                print(x, file=f)


class Table:
    def __init__(self, filename: str):
        self._filename = filename
        self._keys = {}
        self._out = None
        self._rows = []
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

    def __del__(self):
        if self._out:
            self._out.close()

    @staticmethod
    def _escape(text: str):
        assert isinstance(text, str)
        return text.replace("\t", "\\t").replace("\n", "\\n")

    def has(self, key: str):
        assert isinstance(key, str)
        return key in self._keys

    def __contains__(self, item: str):
        return self.has(item)

    def put(self, key, values):
        key = self._escape(key)
        row = [key, *map(self._escape, values)]
        line = ("\t".join(row)) + "\n"
        assert key not in self._keys
        self._keys[key] = True
        if self._filename:
            self._out.write(line)
            self._out.flush()
        else:
            self._rows.append(line)

    @property
    def cached_rows(self):
        return self._rows


def read_items(urls, output_file, extractor):
    if os.path.exists(output_file):
        log(f"{output_file} exists.")
        return
    items = []
    s = WebSession()
    for url in Utils.unique(Utils.expand_url(urls)):
        r = s.get(url)
        items += extractor(r)
    if output_file:
        Utils.write_lines(output_file, items)
    else:
        log(items)
        return items


class WebItemPage:
    def __init__(self):
        pass


class WebTask:
    def __init__(self, urls: typing.List[str], name, skip_error=None):
        self._urls = collections.deque(urls)
        self._name = name
        self._table = Table(name)
        self._skip_error = skip_error

    def put_item(self, key, values):
        self._table.put(key, values)

    def put_url(self, url):
        self._urls.append(url)

    def run(self, callback, cookies=None, headers=None):
        s = WebSession(cookies=cookies, headers=headers)
        while self._urls:
            url = self._urls.popleft()
            if url in self._table:
                continue
            response = retry(lambda: s.get(url), ignore=self._skip_error)
            values = callback(self, response)
            if values:
                self.put_item(url, values)
        cached = self._table.cached_rows
        return cached

    #    @classmethod
    #    def run_task(cls, urls, out, callback, cookies=None, headers=None):
    #        if isinstance(urls, str):
    #            urls = expand_url(urls)
    #        o = cls(urls, out)
    #        return o.run(callback,cookies=cookies,headers=headers)

    #    @classmethod
    #    def decorator(cls, urls, out=None, **kwargs):
    #        return lambda f: lambda: cls.run_task(urls, out, f, **kwargs)

    @classmethod
    def decorator(cls, urls, out, cookies=None, headers=None):
        if isinstance(urls, str):
            urls = expand_url(urls)
        task = cls(urls, out)
        return lambda callback: lambda: task.run(callback, cookies=cookies, headers=headers)


# @Utils.apply
@WebTask.decorator(["http://www.baidu.com"], None)
def ddd(task, response):
    return [response.title, "1\t2\n3"]


class Test(unittest.TestCase):
    def test_a(self):
        self.assertEqual(Table._escape("1\t2\n3"), r"1\t2\n3")

    def test_utils(self):
        pass

    def test_b(self):
        self.assertEqual(http_get("https://www.baidu.com").title, "百度一下，你就知道")

    def test_c(self):
        if os.path.exists("baidu.html"):
            os.remove("baidu.html")
        download_file("http://www.baidu.com", "baidu.html")
        self.assertTrue(os.path.getsize("baidu.html") > 0)

    def test_d(self):
        @WebTask.decorator(["http://www.baidu.com"], None)
        def dd(task, response):
            return [response.title, "1\t2\n3"]

        self.assertEqual(dd(), ['http://www.baidu.com\t百度一下，你就知道\t1\\t2\\n3\n'])


if __name__ == '__main__':
    unittest.main()

