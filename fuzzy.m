%% Fuzzy C-means Algorithm

function [center, fuzz_vec, objective_funct] = fuzzy(data, num_clust, specs)
%data takes the array of the scatter you want to find the centroids
%num_clust is the number of clusters

%specs an array that:
% exponent for the matrix fuzz_vec             (2)
% maximum number of iterations          (100)
% minimum amount of improvement         (1e-5)
% info display during iteration         (1)


if nargin ~= 2 && nargin ~= 3
	error('Too many or too few input arguments!');
end
data_n = size(data, 1);
% Change the following to set default specs
def_opt = [   2;  
		            100;  
		           1e-5;  
		             1];  
if nargin == 2
    specs = def_opt;
else
    if length(specs) < 4
        tmp = def_opt;
        tmp(1:length(specs)) = specs;
        specs = tmp;
    end
    nan_index = find(isnan(specs)==1);
    specs(nan_index) = def_opt(nan_index);
    if specs(1) <= 1
        error('The exponent should be greater than 1!');
    end
end
lint_ball = specs(1);		       % fuzzinator fuzzy factor (fuzzifier)
%two different stop cond
stop_iter = specs(2);         % Max. iteration
no_improve = specs(3);        % Min. improvement

objective_funct = zeros(stop_iter, 1); 
fuzz_vec = rand(num_clust, data_n);
col_sum = sum(fuzz_vec);
fuzz_vec = fuzz_vec./col_sum(ones(num_clust, 1), :);
sum_data_dot_data = sum(data.*data,2)';
for i = 1:stop_iter
    
    fuzzinator_factor = fuzz_vec.^lint_ball;       
    center = bsxfun(@rdivide,fuzzinator_factor*data,sum(fuzzinator_factor,2));
    dist = bsxfun(@plus, sum_data_dot_data, sum(center.*center,2)) - 2*(center*data');
           
    objective_funct(i) = sum(sum(dist.*fuzzinator_factor));
        
    tmp = dist.^(-1/(lint_ball-1));
    fuzz_vec = bsxfun(@rdivide, tmp, sum(tmp,1));

	
    
    if ( i > 1 ) &&  ( abs(objective_funct(i) - objective_funct(i-1)) < no_improve )
        break;        
    end
end
iter_n = i;	
objective_funct(iter_n+1:stop_iter) = [];

