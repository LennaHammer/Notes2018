import requests
import requests_html
from bs4 import BeautifulSoup
import requests_html
import requests
import os
import re
import traceback
import w3lib
import tempfile


session = requests_html.HTMLSession()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=3))
session.mount('https://', requests.adapters.HTTPAdapter(max_retries=3))


# class Skip(Exception):
#     pass


def http_get(url):

    print(f"GET: {url}")
    r = session.get(url, timeout=60)
    r.raise_for_status()
    return r


def write_lines(filename, lines):
    with open(filename, 'w', encoding='utf-8', newline="\n") as f:
        for line in lines:
            print(line, file=f)


def read_lines(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.rstrip("\n")
            yield line


def parse_response(response):
    data = response.content
    _encoding, text = w3lib.encoding.html_to_unicode(None, data)
    document = BeautifulSoup(text, 'lxml')
    title = document.select("title", limit=1)
    if title:
        title = title[0].text.strip()
        title = re.sub(r'\s+', ' ', title)
    else:
        title = None
        raise Exception("title")
    assert text, text
    assert title, title
    return text, document, title


def extract_attrs(document, selector, attr_name):
    xs = document.select(selector)
    #keys = attr_names.split(" ")
    return [x[attr_name] for x in xs]


def scan_text(text, regex):
    return re.findall(regex, text)


def unique(xs):
    '''
    >>> unique([1,2,3,1])
    [1, 2, 3]
    '''
    return list({x: 1 for x in xs}.keys())


def expand_url(url):
    """
    参考 curl

    >>> expand_url("a,b,c[1-2]")
    ['a', 'b', 'c1', 'c2']
    >>> expand_url("a[1-3]b")
    ['a1b', 'a2b', 'a3b']
    >>> expand_url("a[1-2]b[2-3]c")
    ['a1b2c', 'a1b3c', 'a2b2c', 'a2b3c']
    >>> expand_url("[4-2]")
    ['4', '3', '2']
    >>> expand_url("abc")
    ['abc']
    """
    urls = []
    for x in url.split(","):
        x = x.strip()
        m = re.search(r'\[(\d+)-(\d+)\]', x)
        if m:
            a, b = int(m[1]), int(m[2])
            r = range(a, b + 1, 1) if a <= b else range(a, b - 1, -1)
            for i in r:  # range(int(m[1]), int(m[2]) + 1):
                if m[1].startswith('0'):
                    raise NotImplementedError
                y = f"{x[:m.start()]}{i}{x[m.end():]}"
                urls += expand_url(y)
        else:
            urls.append(x)
    return urls


def tsv_row(cols):
    '''
    >>> tsv_row(['1','2','3'])
    '1\\t2\\t3'
    '''
    escape = lambda x: x.replace("\t", "\\t").replace("\n", "\\n")
    return "\t".join(map(escape, cols))


def test():
    '''
    >>> test()
    GET: https://www.baidu.com
    百度一下，你就知道
    百度一下，你就知道
    '''
    pass
    r = http_get("https://www.baidu.com")
    _, _, title = parse_response(r)
    print(title)
    print(title)


def download_index(filename, urls, callback):
    '''
    保存网页上的列表项，假定列表项逆序。
    下载顺序按从新往旧，返回结果按从旧往新。
    '''
    if filename and os.path.exists(filename):
        return
    lines = []
    for url in expand_url(urls):
        r = http_get(url)
        text, doc, _ = parse_response(r)
        lines += callback(text, doc)
    if filename:
        lines = unique(lines)
        lines.reverse()
        write_lines(filename, lines)
    else:
        print(lines, len(lines), len(unique(lines)))


def download_details(filename, urls, callback):
    '''
    注意：
    1. 网络的返回结果是不可靠的，注意检查，以及不要随便无视异常。
    2. 有时候重试就行，有时是代码问题。

    '''
    # if urls is None:
    #     urls = list(reversed(list(g.read_lines(filename))))
    #     name, ext = os.path.splitext(filename)
    #     filename = f'{name}_详细{ext}'
    # if filename is None:
    #    _, filename = tempfile.mkstemp()
    urls = list(urls)
    keys = set()
    if os.path.exists(filename):
        with open(filename, 'r', encoding='utf-8') as f:
            for line in f:
                key = line[:line.index("\t")]
                keys.add(key)
    print(len(keys))
    with open(filename, 'at', encoding='utf-8', newline="\n") as f:
        for i, url in enumerate(urls):
            if url in keys:
                continue
            print(f'[{i+1}/{len(urls)}]', end='')
            r = None
            skip = False
            for _ in range(3):
                try:
                    r = http_get(url)
                    text, doc, title = parse_response(r)
                    values = callback(url, text, doc)
                    assert all(x for x in values), values
                    #assert values is not None, None
                    assert values, values
                    print(values)
                    break
                except requests.exceptions.TooManyRedirects:
                    skip = True
                except Exception:
                    traceback.print_exc()
                    input("continue>")
                    r = None
            if r is None:
                continue
            if skip:
                continue
            print(r.status_code)
            #text, doc, title = parse_response(r)
            #assert "下一页" not in text

            print(tsv_row([url, title, ','.join(unique(values))]), file=f)
            f.flush()


def find_items(text, document):
    pass


if __name__ == "__main__":
    import doctest
    doctest.testmod()
