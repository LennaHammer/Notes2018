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
import json
import traceback

# import selenium


class Response:
    def __init__(self, r: requests.Response):
        r.raise_for_status()
        self._r = r
        self._doc = None
        self._source = None

    @property
    def source(self):
        if self._source is None:
            data: bytes = self._r.content
            source: str = w3lib.encoding.html_to_unicode(None, data)[1]
            self._source = source
        return self._source

    @property
    def document(self):
        if self._doc is None:
            #data: bytes = self._r.content
            ## w3lib.encoding.http_content_type_encoding
            #source: str = w3lib.encoding.html_to_unicode(None, data)[1]
            self._doc = BeautifulSoup(self.source, 'lxml')
        return self._doc

    @property
    def title(self) -> str:
        title = self.document.select("title", limit=1)[0].text.strip()
        #title = re.sub(r'\n+',' ',title)
        assert "\n" not in title,title
        return title

    @property
    def data(self) -> bytes:
        return self._r.content

    def __str__(self):
        return str(self._r)
    def select(self, selector):
        return self.document.select(selector)

    def extract_attrs(self, selector, attr_name):
        xs = self.document.select(selector)
        #keys = attr_names.split(" ")
        return [x[attr_name] for x in xs]

    def scan(self, regex):
        return re.findall(regex, self.source)

    def next_page(self):
        return None


class WebSession:
    HEADERS = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/603.3.8',
        'Accept-Encoding': 'gzip, deflate',
        'Accept': '*/*',
        'Connection': 'keep-alive'
    }

    def __init__(self, encoding: str = None, headers=None, cookies: str = None):
        self._session = s = requests_html.HTMLSession()
        s.mount('http://', requests.adapters.HTTPAdapter(max_retries=5))
        s.mount('https://', requests.adapters.HTTPAdapter(max_retries=5))
        self._encoding = encoding
        if headers:
            self.session.headers.update(headers)
        if cookies:
            cs = {}
            for item in cookies.split(';'):
                key, value = item.split('=', 1)
                cs[key] = value
            session.cookies = requests.cookies.cookiejar_from_dict(Cookies)

        # print(self.session.headers)

    def __del__(self):
        self._session.close()

    def get(self, url):
        log(f"GET {url}")
        r = self._session.get(url, timeout=60)
        r.raise_for_status()
        assert r.status_code == 200
        return Response(r)


class BrowserSession:

    def __init__(self):
        self._browser = selenium.webdriver.Chrome()
        self._element = None

    def get(self, url):
        self._browser.get(url)

    def select(self, selector):
        element = self._browser.find_element_by_css_selector(selector)
        self._element = element
        return element

    def click(self):
        if self._element is not None:
            self._element.click()


session = WebSession()

