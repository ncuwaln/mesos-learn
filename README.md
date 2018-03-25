### 介绍

用vagrant+ansible模拟的学习mesos生态

### 为什么使用vagrant

1. 更加接近实际机器环境
2. 因为我要在mesos集群中集成docker，所以只能用vagrant


### requires


* ansible
* python3
* vagrant


### 流程

1. 根据你的需求更改Vagrantfile
2. ```
vagrant up
```
3. 分发ssh公钥，我写了一个小工具 https://github.com/ncuwaln/little-tools/tree/master/distribute-ssh-pubkey
4. ansible-playbook -i inventory.cfg mesos.yml

tips: 因为网速问题，下载可能会很慢，我觉得可以做一个安装好mesos, zookeeper, docker, marathon的操作系统镜像，这样可以减少很多时间
