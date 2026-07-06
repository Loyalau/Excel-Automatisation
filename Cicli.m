function [D] = Cicli(TPi)
%CICLO undefined
%the goal is to deduce from the previous table cleaned by Clean_Table the
%time, displacement and force of all max and min point of each cycle
arguments (Input)
    TPi table
end

arguments (Output)
    D table
end
D = table(Size=[40 4], VariableTypes=["string" "double" "double" "double"], VariableNames=["Cycle","Time [s]","Displacement [mm]","Force [kN]"]);

l = 1; %number of the current ligne

c =  TPi{l,2}; %candidate for the candidate method
a = 1; %for the append in D or else it will rewrite each ligne, needs to be different from i because of there is 2 ligne of append for each loop
for i = 1:5
    while c < TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d +", i);
    D{a,2} = TPi{l,1}; %update the time column corresponding to the chosen cycle
    D{a,3} = c;  %update the displacement column corresponding to the chosen cycle
    D{a,4} = TPi{l,3};  %update the force column corresponding to the chosen cycle
    a=a+1;
    while c > TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d -", i);
    D{a,2} = TPi{l,1}; %update the time column corresponding to the chosen cycle
    D{a,3} = c;  %update the displacement column corresponding to the chosen cycle
    D{a,4} = TPi{l,3};  %update the force column corresponding to the chosen cycle
    a=a+1;
    end

end

%for i = 1:5

%end

%for i = 1:10

%end



%end