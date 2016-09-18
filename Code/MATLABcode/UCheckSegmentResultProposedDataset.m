% visually check the accuracy of the generated ground truth with the
% original image

disp('Select the folder of original images');
ImagesFolder=uigetdir;

disp('Select the folder of generated gorund truth images');
GTFolder=uigetdir;


% Check segm images' name 
% for the purpose to get the number of ground truth images
imageNames = dir(fullfile(GTFolder,'img*.png'));
imageNames = {imageNames.name}';

figure
for i = 1: length(imageNames)
  Iname = fullfile(ImagesFolder,sprintf('img%02d.jpg',i));
I = imread(Iname);
GTname = fullfile(GTFolder,sprintf('img%02d.png',i));

GT = imread(GTname);
C = imfuse(I, GT);
disp('comparing the %d image', i);
imshow(C)
pause 
end

% %% COPY GT and past for images without moving
% for i = 300:50:2000
% img = read(shuttleVideo, i);
% imwrite(img,fullfile('imagfill',sprintf('img%d.jpg', i)));
% end
% %% Pick out images with seperated objects (and fill the wholes)
% for i = 152 : 704
% GTname = fullfile('G:\Zebrafish\ProposedSegmentationDataset\SegmentationDataset1\Fish11\GT',sprintf('img%d.png',i));
% % GT = imresize(GT, 0.54375);
% GT = imread(GTname);
% GT = rgb2gray(GT);
% GT = im2bw(GT, 0.01);
% 
% CentroidGT = regionprops(GT, 'centroid');
%  NObjGT = numel(CentroidGT)
%  fprintf('%d th frame have %d regions', i, NObjGT)
%  pause
% %  if (NObjGT > 4)
% %      imshow(GT);
% %      GTfill = imfill(GT, 'holes');
% %      figure,imshow(GTfill)
% %      CentroidGTfill = regionprops(GTfill, 'centroid');
% %  NewNObjGT = numel(CentroidGTfill);
% %  if (NewNObjGT==4)
% %      imwrite(GTfill,fullfile('/imagfill',sprintf('img%02d.png', i)));
% %  else
% %      fprintf('%d th image have %d regions now', i,NewNObjGT )
% %  end
% %  end
% %  pause
%  i = i +1;
%      clc
%      close all
%      
% end
% 
