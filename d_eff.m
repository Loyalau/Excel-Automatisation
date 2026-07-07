function [Gp] = d_eff(Result_table_i,i,G)
% This function will calculate the effective displacement of each cycle and put it in the Ciclo's table under the right column
arguments (Input)
    Result_table_i table
    i int32
    G table % Table of all the play/gioco
end

arguments (Output)
    Gp double % Effective displacement calculated for each cycle
end

gi = G{i,1};
if i ~= 22
    Gp = ones(40,1);
    for k = 1 : 2 : 39
            Gp(k) = -gi;
            Gp(k+1) = +gi;
    end
else
    Gp = ones(10,1);
    for k = 1 : 2 : 9
        Gp(k) = -gi;
        Gp(k+1) = +gi;
    end
end
            
end