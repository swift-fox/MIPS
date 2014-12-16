#!/usr/bin/env python

a=0
b=0
c=0
d=0

def increase():
	global a,b,c,d

	if d==255:
		d=0
		if c==255:
			c=0
			if b==255:
				b=0
				if a==255: a=0
				else: a+=1
			else: b+=1
		else: c+=1
	else: d+=1

for i in range(1000000):
	num=int("%02x%02x%02x%02x"%(a,b,c,d),16)
	increase()
	num1=int("%02x%02x%02x%02x"%(a,b,c,d),16)
	if num1-num!=1:
		print "error: %x %x"%(num,num1)
	num=num1

