% This script test the segmentation accuracy of your segmentation results
% with the ground truth.
% 
% You need to select the Resulted segmentation image folder (storing your black and white 
% binary images using your segmentation algorithm) and then  select the ground truth folder
% from the downloaded GT folder. Results are saved inside your segmentation
% result folder named "EvluationResultByMyEvaluCode.mat"

clear
clc
close all

% The cluster penalty rate
r = 0.5;

fprintf('Please select your testing segmentation images folder\n')
SegmentResultFolder=uigetdir;

fprintf('Please select its segmentation ground truth folder\n')
GTFolder=uigetdir;

ListResultContent = dir(SegmentResultFolder);
ResultFiles = RemoveDirect(ListResultContent);

ListGTContent = dir(GTFolder);
GTFiles = RemoveDirect(ListGTContent);

% Compare the number of items between GT folder and Results folder
   % Get Number of segmentation result images in the file
    NsegImage =numel({ResultFiles.name});
   % Get Number of GT images in the file
    NGTImage =numel({GTFiles.name});
 % Issue an message when there are not enough result images
   if NsegImage < (NGTImage-5)
       error('Not enough images are provided for measuring the whole dataset\n')
   end
% Get GT images' size
GTimageSize = size(imread(fullfile(GTFolder,GTFiles(1).name)));
   
% Get segmentation reult images' extension
      afile = fullfile(SegmentResultFolder,ResultFiles(1).name);
      [thepath,thename,theext]=fileparts(afile);
% Get the resulted images' name pattern without the number order
      tf = isletter(thename);
      thenamePattern = thename(1:length(find(tf)));
%The amount of object detected difference compared with the GT image
NObjectDiff = zeros(NsegImage,1);
%The jiont/result image by comparing GT and Seg result
Joint = zeros(GTimageSize(1), GTimageSize(2),NsegImage,'uint8');
NJointPixel = zeros(NsegImage,1);
NGT = zeros(NsegImage,1);
NRe = zeros(NsegImage,1);
NObjGT = zeros(NsegImage,1); 
NObjRe = zeros(NsegImage,1); 
SimilarIndex = zeros(NsegImage,1); 

for t = 1: NsegImage

GT = imread(fullfile(GTFolder,sprintf('img%02d.png',t)));
if (size(GT,3)==3)
    GT = rgb2gray(GT);
end
GT = im2bw(GT, 0.01);
% strcat(sprintf('img%02d',t),theext)
Re = imread(fullfile(SegmentResultFolder,strcat(thenamePattern,sprintf('%02d.png',t))));
if (size(Re,3)==3)
    Re = rgb2gray(Re);
end
Re = im2bw(Re, 0.01);
 if ~isequal(size(GT,1),size(Re,1))||~isequal(size(GT,2),size(Re,2))
     fprintf(strcat('Segmentation result:', strcat(thenamePattern,sprintf('%02d.png',t)),'\n does not have same size with its Groud Truth image\n'));
    a = size(Re,1)/size(GT,1);
    b = size(Re,2)/size(GT,2);
    if a ==b && a<1
        GT = imresize(GT,a);
        Joint( : , : , t) = imresize(Joint( : , : , t),a);
         fprintf(strcat('The groud truth of Segmentation result:', strcat(thenamePattern,sprintf('%02d.png',t)),'\n has resized to the same size with the seg result\n'));
    else if a ==b && a>1
            Re = imresize(Re,1/a);
              Joint( : , : , t) = imresize(Joint( : , : , t),1/a);
            fprintf(strcat('The Segmentation result:', strcat(thenamePattern,sprintf('%02d.png',t)),'\n has resized to the same size with the GT\n'));
        else
            fprintf(strcat('And cannot change to the same size\n'));  
        return;
        end
    end
 end
% count the object of GT and the detected
 CentroidGT = regionprops(GT, 'centroid');
 NObjGT(t) = numel(CentroidGT);
 
 CentroidRe = regionprops(Re, 'centroid');
  NObjRe(t) = numel(CentroidRe);
%  In the case of cluster of segmentation result 
  if NObjGT(t) > NObjRe(t)
      NObjectDiff(t) = NObjGT(t) - NObjRe(t);
  end

     for i = 1: size(GT,1)
         for j = 1:size(GT,2)
              if ( isequal(GT(i,j),1))&& isequal(Re(i,j),1)
                  Joint(i,j,t)=1;
              end
  
         end
     
     end
% figure,imshow(Joint)
% C = imfuse(GT,Re);
% figure, imshow(C)

NJointPixel(t) = length(find(Joint( : , : , t)==1));
NGT(t) = length(find(GT));
NRe(t) = length(find(Re));

t = t+1;
end

Precesion = NJointPixel ./ NGT;
Recall = NJointPixel ./ NRe;
Fmeasure = 2.*Precesion.*Recall./(Precesion+Recall);

SimilarIndex = Fmeasure - r.*NObjectDiff./NObjGT;

if isempty(find(isnan(Precesion),1)) 
Mean_Precesion = mean(Precesion);
fprintf('the mean precesion over the sequence is: %.4f \n', Mean_Precesion);
else
  NANMean_Precesion = nanmean(Precesion);
fprintf('the mean precesion (discard invalid frames) over the sequence is: %.4f \n', NANMean_Precesion);  
end

if isempty(find(isnan(Recall),1)) 
   Mean_Recall = mean(Recall);
   fprintf('the mean precesion over the sequence is: %.4f  \n', Mean_Recall);
else
   NANMean_Recall = nanmean(Recall);
   fprintf('the mean Recall (discard invalid frames) over the sequence is: %.4f \n', NANMean_Recall);  
end

if isempty(find(isnan(Fmeasure),1))
   Mean_Fmeasure = mean(Fmeasure);
   fprintf('the mean F-measure over the sequence is: %.4f \n', Mean_Fmeasure);
else
   NANMean_Fmeasure = nanmean(Fmeasure);
   fprintf('the mean F-measure (discard invalid frames) over the sequence is: %.4f \n', NANMean_Fmeasure);  
end

if isempty(find(isnan(SimilarIndex),1)) 
   Mean_SimilarIndex = mean(SimilarIndex);
   fprintf('the mean Similar Index over the sequence is: %.4f \n', Mean_SimilarIndex);
else
   NANMean_SimilarIndex = nanmean(SimilarIndex);
   fprintf('the mean Similar Index (discard invalid frames) over the sequence is: %.4f \n', NANMean_SimilarIndex);  
end


save(fullfile(SegmentResultFolder,'EvluationResultByMyEvaluCode.mat'))


% %% Calculate Structural Similarity Index (SSIM)
% 
% % Read an image into the workspace. Create another version of the image, 
% % applying a blurring filter. Display both images.
% ref = imread('pout.tif');
% H = fspecial('Gaussian',[11 11],1.5);
% A = imfilter(ref,H,'replicate');
% 
% subplot(1,2,1); imshow(ref); title('Reference Image');
% subplot(1,2,2); imshow(A);   title('Blurred Image');
% 
% % Calculate the global SSIM value for the image and local SSIM values for 
% % each pixel. Return the global SSIM value and display the local SSIM value map.
% [ssimval, ssimmap] = ssim(A,ref);
% 
% fprintf('The SSIM value is %0.4f.\n',ssimval);
% 
% figure, imshow(ssimmap,[]);
% title(sprintf('ssim Index Map - Mean ssim Value is %0.4f',ssimval));
% 
