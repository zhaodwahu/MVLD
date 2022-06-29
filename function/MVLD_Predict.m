
function result = MVLD_Predict(Xtest_set, Ytest, model_MVLD, modelparameter, Xtrain_set, Ytrain)
    num_views = size(Xtest_set,1);
    [num_class,num_test] = size(Ytest);
    result = zeros(6,1);
    MVLD_funsion_outputs = zeros(num_class,num_test);
    kernel_para=model_MVLD.kernel_para;
    kernel_type=model_MVLD.kernel_type;
    W=model_MVLD.W;
    theta=model_MVLD.theta;
    for i = 1:num_views

        Omega_test = kernel_matrix(Xtrain_set{i}, kernel_type,kernel_para, Xtest_set{i});
        Outputs=(Omega_test' * W{i});
        Outputs      = Outputs';
        MVLD_funsion_outputs    = MVLD_funsion_outputs + theta(i).*Outputs;
    end
   %% funsion
    threshold = tuneThresholdMVML(Xtrain_set, Ytrain, model_MVLD, modelparameter);

    Pre_Labels   = MVLD_funsion_outputs >= threshold(1,1); 
    Pre_Labels   = Pre_Labels >= threshold(1,1); 

    result(:,1)  = EvaluationAll(Pre_Labels,MVLD_funsion_outputs,Ytest);
end

function threshold = tuneThresholdMVML(Xtrain_set, Ytrain, model_MVLD, modelparameter)
    num_views = size(Xtrain_set,1);
    MVLD_funsion_outputs = zeros(size(Ytrain'));
    PreY=model_MVLD.PreY;
    theta=model_MVLD.theta;
    tuneThresholdType=modelparameter.tuneThresholdType;
    for i = 1:num_views    
        Outputs= PreY{i};
        MVLD_funsion_outputs  = MVLD_funsion_outputs + Outputs*theta(i);
    end
    [ threshold,  ~] = TuneThreshold( MVLD_funsion_outputs', Ytrain, 1, tuneThresholdType);
end