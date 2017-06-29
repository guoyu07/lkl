# lkl
linux kernel library

# 说明
用来在openvz vps中尝鲜TCP BBR拥塞算法；</br>
所以这个config已经尽量小了，去掉了block，fs等，基本只保留了networking功能；

# 踩过的坑
* **config kernel时，sysctl和proc一定要选，否则networking完全不能用**；</br>
如果遇到了"Possible syn flood..."这种日志，但明明没有flood，那可能就是这个情况；</br>
原因是tcp的backlog(somaxconn)是在sysctl中初始化默认值128，没选sysctl导致这个值是 0 ，tcp一收到syn就跪了；
* **linux kernel library的hijack有个重要的syscall没劫持，epoll_create1**;</br>
这会导致libev等使用了epoll_create1的东东没法玩；</br>
在tool/lkl/lib/hijack/hijack.c中仿照epoll_create加上epoll_create1就行了；
