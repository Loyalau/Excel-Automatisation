function [D] = Ksi(D,i)
% This function will calculate the equivalent dumping of each cycle and put it in the Result_table under the right column
arguments (Input)
    D table
    i int32
end

arguments (Output)
    D table
end

if i ~= 22
    for k = 1 : 40
        if D{k,6} ~= 0 % We verify that we aren't on a line in which NRJ_Cycle = 0
            D{k,10} = 100*( double(D{k,6}) / (2*pi*D{k,4}*D{k,7}) );
        else
            D{k,10} = 100*( double(D{k+1,6}) / (2*pi*D{k,4}*D{k,7}) );
        end
        
    end
else
    for k = 1 : 10
        if D{k,6} ~= 0 % We verify that we aren't on a line in which NRJ_Cycle = 0
            D{k,10} = 100*( double(D{k,6}) / (2*pi*D{k,4}*D{k,7}) );
        else
            D{k,10} = 100*( double(D{k+1,6}) / (2*pi*D{k,4}*D{k,7}) );
        end
    end
end
end
