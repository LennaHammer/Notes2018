import glob
import os
import math

def move_files(path, out):
    files = glob.glob(f"{path}/**/*.*", recursive=True)
    files.sort(key=lambda x: os.path.basename(x))
    print(len(files))

    size = 12_000
    print(len(files)//size)

    if os.path.exists(out):
    	raise Exception(f'{out} exists.')
    os.makedirs(out, exist_ok=False)

    
    input("...")
    input("...")
    dirnames=[]
    dircoount = math.ceil(len(files)/size) # 注意！！
    for i in range(0, dircoount):
        dirname = f"{out}/P{i+1:03d}"
        if not os.path.exists(dirname):
            os.mkdir(dirname)
        dirnames.append(dirname)
    
    for i in range(0, dircoount):
        print(i)
        for file in files[i*size:i*size+size]:
            basename = os.path.basename(file)
            try:
                os.rename(file, f"{dirnames[i]}/{basename}")
            except Exception as e:
                print(e)
    print(len(glob.glob(f"{out}/**/*.*", recursive=True)))

move_files(".", "../parts")
