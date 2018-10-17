import requests_html
import requests
import os
import re
import traceback

session = requests_html.HTMLSession()


session.mount('http://', requests.adapters.HTTPAdapter(max_retries=3))
session.mount('https://', requests.adapters.HTTPAdapter(max_retries=3))


def escape_filename(filename):
    return re.sub(r'[<>|\\/:"*?\s]', lambda x: f"%{ord(x[0]):02X}", filename)


def retry(foo, times=3, ignore=False):
    exc = Exception()
    for _ in range(times):
        try:
            return foo()
        except Exception as e:
            print(e)
            exc = e
    if not ignore:
        raise exc
    traceback.print_exc()


def download_file(url, filename):
    if os.path.exists(filename):
        return
    print(f'{url} -> {filename}')
    r = session.get(url, timeout=60)
    r.raise_for_status()
    data = r.content
    assert not os.path.exists('temp')
    with open('temp', 'wb') as f:
        f.write(data)
    os.rename('temp', filename)


def download_files(tasks, dirname):
    os.makedirs(dirname, exist_ok=True)
    for url, out in tasks:
        filename = escape_filename(out)
        retry(lambda: download_file(url, f'{dirname}/{filename}'), ignore=True)


def read_lines(filename, table=None):
    rows = []
    with open(filename, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip("\n")
            if not line:
                continue
            if table:
                line = line.split("\t")
            rows.append(line)
    return rows


def download_task(filename):
    dirname = "[" + os.path.basename(filename) + "]"
    table = read_lines(filename, True)
    for url, out in table:
        retry(lambda: download_file(url, f'{dirname}/{out}'))


def download_url_list(filename):
    dirname = "[" + os.path.basename(filename) + "]"
    table = read_lines(filename, False)
    for url in table:
        filename = os.path.basename(url)
        retry(lambda: download_file(url, f'{dirname}/{filename}'))


def download_web_task(filename):
    dirname = "[" + os.path.basename(filename) + "]"
    table = read_lines(filename, True)
    for key, title, items in table:
        pid = ''.join(re.findall(r'\d+',key))
        count = len(items)
        title = escape_filename(title)
        tag = '{:08X}'.format(binascii.crc32(key.encode("utf-8")))
        for i, item in enumerate(items.split(","), 1):
            url = item.strip()
            tag2 = '{:08X}'.format(binascii.crc32(url.encode("utf-8")))
            extname = os.path.splitext(url)[1]
            out = f"[pid]{title}_{i:02d}_{tag2}{extname}" 
            # 注意文件名排序的顺序（编号/时间，标题（可能重复），子项号）
            retry(lambda: download_file(url, f'{dirname}/{out}'))
