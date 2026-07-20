% This function will calculate the effective stiffness of each cycle and put it in the Result_table under the right column
function [D] = K_eff(D)

arguments (Input)
    D table
end

arguments (Output)
    D table
end

D{:,8} = D{:,4} ./ D{:,7};
D{:,8} = round(D{:,8},2);
end

