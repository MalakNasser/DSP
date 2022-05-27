clc;
clear all;
close all;

c8 = zeros(8,8);
for k = 0:7
    for r = 0:7
        if k == 0
            c8(k+1,r+1) = sqrt(1/8);
        else
            c8(k+1,r+1) = sqrt(1/4)*cos(pi.*k.*(r+1/2)/8);
        end
    end
end

[FileName, Path] = uigetfile ('.jpg','Select the image');
I = imread(strcat(Path,FileName));
I = rgb2gray(I);
I = double(I);
[r, c] = size(I);
new_r = r;
new_c = c;
while(mod(new_r,8) ~= 0 || mod(new_c,8) ~= 0)
    if mod(new_r,8) ~= 0
        new_r = new_r+1;
    end
    if mod(new_c,8) ~= 0
        new_c = new_c+1;
    end 
end
rowPad=new_r-r;
colPad=new_c-c;
I_resized=padarray(I,[rowPad,colPad]);
I_resized(1:rowPad,:)=[];
I_resized(:,1:colPad)=[];

DCTQ = [16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 69 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
 answer = inputdlg('Enter the scaling factor r : ','r');
 r = str2num(answer{1});
 T = r*DCTQ;

horiz_blocks =  new_r/8;
vert_blocks =  new_c/8;
n = 1;
for i = 1 : horiz_blocks
  for j = 1 : vert_blocks
    rmin = (i-1)*8+ 1;
    rmax = i*8;
    cmin = (j-1)*8+ 1;
    cmax = j*8;
    
    block = I_resized(rmin:rmax, cmin:cmax);
    DCT_block = block - 128;
    DCT_block2 = dct2(DCT_block);
    for k = 1:8
        for l = 1:8
    y(k,l) = round(DCT_block2(k,l)./T(k,l));
        end
    end
    for k = 1:8
        for l = 1:8
    rescale_block(k,l) = y(k,l)*T(k,l);
        end
    end
   invDCT_block = idct2(rescale_block);
   invDCT_block2 = invDCT_block+128;
   
   new_I(rmin:rmax, cmin:cmax) = invDCT_block2;
  end
end  
final_I = uint8(new_I);
subplot(1,2,1)
imshow(uint8(I)),title('Original greyscale image');
subplot(1,2,2)
imshow(final_I),title('Image after compression');