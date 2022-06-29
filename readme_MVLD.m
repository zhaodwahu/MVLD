clear;clc
addpath(genpath('.'));

load('yeast.mat')
starttime = datestr(now,0);
fprintf('Start Run MVLD at time:%s \n',starttime);
%% Initialization
%% Learning view-specific labels and label-feature dependence maximization for multi-view multi-label classification

[optmParameter,modelparameter] =  initialization;
time = zeros(1,modelparameter.cv_num);
num_views=length(dataMVML);

%% Procedures of Training and Test for MVLD
fprintf('Running MVLD\n');  

%% cross va lidation
num_data = size(dataMVML{1},1);

if modelparameter.normliza==1
    for i = 1:num_views
        dataMVML{i} = normalization(dataMVML{i}, 'l2', 1);
    end
end

cvResult  = cell(modelparameter.cv_num,1);
models = cell(modelparameter.cv_num,1);
cv_num=modelparameter.cv_num;

    for cv = 1:cv_num
        fprintf('Cross Validation - %d/%d\n', cv, cv_num);
        randorder = randperm(num_data);
        [cvTrainSet,cvTrain_target,cvTestSet,cvTest_target ] = generateMultiViewCVSet(dataMVML, target, randorder, cv, modelparameter.cv_num);
        tic
        cvMVLD   = MVLD(cvTrainSet, double(cvTrain_target), optmParameter);
        fprintf('\nMulti-view multi-label classification results:\n---------------------------------------------\n');
        cvResult{cv} = MVLD_Predict(cvTestSet, cvTest_target', cvMVLD, modelparameter, cvTrainSet, cvTrain_target');

        time(1,cv) = toc;
    end
[Avg_Result, averagetime] = PrintMVLDAvgResult(cvResult, time, modelparameter.cv_num);
model_MVLD.randorder = randorder;
model_MVLD.optmParameter = optmParameter;
model_MVLD.modelparameter = modelparameter;

model_MVLD.cvResult = cvResult;
model_MVLD.avg_Result = Avg_Result;
model_MVLD.averagetime = averagetime;

endtime = datestr(now,0);
fprintf('End Run MVLD at time:%s \n',endtime);
rmpath(genpath('.'));
beep;
