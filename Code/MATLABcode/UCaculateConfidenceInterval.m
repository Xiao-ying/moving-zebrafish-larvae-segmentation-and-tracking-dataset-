%% https://au.mathworks.com/matlabcentral/answers/159417-how-to-calculate-the-confidence-interval 
clear
clc

MatFolder=uigetdir;
load(fullfile(MatFolder,'EvluationResultByMyEvaluCode.mat'))

% Precision confidence interval 
if isempty(find(isnan(Precesion),1)) 
SEM = std(Precesion)/sqrt(length(Precesion));               % Standard Error    
Pre_CIlower = mean(Precesion) - 1.96*SEM ;                     % Confidence Intervals lower boundary
Pre_CIupper = mean(Precesion) + 1.96*SEM ;                    % Confidence Intervals upper boundary
fprintf('the confidence interval of precesion over the sequence is: [%.4f %.4f]\n', Pre_CIlower,Pre_CIupper);
else
  SEM = nanstd(Precesion)/sqrt(length(Precesion)-1);               % Standard Error    
Pre_CIlower = nanmean(Precesion) - 1.96*SEM ;                    % Confidence Intervals lower boundary
Pre_CIupper = nanmean(Precesion) + 1.96*SEM ;                    % Confidence Intervals upper boundary

fprintf('the confidence interval of precesion (discard invalid frames)over the sequence is: [%.4f %.4f]\n', Pre_CIlower,Pre_CIupper);
end

% Recall confidence interval 
if isempty(find(isnan(Recall),1)) 
   SEM = std(Recall)/sqrt(length(Recall));                 
   Recall_CIlower = mean(Recall) - 1.96*SEM ;                    
   Recall_CIupper = mean(Recall) + 1.96*SEM ;
   fprintf('the confidence interval of Recall over the sequence is: [%.4f %.4f]\n', Recall_CIlower,Recall_CIupper);
else
   SEM = nanstd(Recall)/sqrt(length(Recall)-1);                 
   Recall_CIlower = nanmean(Recall) - 1.96*SEM ;                    
   Recall_CIupper = nanmean(Recall) + 1.96*SEM ;
   fprintf('the confidence interval of Recall (discard invalid frames)over the sequence is: [%.4f %.4f]\n', Recall_CIlower,Recall_CIupper);
end

% Fmeasure confidence interval 
if isempty(find(isnan(Fmeasure),1)) 
  SEM = std(Fmeasure)/sqrt(length(Fmeasure));                 
  Fmea_CIlower = mean(Fmeasure) - 1.96*SEM ;                    
  Fmea_CIupper = mean(Fmeasure) + 1.96*SEM ;
  fprintf('the confidence interval of Fmeasure over the sequence is: [%.4f %.4f]\n', Fmea_CIlower,Fmea_CIupper);
else
  SEM = nanstd(Fmeasure)/sqrt(length(Fmeasure)-1);                 
  Fmea_CIlower = nanmean(Fmeasure) - 1.96*SEM ;                    
  Fmea_CIupper = nanmean(Fmeasure) + 1.96*SEM ;
  
  fprintf('the confidence interval of Fmeasure (discard invalid frames)over the sequence is: [%.4f %.4f]\n', Fmea_CIlower,Fmea_CIupper);
end
% SimilarIndex confidence interval 
if isempty(find(isnan(SimilarIndex),1)) 
  SEM = std(SimilarIndex)/sqrt(length(SimilarIndex));                 
  Simi_CIlower = mean(SimilarIndex) - 1.96*SEM ;                    
  Simi_CIupper = mean(SimilarIndex) + 1.96*SEM ;
  fprintf('the confidence interval of SimilarIndex over the sequence is: [%.4f %.4f]\n', Simi_CIlower,Simi_CIupper);
else
  SEM = nanstd(SimilarIndex)/sqrt(length(SimilarIndex)-1);                 
  Simi_CIlower = nanmean(SimilarIndex) - 1.96*SEM                     
  Simi_CIupper = nanmean(SimilarIndex) + 1.96*SEM  
  fprintf('the confidence interval of SimilarIndex (discard invalid frames)over the sequence is: [%.4f %.4f]\n', Simi_CIlower,Simi_CIupper);
end
