#!/usr/bin/env bash
set -euo pipefail
umask 077

die() { printf '%s\n' "$*" >&2; exit 1; }
base=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
arch=$(cat "$base/architecture")
[[ $(uname -m) == "$arch" ]] || die "此包适用于 $arch，当前机器是 $(uname -m)。"
[[ $(id -u) != 0 ]] || die "请用日常桌面账号运行此启动器。"
[[ $HOME == /* && $HOME != / ]] || die '需要绝对路径的用户主目录 HOME。'
for path in "$base" "$HOME"; do
  [[ $path != *:* && $path != *$'\n'* ]] || die '主目录和解压路径不能包含冒号或换行。'
done
shim="$base/proot"
root="$base/runtime"
[[ -x $shim ]] || die '启动器无法执行。请用 tar 解压到允许执行程序的本地目录。'

mode=gui
case ${1:-} in
  --check) mode=check; shift ;;
  --shell) mode=shell; shift ;;
  --install-menu)
    [[ $base != *'"'* && $base != *'\'* && $base != *'%'* && $base != *'$'* && $base != *'`'* ]] ||
      die '请把包解压到路径不含引号、反斜杠、百分号、美元符号或反引号的目录。'
    dest="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
    mkdir -p -- "$dest"
    cat > "$dest/openidea-0.1.50-offline.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=OpenIDEA 0.1.50（离线版）
Exec=/bin/bash "$base/启动-OpenIDEA.sh"
Icon=$base/runtime/usr/share/icons/hicolor/128x128/apps/openidea.png
Terminal=false
Categories=Development;IDE;
DESKTOP
    chmod 644 "$dest/openidea-0.1.50-offline.desktop"
    printf '已添加应用菜单，解压目录可继续作为安装目录使用。\n'
    exit 0 ;;
esac
if [[ $mode == gui && -z ${DISPLAY:-} ]]; then
  die '未找到 X11 显示会话。请在麒麟图形桌面中打开终端运行，Wayland 会话需要 XWayland。'
fi

state="$HOME/.local/share/openidea-offline/0.1.50-$arch"
config="$state/config/ai.l0ng.openidea"
tool_dir="$state/data/ai.l0ng.openidea/tools"
mkdir -p -- "$config" "$tool_dir" "$state/cache"
config_file="$config/settings.toml"
if [[ ! -e $config_file ]]; then
  ( set -o noclobber
    printf '[general]\nautoCheckUpdates = false\nshowWhatsNewAfterUpdate = false\n\n[appearance]\nlocale = "zh-CN"\n' > "$config_file"
  ) 2>/dev/null || [[ -f $config_file ]]
fi
for src in "$base"/offline-tools/*; do
  name=${src##*/}
  [[ -e $tool_dir/$name ]] && continue
  staging=$(mktemp -d "$tool_dir/.incoming.XXXXXXXX")
  cp -a -- "$src/." "$staging/"
  mv -T -- "$staging" "$tool_dir/$name" 2>/dev/null || {
    rm -rf -- "$staging"
    [[ -d $tool_dir/$name ]] || die "初始化 $name 失败。"
  }
done

profile=$(mktemp -d "${TMPDIR:-/tmp}/openidea-offline.XXXXXXXX")
trap 'rm -rf -- "$profile"' EXIT
mkdir -m 700 "$profile/run"
uid=$(id -u)
gid=$(id -g)
user=$(id -un)
[[ $user != *:* && $HOME != *:* ]] || die '用户名或主目录无法写入运行环境的账号文件。'
awk -F: -v u="$uid" -v n="$user" '$1 != n && $3 != u' "$root/etc/passwd" > "$profile/passwd"
printf '%s:x:%s:%s:OpenIDEA:%s:/bin/bash\n' "$user" "$uid" "$gid" "$HOME" >> "$profile/passwd"
awk -F: -v g="$gid" '$3 != g && $1 != "openidea-local"' "$root/etc/group" > "$profile/group"
printf 'openidea-local:x:%s:%s\n' "$gid" "$user" >> "$profile/group"
if [[ ! -s $state/machine-id ]]; then
  (set -o noclobber; tr -d '-' < /proc/sys/kernel/random/uuid > "$state/machine-id") 2>/dev/null ||
    [[ -f $state/machine-id ]]
fi

# The host wrapper is static. The application and its children resolve /usr and /lib inside runtime.
export PROOT_NO_SECCOMP=1
p=("$shim" --kill-on-exit -r "$root" -b /dev -b /proc -b /sys -b "$HOME"
   -b "$profile/passwd:/etc/passwd" -b "$profile/group:/etc/group"
   -b "$state/machine-id:/etc/machine-id" -b "$profile/run:/run/openidea")
[[ -d /tmp/.X11-unix ]] && p+=(-b /tmp/.X11-unix)
auth=${XAUTHORITY:-$HOME/.Xauthority}
if [[ -f $auth ]]; then
  [[ $auth != *:* ]] || die 'XAUTHORITY 路径不能包含冒号。'
  p+=(-b "$auth:/run/openidea/Xauthority")
fi
[[ ! -r /etc/resolv.conf ]] || p+=(-b /etc/resolv.conf)
if [[ -d $base/可选插件 ]]; then
  p+=(-b "$base/可选插件:/opt/openidea-offline/plugins")
fi

start="$HOME"
cwd=$(pwd -P)
if [[ $cwd == "$HOME" || $cwd == "$HOME/"* ]]; then start=$cwd; fi
p+=(-w "$start" /usr/bin/env -i
  HOME="$HOME" USER="$user" LOGNAME="$user" TERM="${TERM:-xterm}"
  LANG=C.UTF-8 LC_ALL=C.UTF-8 DISPLAY="${DISPLAY:-}" XAUTHORITY=/run/openidea/Xauthority
  XDG_RUNTIME_DIR=/run/openidea XDG_CACHE_HOME="$state/cache" XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-}"
  OPENIDEA_DATA_DIR="$state/data" OPENIDEA_LOCAL_DATA_DIR="$state/data"
  OPENIDEA_CONFIG_DIR="$state/config" OPENIDEA_LOG_DIR="$state/log"
  PATH=/opt/maven/bin:/usr/lib/jvm/openidea-temurin-25/bin:/usr/local/bin:/usr/bin:/bin
  JAVA_HOME=/usr/lib/jvm/openidea-temurin-25 SHELL=/bin/bash
  GDK_BACKEND=x11 WEBKIT_DISABLE_DMABUF_RENDERER=1 LIBGL_ALWAYS_SOFTWARE=1 NO_AT_BRIDGE=1)
case "$mode" in
  check) "${p[@]}" /usr/local/bin/openidea-offline-check ;;
  shell) if (($#)); then "${p[@]}" "$@"; else "${p[@]}" /bin/bash --noprofile --norc; fi ;;
  gui) "${p[@]}" /usr/bin/dbus-run-session -- /usr/bin/openidea "$@" ;;
esac
