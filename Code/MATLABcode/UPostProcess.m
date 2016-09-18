% Post processing after background subtraction
% Select the folder storing all the frame results of background subtraction
% Strengthed results save in folder "StrenthedSegResults"

ImagesFolder=uigetdir;
mkdir(ImagesFolder,'StrenthedSegResults')

% Check segm images' name 
% for the purpose to get the number of images
imageNames = dir(fullfile(ImagesFolder,'SegmMask*.png'));
imageNames = {imageNames.name}';

for  i = 1:length(imageNames)
   img = imread(fullfile(ImagesFolder,sprintf('SegmMask%02d.png', i)));
  
   Kmedian = medfilt2(img);
   
   SE = strel('disk', 1);
  IM2 = imerode(Kmedian,SE);
  
    level = graythresh(IM2);
  BW2 = im2bw(IM2, level);
  
  state = regionprops(BW2,'area');
  meanPixel = mean([state.Area]);
  
  BW = bwareaopen(BW2, round(0.2*meanPixel));
  
 
   imwrite(BW,fullfile(ImagesFolder,'StrenthedSegResults',sprintf('StrImg%02d.png', i)));
end
disp(' Program finished')

