import os

def check(path):
    for root, dirs, files in os.walk(path):
        count = len(files) + len(dirs)
        if count > 10000:
            print(root, count)

check(".")


