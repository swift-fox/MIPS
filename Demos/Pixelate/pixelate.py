#!/usr/bin/env python

import Image,sys

def f(data,_x,_y):
	sum_r=0
	sum_g=0
	sum_b=0
	for x in range(8):
		for y in range(8):
			sum_r+=data[x+_x,y+_y][0]/64
			sum_g+=data[x+_x,y+_y][1]/64
			sum_b+=data[x+_x,y+_y][2]/64

	for x in range(8):
		for y in range(8):
			data[x+_x,y+_y]=(sum_r,sum_g,sum_b)

def g(data,_x,_y):
	for x in range(8):
		for y in range(8):
			data[x+_x,y+_y]=data[_x,_y]

if len(sys.argv)>1:
	img=Image.open(sys.argv[1])
else:
	img=Image.open("Lenna.png")

data=img.load()

for i in range(0,512,8):
	for j in range(0,512,8):
		g(data,i,j)

if len(sys.argv)>2:
	img.save(sys.argv[2])
else:
	img.save("out.png")

