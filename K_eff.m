function [D] = K_eff(D,i)
%K_EFF undefined
%   undefined
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
