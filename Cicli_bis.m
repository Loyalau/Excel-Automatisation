function [D] = Cicli_bis(TPi)
% Same thing but for the last excel : "P22 NTC riel.xlsx" because he only has 1 sequence of 5 cycle
arguments (Input)
    TPi table
end

arguments (Output)
    D table
end
D = table(Size=[10 11], VariableTypes=["string" "double" "double" "double" "int32" "double" "double" "double" "double" "double" "double"], VariableNames=["Cycle","Time [s]","Displacement [mm]","Force [kN]","NRJ [J]","NRJ_cycle [J]","d_eff [mm]","K_eff [kN/mm]","DK_eff [%]","Ksi_eff [%]","DKsi_eff [%]"]);

l = 1; 

c =  TPi{l,2}; 
a = 1; 
for i = 1:5
    
    A = l; % The starting line of the semi cycle/The starting line of the cycle
    while c < 0.1 || c < TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d +", i);
    D{a,2} = TPi{l,1}; 
    D{a,3} = c;  
    D{a,4} = TPi{l,3};  
    
    B = l; % The ending line of the semi cycle/The starting line of the other semi cycle
    E1 = NRJ_Joule(D,TPi,A,B);
    D{a,5} = E1 ; 
    D{a,6} = 0 ;

    a=a+1;
    while c > 0.1 || c > TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d -", i);
    D{a,2} = TPi{l,1}; 
    D{a,3} = c;  
    D{a,4} = TPi{l,3}; 
    
    C = l; %The ending line of the semi cycle/The ending line of the cycle
    E2 = NRJ_Joule(D,TPi,B,C);
    D{a,5} = E2;
    D{a,6} = E1+E2;

    a=a+1;
end


end