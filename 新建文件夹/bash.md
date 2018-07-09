

man





查找

grep

find



镜像网站

```
wget -m
wget -r -p -np -k -K
/usr/bin/wget -e robots=off -w 1 -xq -np -nH -pk -m  -t 1 -P "$PATH" "$URL"
wget -m -p -np -k
```

```
--help

-m,  --mirror                    shortcut for -N -r -l inf --no-remove-listing

-N,  --timestamping              don't re-retrieve files unless newer than local
-r,  --recursive                 specify recursive download
-l,  --level=NUMBER              maximum recursion depth (inf or 0 for infinite)


-p,  --page-requisites           get all images, etc. needed to display HTML page


-k,  --convert-links             make links in downloaded HTML or CSS point to
-E,  --adjust-extension          save HTML/CSS documents with proper extensions
-K,  --backup-converted          before converting file X, back up as X.orig


-np, --no-parent                 don't ascend to the parent directory
-H,  --span-hosts                go to foreign hosts when recursive


-t,  --tries=NUMBER              set number of retries to NUMBER (0 unlimits) local files

-e,  --execute=COMMAND           execute a `.wgetrc'-style command

-i,  --input-file=FILE           download URLs found in local or external FILE

wget -A gif,jpg
-R png,jpg,gif
```



wget -m

```
wget -m -np -k -p -E -K

wget -m -np -k -p -E -e robots=off
# https://www.yiibai.com/

# http://www.runoob.com/

wget -m -np -k -p -E -e robots=off http://www.runoob.com/

wget -m -np -k -p -E -e robots=off --exclude-directories /tag/,/t/ http://www.yiibai.com/
```

--exclude-directories

wget -bc \
    --html-extension \
    --restrict-file-names=windows \
    --convert-links \
    --page-requisites \
    --execute robots=off \
    --mirror \
    --exclude-directories /try \
    --user-agent="Chrome/10.0.648.204" \
    --no-check-certificate \
    --reject "aggregator*" \
    -o $SERVER.log \
    $ADDR 2>&1 & 



curl



文本处理



系统设计



user

group

设置语言

`LANG=C` 

windows

msys2

Cygwin

