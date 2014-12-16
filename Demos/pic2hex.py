import Image,sys

if len(sys.argv)>1:
	img=Image.open(sys.argv[1])
else:
	img=Image.open("Lenna.png")

if len(sys.argv)>2:
	out=open(sys.argv[2],"w")
else:
	out=open("data.hex","w")

data=img.getdata()

for p in data:
	out.write("%08x\n"%(0.21*p[0]+0.72*p[1]+0.07*p[2]))

