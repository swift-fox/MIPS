int image[1024];

void main(){
	int i;
	for(i=0;i<1024;i=i+1){
		if(image[i]>128){
			image[i]=255;
		}
		else{
			image[i]=0;
		}
	}
}
