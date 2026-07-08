function [D] = K_eff(D,i)
% This function will calculate the effective stiffness of each cycle and put it in the Result_table under the right column
arguments (Input)
    D table
    i int32
end

arguments (Output)
    D table
end

if i ~= 22
    for k = 1 : 40
        D{k,8} = D{k,4} / D{k,7};
    end
else
    for k = 1 : 10
        D{k,8} = D{k,4} / D{k,7};
    end
end
end
