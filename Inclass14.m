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
stemcells_mask_erode=imerode(stemcells_mask, strel('disk',10));
imshow(watershed(stemcells_mask)>1);
%(B) with a distance transform. 


%Which works better in this case?