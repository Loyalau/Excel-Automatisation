function [E] = NRJ_Joule(Result_table_i,TPi,A,B)
% This function will calculate the Energy of each cycle and put it in the Ciclo's table under the right column
arguments (Input)
    Result_table_i table
    TPi table
    A int32 % Starting line of the cycle in the TPi table
    B int32 % Ending of the cycle in the TPi table
end

arguments (Output)
    E int32 % Energy calculated for the cycle
end

E = 0;
absD = 0; % Absolute value of the difference between two successive displacement value of the Tpi's table
absMoyF = 0; % Absolute value of the mean between two successive force value of the Tpi's table



for i = A : B
    if i > 1 
        absD = abs(TPi{i,2}-TPi{i-1,2}) ;
        absMoyF = abs((TPi{i,3}+TPi{i-1,3})/2);
        E = E + absD*absMoyF;
    else
        E = 0;   
end

end