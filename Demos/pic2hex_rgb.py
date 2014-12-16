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
	out.write("00%02x%02x%02x\n"%(p[2],p[1],p[0]))

