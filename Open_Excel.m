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

% Lecture of the Excel file :
% remark : I made sure that the following line: 7 for the title, 10 for the beginning of the data value, are the same for each files (which wasn't the case for P1 EN riel.xlsx)
opts = detectImportOptions(filePath,'Sheet','DAQ- Running Time, … - (Timed)','VariableNamesRange', 'A7','DataRange', 'A10'); % We retrieve all the information of the sheet
opts.SelectedVariableNames = NameVariable; % From this information we get the column corresponding to the headline in NameVariable
T = readtable(filePath,opts,'Sheet','DAQ- Running Time, … - (Timed)'); % We ensure that we are reading the sheet where there is the data and not the sheet with the curve

% Lecture of the cell corresponding to the play : 
% remark : I made sure that it was always on the Q12 cell, and that it was always written with a '.' and not a ',' for it to be considered a double by matlab (didn't work)
G = readmatrix(filePath, 'Sheet', 'DAQ- Running Time, … - (Timed)', 'Range', 'Q12:Q12'); 
end
