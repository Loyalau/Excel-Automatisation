function [E] = NRJ_Joule(TPi,A,B)
% This function will calculate the Energy of each cycle and put it in the Ciclo's table under the right column
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

% for i = A : B
%     if i > 1 
%         E = E + abs(TPi{i,2}-TPi{i-1,2})*abs((TPi{i,3}+TPi{i-1,3})/2);
%     else
%         E = 0;   
% end

for i = A : B
    if i > 1 
        E = E + abs(col_disp(i)-col_disp(i-1))*abs((col_force(i)+col_force(i-1))/2);
    else
        E = 0;   
    end
end