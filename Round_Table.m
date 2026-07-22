% To round a number we need to transform it into char because round a double mean that you round to the superior number BUT it will keep the same amount of number after the ',' as '0' so it is not good to look at 
% Hence the solution that is kept here is the following : 
function [D] = Round_Table(D)
%ROUND_TABLE undefined
%   undefined
arguments (Input)
    D table
end

arguments (Output)
    D table
end

% The column to round are as follows : 

% Time : Di{:,2}; 
% Disp : Di{:,3};  
% Force : Di{:,4}; 
% D_eff :  Di{:,7};
% K_eff : Di{:,8};
% DK_eff : Di{:, 9}; 
% Ksi_eff : Di{:, 10};
% DKsi_ef : Di{:, 11};

Di{:,2} = string(num2str(Di{:,2}, '%.1f'));
Di{:,3} = string(num2str(Di{:,3}, '%.2f')); % If I round to 1 decimal after the ',' d_eff is calculated as 0 
Di{:,4} = string(num2str(Di{:,4}, '%.1f'));
Di{:,7} = string(num2str(Di{:,7}, '%.1f'));
Di{:, 8} = string(num2str(Di{:, 8}, '%.2f'));
Di{:, 9} = string(num2str(Di{:, 9}, '%.2f')); % I need to round to 2 decimal for D_Keff or else it as a lot of 0 (and not 0.x)
Di{:, 10} = string(num2str(Di{:, 10}, '%.2f'));
Di{:, 11} = string(num2str(Di{:, 11}, '%.2f')); 
end