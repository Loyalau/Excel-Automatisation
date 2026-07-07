function [D] = Cicli_bis(TPi)
% Same thing but for the last excel : "P22 NTC riel.xlsx" because he only has 1 sequence of 5 cycle
arguments (Input)
    TPi table
end

arguments (Output)
    D table
end
D = table(Size=[10 4], VariableTypes=["string" "double" "double" "double"], VariableNames=["Cycle","Time [s]","Displacement [mm]","Force [kN]"]);

l = 1; 

c =  TPi{l,2}; 
a = 1; 
for i = 1:5
    while c < 0.1 || c < TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d +", i);
    D{a,2} = TPi{l,1}; 
    D{a,3} = c;  
    D{a,4} = TPi{l,3};  
    a=a+1;
    while c > 0.1 || c > TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d -", i);
    D{a,2} = TPi{l,1}; 
    D{a,3} = c;  
    D{a,4} = TPi{l,3}; 
    a=a+1;

end