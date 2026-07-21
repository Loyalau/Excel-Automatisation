% The goal is to deduce from the previous table cleaned by Clean_Table the time, displacement and force of all max and min point of each semi cycle, as well as the energy used during each semi cycle
function [D] = Cycle_format(TPi,Nb_Cycle,ref)

arguments (Input)
TPi table
Nb_Cycle double
ref double
end

arguments (Output)
D table
end

% Initialization of the variable : 
Vector_disp = TPi{:,2}; % To transform the displacement column of the table TPi into an array because it is far less time consuming that way

tolerance = 0.1*ref; % In this example there is 6 mm of tolerance for the EN procedure/8mm for NTC (max and min are often around 3mm of error so that's ok)

% Initialization of the column of the future table in array form (less time consuming also)
Nb_SemiCycle = Nb_Cycle * 2;

Cycle_col = strings(Nb_SemiCycle,1);
Time_col = zeros(Nb_SemiCycle,1);
Disp_col = zeros(Nb_SemiCycle,1);
Force_col = zeros(Nb_SemiCycle,1);
NRJ_Semi_col = zeros(Nb_SemiCycle,1);
NRJ_col = zeros(Nb_SemiCycle,1);

% Search of the global maximum 
[pks_pos, locs_pos] = findpeaks(Vector_disp, 'MinPeakProminence', 5);

% Search of the global minimum
[pks_neg_raw, locs_neg] = findpeaks(-Vector_disp, 'MinPeakProminence', 5); % It is the same as the search for the global max but we inverse the signal (-Vector) and we search for the max of the inverse (= the min, works only because min are negative here)
pks_neg = -pks_neg_raw; % Don't forget to re-inverse the signal to have the real value of the displacement


a=1; % The line we are writing on the output D table // even value of a correspond to positive cycle and odd value to negative one 

for i = 1 : length(pks_pos) % We fill in the positive cycle (global max previously found)
    if abs(pks_pos(i) - ref) <= tolerance
        Cycle_col(a) = sprintf("%d +", i); % Add to the table the number/name of this cycle
        Time_col(a) = TPi{locs_pos(i),1}; % Add to the output the time corresponding to the max of this cycle
        Disp_col(a) = TPi{locs_pos(i),2};  % Add to the output the displacement corresponding to the max of this cycle
        Force_col(a) = TPi{locs_pos(i),3};  % Add to the output the force corresponding to the max of this cycle
        a=a+2;
    end
    

end

a = 2; % To be on odd value of a for negative cycle

for k = 1 : length (pks_neg) % We fill in the negative cycle (global min previously found)
    if abs(pks_neg(k) + ref) <= tolerance
        Cycle_col(a) = sprintf("%d -", k); % Add to the output the number of this cycle
        Time_col(a) = TPi{locs_neg(k),1}; % Add to the output the time corresponding to the min of this cycle
        Disp_col(a) = TPi{locs_neg(k),2};  % Add to the output the displacement corresponding to the min of this cycle
        Force_col(a) = TPi{locs_neg(k),3};  % Add to the output the force corresponding to the min of this cycle
    
        a=a+2;
    end

end

% To calculate the Energy of each cycle we need to know when they start and end, we know that a cycle start and end when the displacement reach 0 (approaching from negative or positive value)
% Therefore to find the start and end of each cycle we search for the 0 in the displacement and to do so we look when to consecutive value of  measured displacement (Vector_disp(1:end-1) and Vector_disp(2:end)) have different sign (one is before 0 and the other after), by comparing their  product and 0
zero_idx = find(Vector_disp(1:end-1) .* Vector_disp(2:end) <= 0);
a = 1 ;

% We needs to make sur that the first energy calculation is done at the start of the data sample even if it's not a zero
if zero_idx(1) ~= 1
    zero_idx = [1; zero_idx];
end


for n = 1 : 2 : length (zero_idx) % We fill in the negative cycle (global min previously found)
    if n + 3 <= length (zero_idx)
        A = zero_idx(n); % The starting line of the semi cycle (to begin the calculation of the Energy used during said semi cycle)
        B = zero_idx(n+1);
        E1 = NRJ_Joule(TPi,A,B); % NRJ of the first semi cycle
        NRJ_Semi_col(a) = E1 ; 
        NRJ_col(a) = 0 ; % This column is the NRJ for the whole cycle we will calculate it at the end of the cycle
        a = a + 1;

        C = zero_idx(n+2);
        E2 = NRJ_Joule(TPi,B,C); % NRJ of the second semi cycle
        NRJ_Semi_col(a) = E2;
        NRJ_col(a) = E1+E2; % NRJ of the whole cycle
        a = a + 1;
        
    end
    
end

Time_col = round(Time_col,1);
Disp_col = round (Disp_col,2); % If I round to 1 decimal after the ',' d_eff is calculated as 0 
Force_col = round (Force_col,1);

% Creation and filling of the Table that this function will have to output 
% (remark : VariableNames could have been declared on the Main and put as input for this function)

D = table(Cycle_col, Time_col, Disp_col, Force_col, NRJ_Semi_col, NRJ_col, zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), zeros(Nb_SemiCycle,1), VariableNames=["Cycle","Time [s]","Displacement [mm]","Force [kN]","NRJ [J]","NRJ_Cycle [J]","d_eff [mm]","K_eff [kN/mm]","DK_eff [%]","Ksi_eff [%]","DKsi_eff [%]"]);
end