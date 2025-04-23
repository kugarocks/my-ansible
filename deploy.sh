#!/bin/sh

# 检查参数
if [ $# -lt 1 ]; then
    echo "用法: $0 <IP1>[,IP2,IP3,...] [role-name]"
    echo "示例: $0 192.168.1.10,192.168.1.11 kubectl"
    exit 1
fi

# 获取 IP 地址列表（以逗号分隔）
IPS=$1

# 获取角色名称，默认为 all（全部部署）
ROLE=${2:-all}

# 创建 inventory 文件
echo "[targets]" > inventory

# 将 IP 添加到 inventory 文件中
for ip in ${IPS//,/ }; do
    echo "$ip" >> inventory
done

# 如果角色是 all，则运行 deploy.yml
if [ "$ROLE" == "all" ]; then
    ansible-playbook -i inventory deploy.yml
else
    # 否则，运行对应的角色 yml 文件
    ansible-playbook -i inventory ${ROLE}.yml
fi

echo "部署完成!" 