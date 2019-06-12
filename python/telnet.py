#_*_coding: utf-8 _*_
#!/usr/bin/python
import telnetlib
import sys
#
# Host_List = [
#     "127.0.0.1",
#     "192.168.126.148",
# ]
# Port_List = [
#     3306,
#     22,
#     80
# ]
def telnet_host_port(Host_List,Port_List):
    f = open('/data/scripts/python/telnet_result.txt','w')
    for host in Host_List:
        print("正在检测主机：%s" %host)
        f.write("正在检测主机：%s \n" %host)
        for port in Port_List:
            try:
                telnetlib.Telnet(host,port,timeout=5)
                print("端口：%s 状态【up】" %port)
                f.write("端口：%s 状态【up】\n" % port)
            except Exception:
                print("端口：%s 状态【down】" % port)
                f.write("端口：%s 状态【down】\n" % port)
    f.close()

if __name__ == "__main__":
    host_List = sys.argv[1]
    port_list = sys.argv[2]
    Host_List = host_List.split(',')
    Port_List = port_list.split(',')
    telnet_host_port(Host_List,Port_List)

