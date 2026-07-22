%% Initialization of the variable :
Number_test_EN = input('Enter the number of test realized in the EN 15129 procedure  : '); % Number of test realized in the EN 15129 procedure

G_EN = table(Size=[Number_test_EN 1], VariableTypes="double", VariableNames="Play_[mm]"); % Table that will receive later all the play (Gioco in italian) of all the test
for i = 1 : Number_test_EN
    G_EN{i, 1} = input(sprintf('Enter the measured Play for the test number %d : ', i));
end 
Nb_Cycle_EN = [10]; % Here is the number of cycle for the EN 15129 procedure (the first 2 sequences of 5 cycles aren't used for the following calculation

Data_Table = cell(1, Number_test_EN);  % Table on which we will place the data from the txt
Result_struct = struct(); % This is the end goal of this program, a structure with a table for each test with all the result (data and calculation)
Result_table = cell(1,Number_test_EN); % This is the sub-table corresponding of each test that will be put in the structure at the end
Nb_SemiCycle = 2* Nb_Cycle_EN;

ref_EN = input('Enter the expected absolute value of the pic of the cycle (in mm): '); % Reference absolute value of the max/min that we are searching for

% Main program :
    %% Lecture of the folders (according to the way it was done on the 2024_Connessione HPC_Hilti Schaan e Giongo // Creation and filling of the final Result_table :

% lecture of the folders
main_folder = 'C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Tests'; % Path to the main folder (that contain all the txt of the test, don't forget to double the '\' in the path)
content_folder = dir(main_folder); % Correspond to the action of opening the folder and to take everything from it
EN_sub_folder = content_folder([content_folder.isdir] & contains({content_folder.name}, 'EN')); % We only keep the sub_folder related to the EN 15129 procedure, this line remove non-directories and files (that don't contain 'EN' in the name)

for i = 1 : Number_test_EN

    TestName = strrep(EN_sub_folder(i).name,'-','_'); % transform '-' into '_'
    TestName = strrep(TestName, ' ', '_'); % transform ' ' into '_'

    File = [main_folder '\' EN_sub_folder(i).name '\' 'DAQ- Running Time, … - (Timed).txt']; % Data file in txt (can be '\DAQ-Tempo; … - (Temporizzato)_new.txt' in your case I don't know)
    new_filename = [main_folder '\' EN_sub_folder(i).name 'DAQ- Running Time, … - (Timed)_new.txt']; % Create a temporary new file to copy the corrected data in 

    S = fileread(File); % read the data file
    S = regexprep(S, ',', '.', 'lineanchors' ); % change all the ',' into '.' (this isn't a problem in our actual data file but still)

    fid = fopen(new_filename, 'w'); % open in writing configuration the new file
    fwrite(fid, S); % write the corrected info of the old file into the new one

    Result_struct.(TestName)(1).Test=EN_sub_folder(i).name; % put the name of the test in the "test" element of the structure
    Result_struct.(TestName)(1).Data=readmatrix(new_filename, 'Range', '9:1000000000'); % put the data in the "data" element of the structure

    fclose 'all'; % close all the file
    %save 'G:\Drive condivisi\DICAM - LPMS\Prove\Prove commerciali\2024_Connessione HPC_Hilti Schaan e Giongo\Prove\2026_Test overturning\Analisi dati\DataCyc.mat' Data -mat
    
    Result_struct.(TestName)(1).Gioco = G_EN{i, 1}; % put the play in the "gioco" element of the structure



% creation/filling of the result table

    Data_Table{i} = array2table(Result_struct.(TestName)(1).Data); % Result_struct.(TestName)(1).Data is an array right now so to call the function clean table we need it to be a table
    
    Result_struct.(TestName)(1).Data = Clean_Table(Data_Table{i}); % Clean the data from the first value 

    Result_table{i} = Cycle_format( Result_struct.(TestName)(1).Data,Nb_Cycle_EN,ref_EN); % Filling of the first 6 column (Semi Cycle, Running time, Displacement, Force, Energy of each semi cycle and Energy of a Cycle)
    Result_table{i} = d_eff(Result_table{i},G_EN{i, 1},Nb_SemiCycle); % Calculation of the column d_eff
    Result_table{i} = K_eff(Result_table{i}); % Calculation of K_eff
    Result_table{i} = Ksi(Result_table{i},Nb_SemiCycle); % Calculation of Ksi
    Result_table{i} = DeltaK(Result_table{i},Nb_Cycle_EN); % Calculation of DK_eff and DKsi

    Result_struct.(TestName)(1).Results =  Result_table{i}; % put the table of all result in the "Results" element of the structure
end

clear main_folder new_filename EN_sub_folder Result_table File content_folder S ans fid i ref_EN TestName

%% Plot of the graphs : 
PlotsFolder = 'C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Tests\\Plot';

% Parametri del filtro:
% N = ordine del polinomio (più è alto, più protegge i picchi)
% F = lunghezza della finestra (deve essere un numero DISPARI)

N = 3; 
F = 5; % Una finestra stretta per non spalmare i picchi di 2-3 campioni

for i = 1 : Number_test_EN
    
    Force = table2array(Data_Table{i}(:,4))*0.001;
    Disp = table2array(Data_Table{i}(:,3));
    Time = table2array(Data_Table{i}(:,2));
    % apply a filter on the Force to get rid of measurement noise
    ForceFilt = sgolayfilt(Force, N, F);
    
    % First figure X axis : Time Y axis Displacement and Force
    figure
    p1 = plot(Time,Disp,Time,ForceFilt);
    hold on;
    grid on;
    % ax.Box = 'off'; % In case you need to get rid of the outer box 
    
    % Limits of the grid
    xlim([0 round(max(Time))*1.1]);
    ylim([-300 300]);
    
    % Label, Legend and title
    xl1 = xlabel('Tempo [s]');
    yl1 = ylabel('Spostamento [mm] Carico [kN]');
    Title_graph = sprintf('Storia di spostamento e carico applicata prove n°%d', i );
    title(Title_graph);
    legend({'Spostamento','Carico'},'Location','southwest');
    legend('boxoff');

    % Positioning of the x label
    xl1.Position = [475, -25];            
    
    hold off
    saveas(gcf, [PlotsFolder '\' Title_graph '.png'])

    % Second figure (hysteresis) X axis : Displacement Y axis Force
    figure
    p2 = plot(Disp,ForceFilt);
    hold on;
    grid on;
    
    % Position the Y axis in the grid at the origin
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    % ax.Box = 'off';
    
    % Limits of the grid
    xlim([-ceil(max(Disp)/10)*10 ceil(max(Disp)/10)*10])
    ylim([-round(max(Force)*1.2) round(max(Force)*1.2)])
    
    % Label, and title
    xl2 = xlabel('Spostamento [mm]');
    yl2 = ylabel('Carico [kN]');
    Title_graph = sprintf('Diagramma isteretico prove n°%d', i);
    title(Title_graph);
    
    % Positioning of the x and y label + rotation of the y label so that it can be read vertically
    xl2.Position = [65, -50];           
    yl2.Position = [-15, 250];
    yl2.Rotation = 90;

    hold off
    saveas(gcf, [PlotsFolder '\' Title_graph '.png'])
end

clear Disp Force Time Data_Table F N ForceFilt i p1 p2 xl1 xl2 yl1 yl2 ax

%% Writing in the doc 
import mlreportgen.dom.*

Certificato_Name = 'C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Tests\\LPMS 288-2026_test.docx' ; % Need to be changed with the actual folder where it will be stored but for now
Sorted_Names = Sort_struct(Result_struct);
%Sub_title = cell(1, Number_test_EN);  % Table on which we will place the data from the txt

doc = Document(Certificato_Name, 'docx'); % open in writing configuration the Certificato needed for a Word file
open(doc); % "fopen" because fopen and fwrite don't work with Word file only with .txt

for i = 1 :  numel(Sorted_Names)
    title = char(Sorted_Names{i, 1});
    title = strrep(title, "'", "");  % sscanf don't work with these caractere

    k = sscanf(title, 'EN_%d_22');
    Sub_title = sprintf('4.%d.	Risultati prova KDEP-EN15129-T%d', k,k); % We could just use 'i' but this is a precaution in the case there is a missing number in the tests names
    
    append(doc,Sub_title); % "fwrite"
    %fwrite(fid, Sub_title{i}); % write the corrected info of the old file into the new one
end

close(doc); % "fclose"
clear ans Certificato_Name i k Sorted_Name Sub_title title      



