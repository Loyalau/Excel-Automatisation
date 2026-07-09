% This function will calculate the Energy of each cycle and put it in the Result_Table table under the right column
function [E] = NRJ_Joule(TPi,A,B)

arguments (Input)
    TPi table
    A int32 % Starting line of the semi cycle in the TPi table
    B int32 % Ending of the semi cycle in the TPi table
end

arguments (Output)
    E int32 % Energy calculated for the cycle
end

E = 0;
col_disp = TPi{:,2};
col_force = TPi{:,3};

for i = A : B
    if i > 1 
        E = E + abs(col_disp(i)-col_disp(i-1))*abs((col_force(i)+col_force(i-1))/2);
    else
        E = 0; % To initialize the Energy at the beginning of each test to zero (to avoid any call of negative line) 
    end
end