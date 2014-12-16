import Image,sys

if len(sys.argv)>1:
	f=open(sys.argv[1],"r")
else:
	f=open("dump.hex","r")

img=Image.new("RGB",(512,512))
data=img.load();

i=0;
while True:
	line=f.readline()
	if line == '': break
	if line[0]=='/': continue
	#pixel=(int(line[6:8],16),int(line[4:6],16),int(line[2:4],16))
	pixel=(int(line[6:8],16),int(line[6:8],16),int(line[6:8],16))
	#print "%s%d,%d,%d,%d"%(line,i,i%512,i/512,pixel[1])
	data[i%512,i/512]=pixel
	i+=1

if len(sys.argv)>2:
	img.save(sys.argv[2])
else:
	img.save("out.png")

