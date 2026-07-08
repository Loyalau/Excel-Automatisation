function [D] = Cycle_format(TPi,i,Nb_Cycle,Nb_Sequence,Nb_SemiCycle)
% The goal is to deduce from the previous table cleaned by Clean_Table the time, displacement and force of all max and min point of each semi cycle,
% as well as the energy used during each semi cycle

arguments (Input)
TPi table
i int32
Nb_Cycle double
Nb_Sequence int32
Nb_SemiCycle int32
end

arguments (Output)
D table
end

% Initialization of the variable
l = 1; % "l" represent the line we are currently reading in the TPi table 
c =  TPi{l,2}; % Candidate for the candidate method (it is the maximum/minimum we encountered for each loop
a = 1; % The line we are currently during the writing of the output D table

% Creation of the Table that this function will have to output 
% (remark : VariableTypes and VariableNames could have been declared on the Main and put as input for this function)
D = table(Size=[Nb_SemiCycle 11], VariableTypes=["string" "double" "double" "double" "int32" "double" "double" "double" "double" "double" "double"], VariableNames=["Cycle","Time [s]","Displacement [mm]","Force [kN]","NRJ [J]","NRJ_Cycle [J]","d_eff [mm]","K_eff [kN/mm]","DK_eff [%]","Ksi_eff [%]","DKsi_eff [%]"]);

% Filling of the Table D
for i = 1 : Nb_Sequence 
    for k = 1 : Nb_Cycle(i)

        A = l; % The starting line of the semi cycle (to begin the calculation of the Energy used during said semi cycle)

        % We are now searching for the maximum as we know that we are on a "positive cycle" (cycle in traction I assume)
        while c < 0.1 || c < TPi{l+1,2} % We are searching for the global max of this semi cycle, c < 0.1 is a security because at the start we can have local max that skip the loop
            l = l + 1;
            c =  TPi{l,2};
        end 

        % We found the global max of the cycle, it's time to fill the table :

        D{a,1} = sprintf("%d +", k); % Add to the table the number of this cycle
        D{a,2} = TPi{l,1}; % Add to the output the time corresponding to the max of this cycle
        D{a,3} = c;  % Add to the output the displacement corresponding to the max of this cycle
        D{a,4} = TPi{l,3};  % Add to the output the force corresponding to the max of this cycle

        B = l; % The starting line of the semi cycle (line on which we end the calculation of the Energy used during said semi cycle)
        E1 = NRJ_Joule(D,TPi,A,B); %NRJ of the first semi cycle
        D{a,5} = E1 ; 
        D{a,6} = 0 ; % This column is the NRJ for the whole cycle we will calculate it at the end of the cycle

        a=a+1; % We pass to the next line in the table D to not overwrite

        % We are now searching for the minimum as we know that we are on a "negative cycle" (cycle in compression I assume)
        while c > 0.1 || c > TPi{l+1,2}
            l = l +1;
            c =  TPi{l,2};
        end
        % We found the global min of the cycle, it's time to fill the table :

        D{a,1} = sprintf("%d -", k); % Add to the output the number of this cycle
        D{a,2} = TPi{l,1}; % Add to the output the time corresponding to the min of this cycle
        D{a,3} = c;  % Add to the output the displacement corresponding to the min of this cycle
        D{a,4} = TPi{l,3};  % Add to the output the force corresponding to the min of this cycle

        C = l; % The ending line of the semi cycle (the beginning of this cycle is the end of the first one so it's B)
        E2 = NRJ_Joule(D,TPi,B,C); % NRJ of the second semi cycle
        D{a,5} = E2;
        D{a,6} = E1+E2; % NRJ of the whole cycle

        a=a+1;

    end
end 

end