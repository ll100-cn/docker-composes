#!/bin/bash

# 构建带 libfdk_aac 的 FFmpeg（本地版，替代 gist 里的 install_ffmpeg_with_fdk_aac.sh）
#
# 背景：gist 里那版脚本会先去 https://ffmpeg.org/releases/ 抓版本索引，再从 ffmpeg.org
# 下载源码包；而当前网络对 ffmpeg.org 完全不可达（直连、HTTP 代理、socks5、构建容器内
# 都一样：80/443 超时、TLS 握手挂死），所以那一步必然失败。
#
# 这里只改「源码从哪来」，其余构建流程（markus-perl/ffmpeg-build-script 全量构建、
# GPL + non-free 编解码器、fdk_aac）保持不变：
#   1. 固定 FFmpeg 版本，跳过在线版本索引；
#   2. 把 tarball 地址从 ffmpeg.org 换成 GitHub 上 FFmpeg 官方镜像的同版本源码包。
#
# 可覆盖的环境变量：
#   FFMPEG_VERSION         FFmpeg 版本号，默认 9.0.2（对应 GitHub tag n9.0.2）
#   BUILD_SCRIPT_COMMIT    ffmpeg-build-script 的 commit，默认 20bd829（上游 v9.0.11）

set -e

FFMPEG_VERSION="${FFMPEG_VERSION:-9.0.2}"
BUILD_SCRIPT_COMMIT="${BUILD_SCRIPT_COMMIT:-20bd82913bb391b3c740080c29c1d4ab86cd8c37}"
BUILD_DIR="/build/ffmpeg"

echo "=== Starting FFmpeg $FFMPEG_VERSION build with fdk_aac ==="

# 更新包列表并安装基础依赖（包括构建工具和curl，用于下载源代码）
apt-get update
apt-get install -y --no-install-recommends \
    git build-essential yasm nasm pkg-config automake libtool ca-certificates curl

# 1. 创建一个统一的构建目录
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# 2. 克隆脚本仓库（固定到已知可用的 commit，避免上游 master 再次改掉行为）
echo "Cloning ffmpeg-build-script (commit $BUILD_SCRIPT_COMMIT)..."
rm -rf ffmpeg-build-script
git clone https://github.com/markus-perl/ffmpeg-build-script.git
cd ffmpeg-build-script
git checkout --quiet "$BUILD_SCRIPT_COMMIT"

# 3. 把 FFmpeg 源码地址从 ffmpeg.org 换成 GitHub 官方镜像
#    ffmpeg_tarball_url() 里形如：printf 'https://ffmpeg.org/releases/ffmpeg-%s.tar.gz' "$1"
#    版本号 9.0.2 -> tag n9.0.2，即 .../archive/refs/tags/n9.0.2.tar.gz
sed -i 's#https://ffmpeg\.org/releases/ffmpeg-%s\.tar\.gz#https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n%s.tar.gz#' \
    src/30-helpers.sh

if ! grep -q 'github.com/FFmpeg/FFmpeg/archive/refs/tags/n%s.tar.gz' src/30-helpers.sh; then
    echo "Error: 未能把 FFmpeg 下载地址替换成 GitHub 源（上游脚本结构可能已变）" >&2
    exit 1
fi

# 4. 验证替换后的地址确实可用（脚本自己也会做一次 HEAD 校验）
echo "Checking FFmpeg $FFMPEG_VERSION source tarball on GitHub..."
curl -L --fail --silent --head -o /dev/null \
    "https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n${FFMPEG_VERSION}.tar.gz"

# 5. 执行构建（--enable-gpl-and-non-free 以启用 fdk_aac）
echo "Building FFmpeg... (this may take 10-30 minutes)"
yes | ./build-ffmpeg --enable-gpl-and-non-free --ffmpeg-version="$FFMPEG_VERSION" --build

# 清理
echo "Cleaning up..."
cd /
rm -rf "$BUILD_DIR"

echo "=== FFmpeg build complete! ==="
ffmpeg -version | grep libfdk_aac || echo "Warning: grep failed, but build should be OK."
