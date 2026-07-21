% This function will calculate the equivalent dumping of each cycle and put it in the Result_table under the right column
function [D] = Ksi(D,Nb_SemiCycle)

arguments (Input)
    D table
    Nb_SemiCycle double
end 

arguments (Output)
    D table
end

for k = 1 : Nb_SemiCycle
    if D{k,6} ~= 0 % We verify that we aren't on a line in which NRJ_Cycle = 0
        D{k,10} = 100*( double(D{k,6}) / (2*pi*D{k,4}*D{k,7}) );
    else % If we are on the line for which NRJ_Cycle = 0, we just look for the line in which NRJ_Cycl != 0 under the condition that we aren't at the end of the data table
        if k + 1 <= length(D{:,6})
            D{k,10} = 100*( double(D{k+1,6}) / (2*pi*D{k,4}*D{k,7}) );
        end
    end      
end
D(:, 10) = table(round(D{:, 10}, 2));
end
