#!/usr/bin/python
## -*- coding: utf-8 -*-
import multiprocessing, Queue
import socket
import string
import sys
import struct
from signal import *

queue_task = multiprocessing.Queue()
queue_ack = multiprocessing.Queue()
workers_number = 200
s = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

import sys
reload(sys)
sys.setdefaultencoding('utf8')

def producer():
	file_name=sys.argv[1]
	file=open(file_name,'r')
	for ip in file.readlines():
		queue_task.put(ip.strip())
	for i in range(workers_number):
		queue_task.put(None) 
	file.close()
	
def ip2add(ip):
	global s
	iType = 0
	iLen = 80
	iIP = struct.unpack("!l",socket.inet_aton(ip))[0]
	iIDFlag = 0
	info = str(ip)
	req = struct.pack('!4i64s',iType,iLen,iIP,iIDFlag,info)
	add = ('172.17.142.40',11239)
	s.sendto(req,add)
	data,svr_add = s.recvfrom(2048)
	type,len,info,flag,idflag,country,province,city,town,addrtype,network,back1,back2 = struct.unpack("!2i64s10i",data[:112])
	t0=112
	t1=int(112+country)
	t2=int(t1+province)
	t3=int(t2+city)
	t4=int(t3+town)
	t5=int(t4+addrtype)
	t6=int(t5+network)
	t7=int(t6+back1)
	t8=int(t7+back2)
	#if (country==0) and (province==0) and (city==0):
	#       r_data = u'%s 0 0 0' % info 
	#elif (country!=0) and (province==0) and (city==0):
	#       r_data = u'%s %s 0 0' %(info,data[t0:t1].decode('gbk'))
	#elif (province!=0) and (city==0):
	#       r_data = u'%s %s %s 0' %(info,data[t0:t1].decode('gbk'),data[t1:t2].decode('gbk'))
	#else:
	r_data = u'%s %s %s %s %s' %(info,data[t0:t1].decode('gbk'),data[t1:t2].decode('gbk'),data[t2:t3].decode('gbk'),data[t6:t7].decode('gbk'))
	
	return r_data
	

def worker():
	while 1:
		iip = queue_task.get()
		if iip is None:
			queue_ack.put(None)
			break
		queue_ack.put(ip2add(iip))
def result_writer():
	result_name=sys.argv[1]
	output=open(result_name+"_result",'w')
	global workers_number
	count = 0
	while 1:
		result=queue_ack.get()
		if result is None:
			count += 1
			if count == workers_number:
				break
		else:
			output.write(result+'\n')
	output.close()

if __name__=="__main__":
	p = multiprocessing.Process(target=producer)
	w = multiprocessing.Process(target=result_writer)
	workers = []
	for i in range(workers_number):
		workers.append(multiprocessing.Process(target=worker))
	w.start()
	for i in range(workers_number):
		workers[i].start()	
	p.start()
	p.join()
	for i in range(workers_number):
		workers[i].join()	
	s.close()
	w.join()
