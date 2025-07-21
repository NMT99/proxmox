#!/bin/bash

# ======= HAM: Them dong repo neu chua ton tai ==========
add_repo_line() {
    local FILE="$1"
    local LINE="$2"
    grep -Fxq "$LINE" "$FILE" 2>/dev/null || echo "$LINE" >> "$FILE"
}

# ======= Thong bao resize disk ========
echo "Neu chua resize phan vung OS thi chay lenh sau va reboot he thong:"
echo ""
echo "lvresize --extents +100%FREE --resizefs /dev/pve/root"
echo ""
echo "Neu da resize, ban co the tiep tuc cap nhat he thong bang script nay."
echo ""

# ======= Them repo Proxmox ========
PVE_FILE="/etc/apt/sources.list.d/pve-enterprise.list"
echo ">>> Dang kiem tra va cap nhat $PVE_FILE ..."
mkdir -p "$(dirname "$PVE_FILE")"
echo "#deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise" > "$PVE_FILE"
add_repo_line "$PVE_FILE" "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription"

# ======= Them repo Ceph ========
CEPH_FILE="/etc/apt/sources.list.d/ceph.list"
echo ">>> Dang kiem tra va cap nhat $CEPH_FILE ..."
mkdir -p "$(dirname "$CEPH_FILE")"
echo -n > "$CEPH_FILE"
add_repo_line "$CEPH_FILE" "deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription"

echo ""
echo ">>> Repo da duoc cap nhat hoac giu nguyen neu da ton tai."
echo ""

# ======= Hoi nguoi dung muon cap nhat khong ========
read -p ">>> Ban co muon cap nhat va cai goi can thiet (y/n)? [y]: " confirm
confirm=${confirm,,} # viet thuong

if [[ "$confirm" == "y" || "$confirm" == "yes" || "$confirm" == "" ]]; then
    echo ""
    echo ">>> Dang chay apt update va dist-upgrade..."
    apt update -y && apt dist-upgrade -y

    echo ""
    echo ">>> Dang cai dat: parted screen net-tools unzip ..."
    apt install parted screen net-tools unzip -y

    echo ""
    echo ">>> Dang don dep he thong sau cap nhat..."
    apt autoremove -y
    apt clean

    echo ""
    echo ">>> Cap nhat, cai dat va don dep da hoan tat!"
else
    echo ""
    echo ">>> Ban da chon khong cap nhat. Thoat script."
    exit 0
fi
