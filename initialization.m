function [optmParameter,modelparameter] =  initialization
%%%% para   :lambda1, lambda2, lambda3, lambda4, kernel_para
%emotions   :10^-1,    10^-6,  10^-3,    10^4,    0.5 
%yeast      :10^-1,    10^-1,  10^-3,    10^4,    0.5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    optmParameter.lambda1       = 10^-1; 
    optmParameter.lambda2       = 10^-1;
    optmParameter.lambda3       = 10^-3;
    optmParameter.lambda4       = 10^4;
    optmParameter.kernel_para   = [0.5];
    optmParameter.kernel_type   = 'RBF_kernel';

    optmParameter.updateTheta       = 1;
    optmParameter.outputthetaQ      = 1;
    %% Model Parameters

    modelparameter.tuneParaOneTime    = 1;
    modelparameter.normliza           = 1; %
    modelparameter.tuneThresholdType  = 1; % 1:Hloss, 2:Acc, 3:F1, 4:LabelBasedAccuracy, 5:LabelBasedFmeasure, 6:SubACC 
    modelparameter.crossvalidation    = 1; % {0,1}
    modelparameter.cv_num             = 5;
    modelparameter.splitpercentage    = 0.8; %[0,1]
end