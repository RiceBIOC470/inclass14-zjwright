%Inclass 14
clear all
%Work with the image stemcells_dapi.tif in this folder
stemcells=imread('stemcells_dapi.tif');

% (1) Make a binary mask by thresholding as best you can
figure(2)
stemcells_mask=stemcells>290;
stemcells_mask=imclose(stemcells_mask, strel('disk', 4));
imshow(cat(3, stemcells_mask, im2double(imadjust(stemcells)), zeros(size(stemcells)))); %to check mask quality

% (2) Try to separate touching objects using watershed. Use two different
% ways to define the basins. 
%(A) With erosion of the mask 
figure(3)
stemcells_mask_erode=imerode(stemcells_mask, strel('disk',8));
%check if good erosion mask
imshow(cat(3,stemcells_mask, stemcells_mask_erode, zeros(size(stemcells_mask))));
figure(4)
CC = bwconncomp(stemcells_mask);
stemcells_stats = regionprops(CC, 'Area');
stemcells_area = (stemcells_stats.Area);
s = round(1.2*sqrt(mean(stemcells_area))/pi);
stemcells_eroded = imerode(stemcells_mask, strel('disk',s));
stemcells_outside= ~imdilate(stemcells_mask, strel('disk',1));
stemcells_basin = imcomplement(bwdist(stemcells_outside));
stemcells_basin = imimposemin(stemcells_basin,stemcells_eroded|stemcells_outside);
stemcells_eroded_ws = watershed(stemcells_basin);
rgb=label2rgb(stemcells_eroded_ws, 'jet', [.5 .5 .5]);
imshow(rgb, 'InitialMagnification', 'fit')

%(B) with a distance transform. 
stemcells_D=bwdist(stemcells_mask);
stemcells_D=-stemcells_D;
stemcells_D(stemcells_mask)=-Inf;
D_L=watershed(stemcells_D);
rgb=label2rgb(D_L,'jet',[.5 .5 .5]);
figure(5)
imshow(rgb,'InitialMagnification','fit')
%Which works better in this case?
%the erosion worked better