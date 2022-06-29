
function [model_MVLD] = MVLD( X_set, Y, optmParameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% optimization parameters
    lambda1          = optmParameter.lambda1;
    lambda2          = optmParameter.lambda2;
    lambda3          = optmParameter.lambda3;
    lambda4          = optmParameter.lambda4;
    kernel_para      = optmParameter.kernel_para;
    kernel_type      = optmParameter.kernel_type;

   %% Initialization

    Y=sparse(Y);
    [U,iterVal,Omega_train]=VLL(X_set,Y,lambda1,kernel_type,kernel_para );
    [n,~]=size(Y);
    num_views=length(X_set);
    
    theta = ones(num_views,1)/num_views;
    W_set = cell(num_views,1);
    PreY  = cell(num_views,1);
    prediction_Loss       = zeros(num_views,1);
    
   %% Optimization
            clear Y
            K = HSIC(X_set);
            clear X_set
            for uu=1:num_views
                W_set{uu}= ((speye(n) - lambda3*K{uu,1})*Omega_train{uu} + lambda2*speye(n))\U{uu};
                PreY{uu} = Omega_train{uu}*W_set{uu};
                prediction_Loss(uu,1)=trace((Omega_train{uu}*W_set{uu}-U{uu})'*(Omega_train{uu}*W_set{uu}-U{uu}));
            end
              %% update theta: Coordinate descent
               if optmParameter.updateTheta == 1
                   theta  = updateTheta(theta, lambda4, prediction_Loss);
               end

               if optmParameter.outputthetaQ == 1
                   fprintf(' - prediction loss: ');
                   for mm=1:num_views
                        fprintf('%e, ', prediction_Loss(mm));
                   end
                   fprintf('\n - theta: ');
                   for mm=1:num_views
                        fprintf('%.3f, ', theta(mm));
                   end
                   fprintf('\n');
               end

            clear prediction_Loss
            %% return values
            model_MVLD.W = W_set;
            model_MVLD.PreY = PreY;
            model_MVLD.theta = theta;
            model_MVLD.kernel_para = kernel_para;
            model_MVLD.kernel_type = kernel_type;
            model_MVLD.loss=iterVal;
end
function K = HSIC(X_set)
    num_views=length(X_set);
    n=size(X_set{1},1);
    H = ones(n,n)*(1/n)*(-1) + speye(n);
    K=cell(num_views,1);
    for v=1:num_views
        K{v,1}  =  H*X_set{v,1}*X_set{v,1}'*H;
    end

end
function [theta_t ] = updateTheta(theta, lambda, q)
    m = length(theta);
    negative = 0;
    theta_t = zeros(m,1);
    
    for i =1:m
       theta_t(i,1) = (lambda+sum(q) - m*q(i))/(m*lambda);
       if theta_t(i,1) < 0
           negative = 1;
           theta_t(i,1) = 0.0000001;
       end
    end
    if negative == 1
       theta_t = theta_t./sum(theta_t);
    end
end

