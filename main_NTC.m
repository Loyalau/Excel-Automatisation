%% Initialization of the variable :
Number_test_NTC = input('Enter the number of test realized in the NTC18 procedure  : '); % Number of test realized in the NTC18 procedure

G_NTC = table(Size=[Number_test_NTC 1], VariableTypes="double", VariableNames="Play_[mm]"); % Table that will receive later all the play (Gioco in italian) of all the test
for i = 1 : Number_test_NTC
    G_NTC{i, 1} = input(sprintf('Enter the measured Play for the test number %d : ', i));
end 
Nb_Cycle_NTC = [5]; % Here is the number of cycle for the NTC18 procedure

Data_Table = cell(1, Number_test_NTC); % Table on which we will place the data from the txt
Result_struct = struct(); % This is the end goal of this program, a structure with a table for each test with all the result (data and calculation)
Result_table = cell(1,Number_test_NTC); % This is the sub-table corresponding of each test that will be put in the structure at the end
Nb_SemiCycle = 2* Nb_Cycle_NTC;

ref_NTC = input('Enter the expected absolute value of the pic of the cycle (in mm): '); % Reference absolute value of the max/min that we are searching for

% Main program :
    %% Lecture of the folders (according to the way it was done on the 2024_Connessione HPC_Hilti Schaan e Giongo /  Creation and filling of the final Result_table :

% lecture of the folders
main_folder = 'C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Tests'; % Path to the main folder (that contain all the txt of the test, don't forget to double the '\' in the path)
content_folder = dir(main_folder); % Correspond to the action of opening the folder and to take everything from it
NTC_sub_folder = content_folder([content_folder.isdir] & contains({content_folder.name}, 'NTC')); % We only keep the sub_folder related to the NTC18 procedure, this line remove non-directories and files (that don't contain 'EN' in the name)

TestName = cell(1, Number_test_NTC);
for i = 1 : Number_test_NTC

    TestName{i} = strrep(NTC_sub_folder(i).name,'-','_'); % transform '-' into '_'
    TestName{i} = strrep(TestName{i}, ' ', '_'); % transform ' ' into '_'

    File = [main_folder '\' NTC_sub_folder(i).name '\' 'DAQ- Running Time, … - (Timed).txt']; % Data file in txt (can be '\DAQ-Tempo; … - (Temporizzato)_new.txt' in your case I don't know)
    new_filename = [main_folder '\' NTC_sub_folder(i).name 'DAQ- Running Time, … - (Timed)_new.txt']; % Create a temporary new file to copy the corrected data in 

    S = fileread(File); % read the data file
    S = regexprep(S, ',', '.', 'lineanchors' ); % change all the ',' into '.' (this isn't a problem in our actual data file but still)

    fid = fopen(new_filename, 'w'); % open in writing configuration the new file
    fwrite(fid, S); % write the corrected info of the old file into the new one

    Result_struct.(TestName{i})(1).Test=NTC_sub_folder(i).name; % put the name of the test in the "test" category of the structure
    Result_struct.(TestName{i})(1).Data=readmatrix(new_filename, 'Range', '9:1000000000'); % put the data in the "data" category of the structure

    fclose 'all'; % close all the file
    %save 'G:\Drive condivisi\DICAM - LPMS\Prove\Prove commerciali\2024_Connessione HPC_Hilti Schaan e Giongo\Prove\2026_Test overturning\Analisi dati\DataCyc.mat' Data -mat

    Result_struct.(TestName{i})(1).Gioco = G_NTC{i, 1};



% creation/filling of the result table
    Data_Table{i} = array2table(Result_struct.(TestName{i})(1).Data); % Result_struct.(TestName)(1).Data is an array right now so to call the function clean table we need it to be a table

    Result_struct.(TestName{i})(1).Data = Clean_Table_NTC(Data_Table{i}); % Clean the data from the first value 
    
    Result_table{i} = Cycle_format( Result_struct.(TestName{i})(1).Data,Nb_Cycle_NTC,ref_NTC); % Filling of the first 6 column (Semi Cycle, Running time, Displacement, Force, Energy of each semi cycle and Energy of a Cycle)
    Result_table{i} = d_eff(Result_table{i},G_NTC{i, 1},Nb_SemiCycle); % Calculation of the column d_eff
    Result_table{i} = K_eff(Result_table{i}); % Calculation of K_eff
    Result_table{i} = Ksi(Result_table{i},Nb_SemiCycle); % Calculation of Ksi
    Result_table{i} = DeltaK_NTC(Result_table{i},Nb_Cycle_NTC); % Calculation of DK_eff and DKsi

    Result_struct.(TestName{i})(1).Results =  Result_table{i}; % put the table of all result in the "Results" element of the structure
     
end

clear main_folder new_filename NTC_sub_folder Result_table File content_folder S ans fid i ref_NTC

%% Plot of the graphs :
PlotsFolder = 'C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Tests\\Plot';
Title_graph1 = cell(1, Number_test_NTC);
Title_graph2 = cell(1, Number_test_NTC);
% Parametri del filtro:
% N = ordine del polinomio (più è alto, più protegge i picchi)
% F = lunghezza della finestra (deve essere un numero DISPARI)

N = 3; 
F = 5; % Una finestra stretta per non spalmare i picchi di 2-3 campioni

for i = 1 : Number_test_NTC
    
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
    Title_graph1{i} = sprintf('Storia di spostamento e carico applicata prove n°%d', i );
    % title(Title_graph1{i});
    legend({'Spostamento','Carico'},'Location','southwest');
    legend('boxoff');

    % Positioning of the x label
    xl1.Position = [225, -25];            
    
    hold off
    saveas(gcf, [PlotsFolder '\' Title_graph1{i} '.png'])

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
    Title_graph2{i} = sprintf('Diagramma isteretico prove n°%d', i);
    % title(Title_graph2{i});
    
    % Positioning of the x and y label + rotation of the y label so that it can be read vertically
    xl2.Position = [50, -50];           
    yl2.Position = [-15, 215];
    yl2.Rotation = 90;

    hold off
    saveas(gcf, [PlotsFolder '\' Title_graph2{i} '.png'])
end

clear Disp Force Time Data_Table F N ForceFilt i p1 p2 xl1 xl2 yl1 yl2 ax

%% Writing in the doc 
import mlreportgen.dom.*

Certificato_Name = 'C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Tests\\LPMS 288-2026_test.docx' ; % Need to be changed with the actual folder where it will be stored but for now
Sorted_Names = Sort_struct(Result_struct,TestName);
%Sub_title = cell(1, Number_test_EN);  % Table on which we will place the data from the txt

doc = Document(Certificato_Name, 'docx'); % open in writing configuration the Certificato needed for a Word file
open(doc); % "fopen" because fopen and fwrite don't work with Word file only with .txt

for i = 1 :  numel(Sorted_Names)
    % 1) We write the subtitle of the test
    title = char(Sorted_Names{i, 1});
    title = strrep(title, "'", "");  % sscanf don't work with these caractere

    k = sscanf(title, 'NTC_%d_22');
    Sub_title = sprintf('4.%d.	Risultati prova KDEP-EN15129-T%d', k,k); % We could just use 'i' but this is a precaution in the case there is a missing number in the tests names

    append(doc,Sub_title); % "fwrite"

    % 2) We put the 2 graph below the subtitle 
    img1 = Image([PlotsFolder '\' Title_graph1{i} '.png']);
    % img1.Width = '10cm';   
    % img1.Height = '5cm';  
    img1.Style = {Width('13cm'),Height('8cm'),HAlign('center')};
    append(doc, img1);

    legend1 =  Paragraph('Storia di spostamento e carico applicata.');
    legend1.HAlign = 'center';
    append(doc,legend1);

    img2 = Image([PlotsFolder '\' Title_graph2{i} '.png']);
    % img2.Width = '10cm';   
    % img2.Height = '5cm';
    img2.Style = {Width('13cm'),Height('8cm'),HAlign('center')};
    append(doc, img2); 

    legend2 = Paragraph('Diagramma isteretico.');
    legend2.HAlign = 'center';
    append(doc,legend2);

    append(doc, PageBreak()); % New page on the doc

    % 3) We put the table of the result under the graph on a new page ? 

    % Table_doc = FormalTable(Result_struct.(TestName{i})(1).Results); % The table from the structure "Result_struct.(TestName{i})(1).Results" is a table in the format of matlab and we have to convert it before adding it to the doc
    % Table_doc.Style = {Width('13cm'),Height('8cm'),HAlign('center')};
    % 
    % Table_doc.Border = 'single';
    % Table_doc.BorderWidth = '1pt';

    tableStyle ={Width("100%"),Border("solid"),RowSep("solid"),ColSep("solid")};
    tableEntriesStyle = {HAlign("center"),VAlign("middle")};
    headerRowStyle ={InnerMargin("2pt","2pt","2pt","2pt"),Bold(true)};
    
    % headerContent =Result_struct.(TestName{i})(1).Results(1, :);
    % bodyContent =Result_struct.(TestName{i})(1).Results(2:end, :);

    grps(1) = TableColSpecGroup;
    grps(1).Span = 11;
    grps(1).Style = {Width("9.09%")};
    % grps(1).ColSpecs = specs;

    append(doc,Heading1("Tabella riassuntiva dei risultati della prova."));

    formalTable = FormalTable(Result_struct.(TestName{i})(1).Results);
    formalTable.ColSpecGroups = grps;

    formalTable.Style = tableStyle;
    formalTable.TableEntriesStyle = tableEntriesStyle;

    headerRow = formalTable.Header.Children;
    headerRow.Style = headerRowStyle; 

    append(doc,formalTable);

end

close(doc); % "fclose"
clear ans Certificato_Name i k Sorted_Name Sub_title title img1 img2 Title_graph1 Title_graph2     