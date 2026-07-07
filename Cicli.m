function [D] = Cicli(TPi)
% The goal is to deduce from the previous table cleaned by Clean_Table the time, displacement and force of all max and min point of each cycle and to put it on a new table  
% In this version it also create all the table 
arguments (Input)
    TPi table
end

arguments (Output)
    D table
end
D = table(Size=[40 10], VariableTypes=["string" "double" "double" "double" "int32" "double" "double" "double" "double" "double"], VariableNames=["Cycle","Time [s]","Displacement [mm]","Force [kN]","NRJ [J]","d_eff [mm]","K_eff [kN/mm]","DK_eff [%]","Ksi_eff [%]","DKsi_eff [%]"]);

l = 1; % "l" represent the line in the table 

c =  TPi{l,2}; % Candidate for the candidate method
a = 1; % Line in the output for the append in D or else it will rewrite each line, needs to be different from i because of there is 2 line (min and max) to put in the table for each cycle
for i = 1:5
    A = l; % The starting line of the semi cycle/The starting line of the cycle
    while c < 0.1 || c < TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d +", i); % Add to the output the number of this cycle
    D{a,2} = TPi{l,1}; % Add to the output the time corresponding to the max of this cycle
    D{a,3} = c;  % Add to the output the displacement corresponding to the max of this cycle
    D{a,4} = TPi{l,3};  % Add to the output the force corresponding to the max of this cycle

    B = l; % The ending line of the semi cycle/The starting line of the other semi cycle
    E1 = NRJ_Joule(D,TPi,A,B);
    D{a,5} = 0 ; % Because we calculate the energy for each entire cycle hence we don't calculate the energy for this semi cycle (I tried to put an X but since this column only take int for value my X was converted to 88 which I assume is the ASCI value of "X")

    a=a+1;
    while c > 0.1 || c > TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d -", i); % Add to the output the number of this cycle
    D{a,2} = TPi{l,1}; % Add to the output the time corresponding to the min of this cycle
    D{a,3} = c;  % Add to the output the displacement corresponding to the min of this cycle
    D{a,4} = TPi{l,3};  % Add to the output the force corresponding to the min of this cycle

    C = l; %The ending line of the semi cycle/The ending line of the cycle
    E2 = NRJ_Joule(D,TPi,B,C);
    D{a,5} = E1+E2;

    a=a+1;

end

while c < 0 % To ensure that we are at the start of the next sequence of cycle in the table
    l = l +1;
    c =  TPi{l,2};
end 

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
    D{a,5} = 0 ; % Because we calculate the energy for each entire cycle hence we don't calculate the energy for this semi cycle (I tried to put an X but since this column only take int for value my X was converted to 88 which I assume is the ASCI value of "X")

    a=a+1;
    while c > 0.1 ||c > TPi{l+1,2}
        l = l +1;
        c =  TPi{l,2};
    end
    D{a,1} = sprintf("%d -", i);
    D{a,2} = TPi{l,1}; 
    D{a,3} = c;  
    D{a,4} = TPi{l,3}; 

    C = l; %The ending line of the semi cycle/The ending line of the cycle
    E2 = NRJ_Joule(D,TPi,B,C);
    D{a,5} = E1+E2;

    a=a+1;

end

while c < 0
    l = l +1;
    c =  TPi{l,2};
end 

for i = 1:10
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
    D{a,5} = 0 ; % Because we calculate the energy for each entire cycle hence we don't calculate the energy for this semi cycle (I tried to put an X but since this column only take int for value my X was converted to 88 which I assume is the ASCI value of "X")

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
    D{a,5} = E1+E2;

    a=a+1;

end



end