function [D] = K_eff(D,i,Nb_SemiCycle)
% This function will calculate the effective stiffness of each cycle and put it in the Result_table under the right column
arguments (Input)
    D table
    i int32
    Nb_SemiCycle double
end

arguments (Output)
    D table
end

for k = 1 : Nb_SemiCycle
    D{k,8} = D{k,4} / D{k,7};
end

end