##def escape_filename(filename, max_length=None):
##    if max_length:
##        filename = filename[:max_length]
##    raise NotImplementedError
##    filename = re.sub(r'', lambda m: '1', filename)
##    return filename








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
            traceback.print_exc()
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
    def expand_url(url):
        """see curl"""
        urls = []
        for x in url.split(","):
            x = x.strip()
            m = re.search(r'\[(\d+)-(\d+)\]', x)
            if m:
                for i in range(int(m[1]), int(m[2]) + 1):
                    if m[1].startswith('0'):
                        pass
                    y = f"{x[:m.start()]}{i}{x[m.end():]}"
                    urls += Utils.expand_url(y)
            else:
                urls.append(x)
        return urls

    @staticmethod
    def escape_filename(filename):
        return re.sub(r'[<>|\\/:"*?\s]', lambda x: f"%{ord(x[0]):X}", filename)

    @staticmethod        
    def safe_write(filename: str, data: bytes):
        if isinstance(data,str):
            data = data.encode('utf-8')
        path = os.path.dirname(filename)
        temp = tempfile.NamedTemporaryFile("wb", dir=path, delete=False, suffix=".tmp")
        temp.write(data)
        os.fsync(temp.fileno())
        temp.close()
        os.rename(temp.name, filename)

    @staticmethod
    def extname(filename):
        return os.path.splitext(filename)[1]

    @staticmethod
    def read_lines(filename, tab=None,reverse=None):
        lines = []
        with open(filename, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.rstrip("\n")
                if not line:
                    continue
                if tab:
                    line = line.split("\t")
                lines.append(line)
        if reverse:
            lines.reverse()
        return lines

    @staticmethod
    def write_lines(filename, xs):
        lines = []
        for x in xs:
            lines.append(x)
            lines.append("\n")
        Utils.safe_write(filename, "".join(lines))

#        with open(filename, 'w', encoding='utf-8', newline="\n") as f:
#            for x in xs:
#                print(x, file=f)

    @staticmethod
    def find_files(path):
        return glob.glob(path, recursive=True)


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
                        self._keys[key] = True
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
        assert all("\n" not in x for x in row)
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

    def __init__(self, urls: typing.List[str], name):
        self._urls = collections.deque(urls)
        self._name = name
        self._table = Table(name)

    def put_item(self, key, values):
        self._table.put(key, values)

    def put_url(self, url):
        self._urls.append(url)

    def run(self, callback):
        s = WebSession()
        while self._urls:
            url = self._urls.popleft()
            if url in self._table:
                continue
            response = Utils.retry(lambda: s.get(url),ignore=True)
            values = callback(self, response)
            assert all(x for x in values), values
            assert values is not None, None
            if values:
                self.put_item(url, values)
        cached = self._table.cached_rows
        if cached:
            print(cached)
        return cached
    
    @classmethod
    def run_task(cls, out, urls, callback):
        return cls(urls,out).run(callback)
        
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
        return lambda callback: lambda: cls(urls, out).run(callback)

    @classmethod
    def task(cls, out, urls,run=None):
        return lambda callback: cls(urls, out).run(callback)


# @Utils.apply
@WebTask.decorator(["http://www.baidu.com"], None)
def ddd(task, response):
    return [response.title, "1\t2\n3"]


def task_read_list0(out, url, pat):
    if out and file_exists(out):
        return
    items = []
    urls = expand_url(url)
    for item in urls:
        r = retry(lambda: http_get(item), 3)
        items += pat(r)
    items = uniq(items)
    if out:
        write_lines(out, items)
    else:
        print(items)

def task_read_list(out, url, pat):
    s = WebSession()
    if out and os.path.exists(out):
        return
    items = []
    urls = Utils.expand_url(url)
    for item in urls:
        r = Utils.retry(lambda: s.get(item), 3)
        items += pat(r)
    items = Utils.unique(items)
    if out:
        Utils.write_lines(out, items)
    else:
        print(items)
    print("ok")

def find_next_url(html):
    path = os.path.dirname(html.url)
    xs = [y for x in html.find('a', containing='下一页') for y in x.absolute_links]
    xs = [x for x in xs if x.startswith(path)]
    if xs:
        assert len(xs) == 1
        return xs[-1]
    return None


def user_foo1(html):
    base = html.url
    prefix = os.path.splitext(base)[0] + '_'
    xs = [x for x in html.absolute_links if x.startswith(prefix)]
    if not xs:
        assert '下一页' not in html.text, [html.text, prefix, xs]
        return []
    foo = lambda x: int(re.search(r'_(\d+)\.s?html?', x)[1])
    last_page = max([foo(x) for x in xs])
    xs = [base]
    xs += [re.sub(r'(\.s?html?)', f'_{i}\\1', base) for i in range(2, last_page + 1)]
    xs = uniq(xs)
    assert len(xs) >= 2, xs
    xs.remove(base)
    return xs


def read_page_items(url, selector, attr, find_next_urls, empty=False, cookie=None):
    r = http_get2(url, cookie=cookie)
    title = r.html.find('title', first=1).text
    print(f"TITLE: {title}")
    # xs = [x.attrs[attr] for x in r.html.find(selector)]
    if '|' in attr:
        xs = html_select2(r.html, selector, attr)
    else:
        xs = html_select(r.html, selector, attr)
    # assert xs,[url,selector,r.html.find(selector)]
    if find_next_urls == "auto":
        # assert None,f"no,{find_next_urls}"
        next_page = find_next_url(r.html)
        if next_page:
            xs += read_page_items(next_page, selector, attr, 'auto')['items']
            assert xs if next_page else 1
    elif find_next_urls == 'ignore':
        pass
    elif find_next_urls:
        # nexts = re.findall('href', r.html, find_next_urls)
        nexts = find_next_urls(r)
        # print(nexts)
        for k, x in enumerate(nexts):
            xs += read_page_items(x, selector, attr, 'ignore', empty=k == len(nexts) - 1)[2].split(',')
    else:
        assert find_next_urls is None, find_next_urls
        assert '下一页' not in r.html.text, ['下一页', r.html.text]
    # print(xs)
    if not empty:
        assert xs, f"EMPTY {url}"
    assert xs or empty, f"EMPTY {url}"
    print(xs)
    assert '\t' not in title
    return [url, title, ','.join(uniq(xs))]
    # return dict(key=url, title=title, items=uniq(xs))


def run_task(out, pages, callback):
    # filename = f"[TABLE]{datafile}.tsv.txt"
    h = {}
    if os.path.exists(out):
        with open(out, 'r', encoding='utf-8') as f:
            for line in f:
                key = line.split("\t", 1)[0]
                h[key] = 1
    print(f'{len(h)} items')
    with open(out, 'a', encoding='utf-8') as f:
        for url in uniq(pages):
            if url in h:
                continue
            print(url)
            row = None
            import requests
            try:
                row = callback(url)
            except requests.exceptions.HTTPError as e:
                print(e)
            except Exception as e:
                print(str(e).encode('gbk', 'ignore').decode('gbk', 'ignore'))
                print("SKIP")
                if DEBUG:
                    traceback.print_exc()
            if row:
                print(row)
                print('\t'.join(row), end="\n", file=f)
                f.flush()


import urllib
import urllib.parse


def task_download_task(filename):
    xs = read_lines(filename, tab=True)
    prefix = os.path.dirname(filename)
    dirname = f"[{os.path.splitext(os.path.basename(filename))[0]}]"
    dirname = os.path.join(prefix, dirname)
    print(dirname)
    if not os.path.exists(dirname):
        os.makedirs(dirname)
    for row in xs:
        if not len(row) == 3:
            print(row)
            continue
        key = row[0]
        key = urllib.parse.urlparse(key).path
        pid = ''.join(re.findall(r'\d+', key))
        title = row[1]
        images = row[2].split(",")
        # print(title,images)
        for i, v in enumerate(images, 1):
            filename = escape_filename(f"[{pid}]{title}_{i:02d}") + extname(v)
            # print(filename)
            download_images([(v, f"{dirname}/{filename}")])


def cnu_get(url):
    r = http_get(url)
    # user_id = re.search(r'''www.cnu.cc\/users\/([^/"\']*)''',html).group(1)
    # user_name = doc.find('div',id="name").strip()
    # title = doc.title.string
    # print(doc)
    # print(doc.find('div',id='imgs_json').text)
    title = html_title(r.html)
    images = ['http://img.cnu.cc/uploads/images/920/' + x['img'] for x in json.loads(r.html.find('div#imgs_json').text)]
    # .map{|x|'http://img.cnu.cc/uploads/images/920/'+x['img']}
    # print(['CNU',title,user_id,post_id,images])
    # download_url(url_file,f"CNU.{user_id}.{post_id}",title,images)
    return [url, title, ','.join(images)]


class Test(unittest.TestCase):

    def test_a(self):
        self.assertEqual(Table._escape("1\t2\n3"), r"1\t2\n3")

    def test_utils(self):
        xs = [
            ("a,b,c[1-2]", ['a', 'b', 'c1', 'c2']),
            ("a[1-3]b", ['a1b', 'a2b', 'a3b']),
            ("a[1-2]b[2-3]c", ['a1b2c', 'a1b3c', 'a2b2c', 'a2b3c']),
        ]
        for k, v in xs:
            self.assertEqual(Utils.expand_url(k), v)

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
