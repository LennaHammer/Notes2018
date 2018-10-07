import requests_html
import requests
import os
import re
import traceback

session = requests_html.HTMLSession()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=5))
session.mount('https://', requests.adapters.HTTPAdapter(max_retries=5))


def escape_filename(filename):
    return re.sub(r'[<>|\\/:"*?\s]', lambda x: f"%{ord(x[0]):X}", filename)


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


def load_table(filename):
    rows = []
    with open(filename, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip("\n")
            if not line:
                continue
            rows.append(line.split("\t"))
    return rows


def download_task(filename):
    dirname = "["+ os.path.basename(filename)+"]"
    table = load_table(filename)
    for url, out in table:
        retry(lambda:download_file(url,f'{dirname}/{out}'))


