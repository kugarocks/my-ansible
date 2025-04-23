# my-ansible

* [kubectl](#kubectl): `kubectx` + `kubens` + `kubectl_alias`

## 目录结构

```
my-ansible/
├── roles/
│   └── kubectl/         # kubectl 角色
│       ├── tasks/       # 任务定义 
│       │   └── main.yml # 主任务文件
│       └── files/       # 配置文件
│           ├── kubectx.tar.gz
│           ├── kubectl_aliases
│           └── bashrc
├── deploy.sh            # 部署脚本
├── deploy.yml           # 默认 playbook（包含所有角色）
├── kubectl.yml          # kubectl 角色的 playbook
├── inventory.template   # 清单模板
├── ansible.cfg          # Ansible 配置
└── README.md            # 项目说明
```

## kubectl

- 将 `bashrc` 的内容追加到目标机器的 `~/.bashrc` 文件中
- 将 `kubectl_aliases` 文件复制到目标机器的 `~/.kubectl_aliases`
- 部署 `kubectx` 和 `kubens` 工具

## 使用方法

运行部署脚本

```bash
# 部署所有角色
./deploy.sh <IP1>[,IP2,IP3,...]

# 部署特定角色
./deploy.sh <IP1>[,IP2,IP3,...] kubectl
```

```bash
# 部署所有角色到多台机器
./deploy.sh 192.168.1.10,192.168.1.11

# 仅部署 kubectl 角色
./deploy.sh 192.168.1.10 kubectl
```

直接使用 `ansible-playbook`

```bash
# 创建 inventory 文件
echo "192.168.1.10" > inventory

# 部署所有角色
ansible-playbook -i inventory deploy.yml

# 部署特定角色
ansible-playbook -i inventory kubectl.yml
```

## 使用 Ansible 镜像

```bash
docker run --rm -it \
  -v "$PWD":/ansible \
  -v "$HOME/.ssh":/root/.ssh:ro \
  -w /ansible \
  willhallonline/ansible:2.9.27-alpine-3.16 \
  ./deploy.sh 192.168.48.19 kubectl
```

| 操作系统 | 支持状态 |
|---------|---------|
| CentOS 7 | ✅ |
| Ubuntu 22.04 | ✅ |

## 添加新角色

1. 在 `roles` 目录下创建新角色文件夹（例如 `roles/new-role/`）
2. 创建对应的 playbook 文件（例如 `new-role.yml`）
3. 可选：将新角色添加到 `deploy.yml` 中包含在默认部署中

## 注意事项

- 部署需要目标机器的 root 权限
- 确保能够 SSH 免密登录到目标机器
- 如需修改 SSH 用户，请在 `ansible.cfg` 文件中修改 `remote_user` 