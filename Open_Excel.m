% This function open the Excel file and write as an arguments write a table
% with all the important result of the file
function [T,G] = Open_Excel(filePath,NameVariable)

arguments (Input)
    filePath string % Name of the Excel File
    NameVariable string % Name of the variable i need to take from the Excel file
end

arguments (Output)
    T table % The table containing the running time, displacement and force, ready to be put in Clean_Table function
    G double % The value the play (gioco) for the calculation of d_eff
end

% Specify the subset of variables to import by modifying the import options object. Then, import the subset of data using readtable with the import options object.
opts = detectImportOptions(filePath,'Sheet','DAQ- Running Time, … - (Timed)','VariableNamesRange', 'A7','DataRange', 'A10'); % I made sure that the line match (7 for the title 10 for the value) (which wasn't the case for P1 EN riel.xlsx)
opts.SelectedVariableNames = NameVariable; % Dico with all the caracteristic of my excel files, SelectedVariableNames is the key for the name of the column

T = readtable(filePath,opts,'Sheet','DAQ- Running Time, … - (Timed)'); % We ensure that we are reading the sheet where there is the data and not the sheet with the curve

G_all = readcell(filePath, 'Sheet', 'DAQ- Running Time, … - (Timed)', 'Range', 'Q12'); % I made sure that it was always on this cell (which wasn't the case for P1 EN riel.xlsx), and that it was alwas with a '.' and not a ',' for it to be considered a double by matlab
% readcell only doesn't work because it return a whole table extract from the excel of 7413x16 so you need to extrat from it the first value that is the Q12 cell of the excel (which is the play)

G_obo = G_all{1, 1}; % G_all is still to big to be extrated to a double so you need to extract from it a 1x1 cell  

% A problem that remain for every files except for the first and last one
% is that Matlab extract the number of the space in this typo '3.7'
% therefore we have to turn it into double number, to do so and to ensure
% that every number is transformed into double the same way we transform
% them into string (wich seems to be already the case for excel 2 to 21)
% and then we transform them into double.. Weird but only things that
% seemed to work for me
G_string = string(G_obo);

G = str2double(G_string);
end
