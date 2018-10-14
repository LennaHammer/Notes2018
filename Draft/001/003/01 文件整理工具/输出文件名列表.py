import os

def read_list(filename):
    items = set()
    if os.path.exists(filename):
        with open(filename, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.rstrip("\n")
                items.add(line)
        assert items, "'filelist.txt' is empty."
    return items

def _scan_filelist(path):
    filelist = set()
    for _root, _dirs, files in os.walk(path):
        for file in files:
            filelist.add(file)
    return filelist

def _write_lines(filename,items):
    with open(filename, 'w', encoding='utf-8', newline='\n') as f:
        for item in items:
            print(item, file=f)

def update_filelist(path):
    print(os.path.abspath(path))
    list_file = f'{path}/filelist.txt'
    filelist = set()
    filelist.update(read_list(list_file))
    print(len(filelist))
    filelist2 = _scan_filelist(path)
    filelist.update(filelist2)
    _write_lines("当前文件列表.txt",sorted(filelist2))
    print(len(filelist))
    tempfile = f"{path}/temp.txt"
    _write_lines(tempfile,sorted(filelist))
    if os.path.exists(list_file):
        os.remove(list_file)
    os.rename(tempfile, list_file)


#update_filelist('e:/')
update_filelist('.')
if __name__ == '__main__':
    pass
    #x = input("path> ")
    #if x.strip()!="":
    #    update_filelist(x)