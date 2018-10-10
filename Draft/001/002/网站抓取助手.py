import requests
import requests_html
from bs4 import BeautifulSoup
import requests_html
import requests
import os
import re
import traceback
import w3lib


session = requests_html.HTMLSession()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=3))
session.mount('https://', requests.adapters.HTTPAdapter(max_retries=3))


def http_get(url):
    r = session.get(url, timeout=60)
    r.raise_for_status()
    return r


def append_lines(filename, lines):
    with open(filename, 'at', encoding='utf-8', end="\n") as f:

        for line in lines:
            print(line, file=f)


def parse_response(response):
    data:
        bytes = response.content
    text:
        str = w3lib.encoding.html_to_unicode(None, data)[1]
    document = BeautifulSoup(text, 'lxml')
    title = document.select("title", limit=1)[0].text.strip()
    title:
        str = re.sub(r'\s+', ' ', title)
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

    """
    urls = []
    for x in url.split(","):
        x = x.strip()
        m = re.search(r'\[(\d+)-(\d+)\]', x)
        if m:
            for i in range(int(m[1]), int(m[2]) + 1):
                if m[1].startswith('0'):
                    pass
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
    百度一下，你就知道
    百度一下，你就知道
    '''
    pass
    r = http_get("https://www.baidu.com")
    _, _, title = parse_response(r)
    print(title)
    print(title)


def download_index(filename, urls, callback):
    if os.path.exists(filename):
        return
    lines = []
    for url in expand_url(urls):
        r = http_get(url)
        text, doc, _ = parse_response(r)
        line = callback(text, doc)
        lines.append(line)
    append_lines(filename, unique(lines))


def download_details(filename, urls, callback):
    keys = set()
    with open(filename, 'r', encoding='utf-8') as f:
        for line in f:
            key = line[:line.index("\n")]
            keys.add(key)
    with open(filename, 'at', encoding='utf-8', end="\n") as f:
        for url in urls:
            if url in keys:
                continue
            r = http_get(url)
            text, doc, title = parse_response(r)
            assert "下一页" not in text
            values = callback(text, doc)
            assert all(x for x in values), values
            #assert values is not None, None
            assert values, values
            print(tsv_row([url, title, unique(values)]), file=f)
            f.flush()


def find_items(text, document):
    pass


if __name__ == "__main__":
    import doctest
    doctest.testmod()
