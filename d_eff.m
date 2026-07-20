% This function will calculate the effective displacement of each cycle and put it in the Result_table under the right column 
function [D] = d_eff(D,Gi,Nb_SemiCycle)

arguments (Input)
    D table
    Gi double % The play corresponding to the test number i
    Nb_SemiCycle double
end

arguments (Output)
    D table
end
 
M = ones(Nb_SemiCycle,1); % The goal is to create a matrix/Vector constituted of -gi +gi because d_eff = d +/- gioco

    for k = 1 : 2 : Nb_SemiCycle - 1
            M(k) = -Gi;
            M(k+1) = +Gi;
    end
end