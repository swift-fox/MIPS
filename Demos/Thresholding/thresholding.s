int image[1024];

main(){
	int i;
	for(i=0;i<1024;i++)
		if(image[i]<128)
			image[i]=0;
		else
			image[i]=255;
}

r1:i
r2:result
r3:addressing
r4:image[i]
r5:255
r6:262144

//i=0
000000_00000_00000_00001_00000_100000	//0: add r0,r0,r1
//r5=255
001001_00000_00101_0000000011111111	//1: addiu r0,255,r5
//r6=262144
001111_00000_00110_0000000000000100	//2: lui r6,4
//for i<1024;
000000_00001_00110_00010_00000_101011	//3: sltu r1,r6,r2
000111_00010_00000_0000000000001010	//4: bgtz r2,_end
//r4=image[i]
000000_00000_00001_00011_00010_000000	//5: sll r1,r3,2
100011_00011_00100_0000000000000000	//6: lw r3(0),r4
//image[i]<128
001011_00100_00010_0000000010000000	//7: sltiu r1,128,r2
000100_00010_00000_0000000000000011	//8: beq r2,r0,_max(+3)
//image[i]=0
101011_00011_00000_0000000000000000	//9: sw r3(0),r0
//j i++
000010_00000000000000000000001100	//a: j i++
//max image[i]=r5
101011_00011_00101_0000000000000000	//b: sw r3(0),r5
//i++
001001_00001_00001_0000000000000001	//c: addiu r1,1,r1
//j for
000010_00000000000000000000000011	//d: j for
//end beq .
000100_00000_00000_0000000000000000	//e: beq r0,r0,0
