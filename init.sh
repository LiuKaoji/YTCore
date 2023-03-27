#!/bin/bash

# 设置要下载的文件的URL
URL1="https://github.com/LiuKaoji/YTCore/releases/download/1.0.0/Python.zip"
URL2="https://github.com/LiuKaoji/YTCore/releases/download/1.0.0/ffmpeg.zip"
URL3="https://github.com/LiuKaoji/YTCore/releases/download/1.0.0/env.zip"

# 设置要下载的文件名
FILENAME1="Python.zip"
FILENAME2="ffmpeg.zip"
FILENAME3="env.zip"

# 设置要提取文件的目录名
EXTRACTDIR="YTCore"

# 创建提取文件的目录
mkdir -p "$EXTRACTDIR"

# 从第一个URL下载第一个文件
echo "从 $URL1 下载 $FILENAME1 ..."
curl -o "$FILENAME1" -L "$URL1"

# 从第二个URL下载第二个文件
echo "从 $URL2 下载 $FILENAME2 ..."
curl -o "$FILENAME2" -L "$URL2"

# 从第三个URL下载第三个文件
echo "从 $URL3 下载 $FILENAME3 ..."
curl -o "$FILENAME3" -L "$URL3"

# 将第一个文件的内容提取到指定的目录
echo "将 $FILENAME1 的内容提取到 YTCore/Library 目录"
unzip -q -o "$FILENAME1" -d "YTCore/Library"

# 将第二个文件的内容提取到指定的目录
echo "将 $FILENAME2 的内容提取到 YTCore/Utility/YTVideoMuxer/DLMediaUtils"
unzip -q -o "$FILENAME2" -d "YTCore/Utility/YTVideoMuxer/DLMediaUtils"

echo "将 $FILENAME3 移动到 YTCore/Resource 目录..."
mv -f "$FILENAME3" "YTCore/Resource/"

# 删除已下载的文件
echo "删除已下载的文件..."
rm "$FILENAME1" "$FILENAME2"

echo "完成."
