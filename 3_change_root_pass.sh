#!/bin/bash

set -e

echo "👉 Dang doi yescrypt -> sha512 trong /etc/pam.d/common-password"
if grep -q yescrypt /etc/pam.d/common-password; then
    sed -i 's/yescrypt/sha512/g' /etc/pam.d/common-password
    echo "✅ Da doi thanh sha512"
else
    echo "ℹ️ Khong thay yescrypt, khong can doi"
fi

echo "👉 Dang dat mat khau root thanh Megahost@123"
echo "root:Megahost@123" | chpasswd

echo "✅ Mat khau root da duoc dat lai thanh: Megahost@123"

