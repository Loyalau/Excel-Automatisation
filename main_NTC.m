% Initialization of the variable :
Number_test_NTC = input('Enter the number of test realized in the NTC18 procedure  : '); % Number of test realized in the NTC18 procedure

G_NTC = table(Size=[Number_test_NTC 1], VariableTypes="double", VariableNames="Play_[mm]"); % Table that will receive later all the play (Gioco in italian) of all the test
for i = 1 : Number_test_NTC
    G_NTC{i, 1} = input(sprintf('Enter the measured Play for the test number %d : ', i));
end 
Nb_Cycle_NTC = [5]; % Here is the number of cycle for the NTC18 procedure

Result_struct = struct(); % This is the end goal of this program, a structure with a table for each test with all the result (data and calculation)
Result_table = cell(1,Number_test_NTC); % This is the sub-table corresponding of each test that will be put in the structure at the end
Nb_SemiCycle = 2* Nb_Cycle_NTC;

% Main program :

    % Lecture of the folders (according to the way it was done on the 2024_Connessione HPC_Hilti Schaan e Giongo
main_folder = 'C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Tests'; % Path to the main folder (that contain all the txt of the test, don't forget to double the '\' in the path)
content_folder = dir(main_folder); % Correspond to the action of opening the folder and to take everything from it
NTC_sub_folder = content_folder([content_folder.isdir] & contains({content_folder.name}, 'NTC')); % We only keep the sub_folder related to the NTC18 procedure, this line remove non-directories and files (that don't contain 'EN' in the name)

for i = 1 : Number_test_NTC

    TestName=strrep(NTC_sub_folder(i).name,'-','_'); % transform '-' into '_'
    TestName = strrep(TestName, ' ', '_'); % transform ' ' into '_'

    File = [main_folder '\' NTC_sub_folder(i).name '\' 'DAQ- Running Time, … - (Timed).txt']; % Data file in txt (can be '\DAQ-Tempo; … - (Temporizzato)_new.txt' in your case I don't know)
    new_filename = [main_folder '\' NTC_sub_folder(i).name 'DAQ- Running Time, … - (Timed)_new.txt']; % Create a temporary new file to copy the corrected data in 

    S = fileread(File); % read the data file
    S = regexprep(S, ',', '.', 'lineanchors' ); % change all the ',' into '.' (this isn't a problem in our actual data file but still)

    fid = fopen(new_filename, 'w'); % open in writing configuration the new file
    fwrite(fid, S); % write the corrected info of the old file into the new one

    Result_struct.(TestName)(1).Test=NTC_sub_folder(i).name; % put the name of the test in the "test" category of the structure
    Result_struct.(TestName)(1).Data=readmatrix(new_filename, 'Range', '9:1000000000'); % put the data in the "data" category of the structure

    fclose 'all'; % close all the file
    %save 'G:\Drive condivisi\DICAM - LPMS\Prove\Prove commerciali\2024_Connessione HPC_Hilti Schaan e Giongo\Prove\2026_Test overturning\Analisi dati\DataCyc.mat' Data -mat

    Result_struct.(TestName)(1).Gioco = G_NTC{i, 1};

    % Creation and filling of the final Result_table : 
    Data_Table = array2table(Result_struct.(TestName)(1).Data); % Result_struct.(TestName)(1).Data is an array right now so to call the function clean table we need it to be a table

    Result_struct.(TestName)(1).Data = Clean_Table_NTC(Data_Table); % Clean the data from the first value 
    Result_table{i} = Cycle_format( Result_struct.(TestName)(1).Data,Nb_Cycle_NTC); % Filling of the first 6 column (Semi Cycle, Running time, Displacement, Force, Energy of each semi cycle and Energy of a Cycle)
    Result_table{i} = d_eff(Result_table{i},G_NTC{i, 1},Nb_SemiCycle); % Calculation of the column d_eff
    Result_table{i} = K_eff(Result_table{i}); % Calculation of K_eff
    Result_table{i} = Ksi(Result_table{i},Nb_SemiCycle); % Calculation of Ksi
    Result_table{i} = DeltaK_NTC(Result_table{i},Nb_Cycle_NTC); % Calculation of DK_eff and DKsi

    Result_struct.(TestName)(1).Results =  Result_table{i}; % put the table of all result in the "Results" element of the structure
     
end

clear Data_Table main_folder new_filename NTC_sub_folder Result_table File content_folder S ans fid i