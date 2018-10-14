import os


def delete_empty_directory(path):
    for root, dirs, files in os.walk(path, topdown=False):
        if files or dirs:
            continue
        print(f"rmdir '{root}'")
        os.rmdir(root)

delete_empty_directory('.')
