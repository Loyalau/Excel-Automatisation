% The goal is to deduce from the previous table cleaned by Clean_Table the time, displacement and force of all max and min point of each semi cycle, as well as the energy used during each semi cycle
function [D] = Cycle_format(TPi,Nb_Cycle)

arguments (Input)
TPi table
Nb_Cycle double
end

arguments (Output)
D table
end

% Initialization of the variable : 

l = 1; % "l" (for line) represent the line we are currently reading in the TPi table 
Vector_disp = TPi{:,2}; % To transform the displacement column of the table TPi into an array because it is far less time consuming that way
c = Vector_disp(l); % Candidate for the candidate method (it is the maximum/minimum we encountered for each loop)

a = 1; % The line we are currently during the writing of the output D table

% Initialization of the column of the future table in array form (less time consuming also)
Nb_SemiCycle = Nb_Cycle * 2;

Cycle_col = strings(Nb_SemiCycle,1);
Time_col = zeros(Nb_SemiCycle,1);
Disp_col = zeros(Nb_SemiCycle,1);
Force_col = zeros(Nb_SemiCycle,1);
NRJ_Semi_col = zeros(Nb_SemiCycle,1);
NRJ_col = zeros(Nb_SemiCycle,1);

% Filling of each Column
for k = 1 : Nb_Cycle

    A = l; % The starting line of the semi cycle (to begin the calculation of the Energy used during said semi cycle)

    % We are now searching for the maximum as we know that we are on a "positive cycle" (cycle in traction I assume)
    while c < 0.1 || c < Vector_disp(l+1) % We are searching for the global max of this semi cycle, c < 0.1 is a security because at the start we can have local max that skip the loop
        l = l + 1;
        c =  Vector_disp(l);
    end 

    % We found the global max of the cycle, it's time to fill each column :

    Cycle_col(a) = sprintf("%d +", k); % Add to the table the number/name of this cycle
    Time_col(a) = TPi{l,1}; % Add to the output the time corresponding to the max of this cycle
    Disp_col(a) = c;  % Add to the output the displacement corresponding to the max of this cycle
    Force_col(a) = TPi{l,3};  % Add to the output the force corresponding to the max of this cycle
    
    while Vector_disp(l+1) > 0  % We need to end the cycle for the calculation of the Energy used
        l = l + 1;
    end 

    B = l; % The ending line of the semi cycle (line on which we end the calculation of the Energy used during said semi cycle)
    E1 = NRJ_Joule(TPi,A,B); %NRJ of the first semi cycle
    NRJ_Semi_col(a) = E1 ; 
    NRJ_col(a) = 0 ; % This column is the NRJ for the whole cycle we will calculate it at the end of the cycle

    a=a+1; % We pass to the next line in the table D to not overwrite all the column

    % We are now searching for the minimum as we know that we are on a "negative cycle" (cycle in compression I assume)
    while c > 0.1 || c > Vector_disp(l+1)
        l = l +1;
        c =  Vector_disp(l);
    end
    % We found the global min of the cycle, it's time to fill the table :

    Cycle_col(a) = sprintf("%d -", k); % Add to the output the number of this cycle
    Time_col(a) = TPi{l,1}; % Add to the output the time corresponding to the min of this cycle
    Disp_col(a) = c;  % Add to the output the displacement corresponding to the min of this cycle
    Force_col(a) = TPi{l,3};  % Add to the output the force corresponding to the min of this cycle
    
    while Vector_disp(l+1) < 0   % We need to end the cycle for the calculation of the Energy used
        l = l + 1;
    end 

    C = l; % The ending line of the semi cycle (the beginning of this cycle is the end of the first one so it's B)
    E2 = NRJ_Joule(TPi,B,C); % NRJ of the second semi cycle
    NRJ_Semi_col(a) = E2;
    NRJ_col(a) = E1+E2; % NRJ of the whole cycle

    a=a+1;

end
Time_col = round(Time_col,1);
Disp_col = round (Disp_col,1);
Force_col = round (Force_col,1);

% Creation and filling of the Table that this function will have to output 
% (remark : VariableNames could have been declared on the Main and put as input for this function)

D = table(Cycle_col, Time_col, Disp_col, Force_col, NRJ_Semi_col, NRJ_col, zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), VariableNames=["Cycle","Time [s]","Displacement [mm]","Force [kN]","NRJ [J]","NRJ_Cycle [J]","d_eff [mm]","K_eff [kN/mm]","DK_eff [%]","Ksi_eff [%]","DKsi_eff [%]"]);
end