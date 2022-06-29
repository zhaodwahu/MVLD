function [U,iterVal,Omega_train]=VLL(X_set,Y,alpha,kernel_type,kernel_para)
%% View-specific label learning
num_views=length(X_set);
[n,m]=size(Y);
U=cell(num_views,1);
L=cell(num_views,1);
Omega_train=cell(num_views,1);
preloss=zeros(num_views,1);
theta_temp=zeros(num_views,1);
theta=ones(num_views,1)/num_views;

options = [];
options.Metric = 'Euclidean';
options.NeighborMode = 'KNN';
options.k = 10;  % nearest neighbor
options.WeightMode = 'HeatKernel';
options.t = 1;
for i = 1:num_views
    S = constructW(X_set{i},options);
    L{i,1} = diag(sum(S,2))-S;
    Omega_train{i} = kernel_matrix(X_set{i}, kernel_type, kernel_para);
end
%% updating variables...
iterVal = zeros(1,10);
    for iter=1:10
        theta_all=0;
        for v=1:num_views
            U{v,1}=(speye(n)+theta(v)*alpha*L{v,1})\(Y);
            theta_temp(v) = 1/2/trace(U{v,1}'*L{v}*U{v,1});
            theta_all = theta_all + theta_temp(v);
            preloss(v,1)=trace((U{v,1}-Y)'*(U{v,1}-Y));
            kloss=theta(v)*trace(U{v,1}'*L{v}*U{v,1});
        end
        theta = theta_temp/theta_all;
        diff = sum(preloss)/2+sum(kloss)/2;
        iterVal(iter) = abs(diff);
        if abs(diff)<1e-5
            break
        end
    end

end
