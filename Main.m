% Initialization of the variable :
G = table(Size=[22 1], VariableTypes="double", VariableNames="Play_[mm]"); % Table that will receive later all the play (Gioco in italian) of all the test
Gioco = 0; % Variable associated to the play table to momentary store the play of each test

Nb_Cycle1_21 = [5, 5, 10]; % Here is the number of cycle for the Excel 1 to 21
Nb_Cycle22 = [5]; % Here is the number of cycle for the Excel 22



% Main program :
 for i = 1 : 22
    if i ~= 22 % For now we use this because the file 22 is different, may be corrected on a later upgrade 

        filename = sprintf("C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Xcel\\P%d EN riel.xlsx", i);
        [Table_Excel, Gioco] = Open_Excel(filename,["RunningTime","Dislacement","Force_1"]); %There is a typo on the "displacement column" as it read "dislacement" instead of displacement, doesn't matter will be corrected in Result_table
        G{i,1} = Gioco; 
        TP{i} = Clean_Table(Table_Excel);

        Nb_Cycle_tot = sum(Nb_Cycle1_21); % Number of Cycle if we add all of them (ex: for test 1 to 21 it's 20 since 5+5+10 = 20, for test 22 it's 5)
        Nb_Sequence = numel(Nb_Cycle1_21); % Number of Sequence of Cycle we have during one test (ex: for test 1 to 21 it's 3 because there is 5 5 10, for test 22 it's 1 because there is just the sequence of 5 cycle)
        Nb_SemiCycle = 2 * Nb_Cycle_tot;

        Result_table{i} = Cycle_format(TP{i},i,Nb_Cycle1_21,Nb_Sequence,Nb_SemiCycle);

        Result_table{i} = d_eff(Result_table{i},i,G,Nb_SemiCycle); % Calculation of the column d_eff
        Result_table{i} = K_eff(Result_table{i},i,Nb_SemiCycle); % Calculation of K_eff
        Result_table{i} = Ksi(Result_table{i},i,Nb_SemiCycle); % Calculation of Ksi
        Result_table{i} = DeltaK(Result_table{i},i,Nb_Cycle1_21,Nb_Sequence); % Calculation of DK_eff and DKsi

    else 

        [Table_Excel, Gioco] = Open_Excel("C:\Users\sonia\OneDrive\Bureau\Aurélien\Stage\Stage 2A Trento LPMS\Xcel\P22 NTC riel.xlsx",["RunningTime","Dislacement","Force_1"]);
        G{i,1} = Gioco; 
        TP{i} = Clean_Table(Table_Excel);

        Nb_Cycle_tot = sum(Nb_Cycle22); % Number of Cycle if we add all of them (ex: for test 1 to 21 it's 20 since 5+5+10 = 20, for test 22 it's 5)
        Nb_Sequence = numel(Nb_Cycle22); % Number of Sequence of Cycle we have during one test (ex: for test 1 to 21 it's 3 because there is 5 5 10, for test 22 it's 1 because there is just the sequence of 5 cycle)
        Nb_SemiCycle = 2 * Nb_Cycle_tot;

        Result_table{i} = Cycle_format(TP{i},i,Nb_Cycle22,Nb_Sequence,Nb_SemiCycle); 

        Result_table{i} = d_eff(Result_table{i},i,G,Nb_SemiCycle); % Calculation of the column d_eff
        Result_table{i} = K_eff(Result_table{i},i,Nb_SemiCycle); % Calculation of K_eff
        Result_table{i} = Ksi(Result_table{i},i,Nb_SemiCycle); % Calculation of Ksi
        Result_table{i} = DeltaK(Result_table{i},i,Nb_Cycle22,Nb_Sequence); % Calculation of DK_eff and DKsi

    end


 end