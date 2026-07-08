function [D] = d_eff(D,i,G,Nb_SemiCycle)
% This function will calculate the effective displacement of each cycle and put it in the Result_table under the right column
arguments (Input)
    D table
    i int32
    G table % Table of all the play/gioco created in Open_Excel
    Nb_SemiCycle double
end

arguments (Output)
    D table
end

gi = G{i,1}; % The play corresponding to the test number i
M = ones(Nb_SemiCycle,1); % The goal is to create a matrix/Vector constituted of -gi +gi because d_eff = d +/- gioco

    for k = 1 : 2 : Nb_SemiCycle - 1
            M(k) = -gi;
            M(k+1) = +gi;
    end

D{:,7} = D{:,3} + M;   

end