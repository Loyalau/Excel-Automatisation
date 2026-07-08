function [D] = Delta(D,i)
% This function will calculate DK_eff and DKsi of each cycle and put it in the Result_table under the right column
arguments (Input)
    D table
    i int32
end

arguments (Output)
    D table
end

if i ~= 22
    for k = 1 : 10
        if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
            D{k,9} = 100*(D{k,8} - D{5,8})/D{5,8} ;
            D{k,11} = 100*(D{k,10} - D{5,10})/D{5,10};
        else
            D{k,9} = 100*(D{k,8} - D{6,8})/D{6,8} ;
            D{k,11} = 100*(D{k,10} - D{6,10})/D{6,10};
        end
         
    end
    for k = 11 : 20
        if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
            D{k,9} = 100*(D{k,8} - D{15,8})/D{15,8} ;
            D{k,11} = 100*(D{k,10} - D{15,10})/D{15,10};
        else
            D{k,9} = 100*(D{k,8} - D{16,8})/D{16,8} ;
            D{k,11} = 100*(D{k,10} - D{16,10})/D{16,10};
        end

    end
    for k = 21 : 40
        if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
            D{k,9} = 100*(D{k,8} - D{25,8})/D{25,8} ;
            D{k,11} = 100*(D{k,10} - D{25,10})/D{25,10};
        else
            D{k,9} = 100*(D{k,8} - D{26,8})/D{26,8} ;
            D{k,11} = 100*(D{k,10} - D{26,10})/D{26,10};
        end

    end
else
    for k = 1 : 10
        if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
            D{k,9} = 100*(D{k,8} - D{5,8})/D{5,8} ;
            D{k,11} = 100*(D{k,10} - D{5,10})/D{5,10};
        else
            D{k,9} = 100*(D{k,8} - D{6,8})/D{6,8} ;
            D{k,11} = 100*(D{k,10} - D{6,10})/D{6,10};
        end
    end
end
end