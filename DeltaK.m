% This function will calculate DK_eff and DKsi of each cycle and put it in the Result_table under the right column
function [D] = DeltaK(D,Nb_Cycle)

arguments (Input)
    D table
    Nb_Cycle double
  
end

arguments (Output)
    D table
end
for k = 1 : 20
    if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
                D{k,9} = 100*(D{k,8} - D{5,8})/D{5,8} ;
                D{k,11} = 100*(D{k,10} - D{5,10})/D{5,10};
            else
                D{k,9} = 100*(D{k,8} - D{6,8})/D{6,8} ;
                D{k,11} = 100*(D{k,10} - D{6,10})/D{6,10};
    end
end
D(:, 9) = table(round(D{:, 9}, 1));
D(:, 11) = table(round(D{:, 11}, 1));
end