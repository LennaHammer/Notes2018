IGNORE_EXCEPTION = False


import requests_html
import requests
import os
import re
import urllib
import traceback
import binascii
import glob


session = requests_html.HTMLSession()


session.mount('http://', requests.adapters.HTTPAdapter(max_retries=5))
session.mount('https://', requests.adapters.HTTPAdapter(max_retries=5))

HEADERS = {'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8'}


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
        #raise exc
        print(exc)
        input("> ")
    traceback.print_exc()


def download_file(url, filename):
    if os.path.exists(filename):
        return
    print(f'{url} -> {filename}')
    #referer = urllib.parse.urlparse(url).netloc
    r = session.get(url, timeout=60, headers={'Referer': url})
    r.raise_for_status()
    data = r.content
    assert not os.path.exists('temp')
    assert b'<html' not in data, f'{url} is html.'
    assert not data.startswith(b'<'), f'{url} startswith "<"'
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


def read_filelist(path):
    '''
        用来跳过保存过的文件，按文件名
    '''
    filename = f'{path}/filelist.txt'
    if os.path.exists(filename):
        x = set(read_lines(filename))
        return x
    return set()


def file_exists(filename):
    if os.path.exists(filename):
        return True
    return False


def download_task(filename):
    dirname = "[" + os.path.basename(filename) + "]"
    table = read_lines(filename, True)
    for url, out in table:
        retry(lambda: download_file(
            url, f'{dirname}/{out}'), ignore=IGNORE_EXCEPTION)


def download_url_list(filename):
    dirname = "[" + os.path.basename(filename) + "]"
    skip = read_filelist(dirname)
    table = read_lines(filename, False)
    for url in table:
        filename = os.path.basename(url)
        if filename in skip:
            print("SKIP")
            continue
        retry(lambda: download_file(
            url, f'{dirname}/{filename}'), ignore=IGNORE_EXCEPTION)


def download_web_task(filename):
    dirname = "[" + os.path.basename(filename) + "]"
    os.makedirs(dirname, exist_ok=True)
    table = read_lines(filename, True)
    for k, (key, title, items) in enumerate(table, 1):
        # print(f'[{k}/{len(table)}]')
        assert 'http' in key, key
        path = urllib.parse.urlparse(key).path
        pid = ''.join(re.findall(r'\d+', path))  # 排序用
        items = items.split(",")
        size = len(items)
        title = escape_filename(title)
        #tag = '{:08X}'.format(binascii.crc32(key.encode("utf-8")))
        for i, item in enumerate(items, 1):
            url = item.strip()
            tag2 = '{:08X}'.format(binascii.crc32(url.encode("utf-8")))
            extname = os.path.splitext(url)[1]
            out = f"[{pid}]{title}_{size:d}_{i:02d}_{tag2}{extname}"  # 不要修改
            # 注意文件名排序的顺序（编号/时间，标题（可能重复），子项号）
            if not file_exists(f'{dirname}/{out}'):
                print(f'[{k}/{len(table)}]')
            retry(lambda: download_file(
                url, f'{dirname}/{out}'), ignore=IGNORE_EXCEPTION)


def main():
    session.headers.update(
        {'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8'})
    if os.path.exists('temp'):
        os.unlink('temp')
    xs = glob.glob('*.task')
    print(xs)
    for x in xs:
        if x.endswith('.tsv.task'):
            print(x)
            download_web_task(x)
        if x.endswith('.list.task'):
            print(x)
            download_url_list(x)


try:
    IGNORE_EXCEPTION = True
    main()
    IGNORE_EXCEPTION = False
    main()
except:
    raise
