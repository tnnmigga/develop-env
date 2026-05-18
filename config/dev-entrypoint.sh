#!/usr/bin/env bash
set -euo pipefail

authorized_keys="/etc/ssh/authorized_keys/root"

mkdir -p /run/sshd /etc/ssh/authorized_keys /root/.ssh
ssh-keygen -A >/dev/null

if [ "$(getent passwd root | cut -d: -f7)" != "/usr/bin/zsh" ]; then
  usermod --shell /usr/bin/zsh root
fi

tmp_keys="$(mktemp)"
if [ -f /root/.ssh/authorized_keys ]; then
  cat /root/.ssh/authorized_keys >> "${tmp_keys}"
fi

find /root/.ssh -maxdepth 1 -type f -name '*.pub' -exec cat {} + >> "${tmp_keys}" 2>/dev/null || true

awk 'NF && $1 !~ /^#/' "${tmp_keys}" | sort -u > "${tmp_keys}.deduped"
install -m 0600 -o root -g root "${tmp_keys}.deduped" "${authorized_keys}"
rm -f "${tmp_keys}" "${tmp_keys}.deduped"

if ! pgrep -x sshd >/dev/null 2>&1; then
  /usr/sbin/sshd
fi

exec "$@"
