int image[512*512];

void process(x,y)
{
	int i,j;
	p=image[x,y];
	for(i=0;i<8;i++){
		for(j=0;j<8;j++){
			image[x+i,y+j]=p;
		}
	}
}

void main()
{
	int x,y;
	for(x=0;x<512;x+=8){
		for(y=0;y<512;y+=8){
			process(x,y);
		}
	}
}

