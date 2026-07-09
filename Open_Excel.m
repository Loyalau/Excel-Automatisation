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

% Conversion of G_all in a double
% remark : readcell alone doesn't work because it return a whole part of the excel (table of size 7413x16) centered around Q12 it seems,
% and the play is the first value of this table 
%G_obo = G_all{1, 1}; % Change the table to a 1x1 cell  

% A problem that remain for every files except for the first and last one :
% Matlab extract the number of the cell as '3.7', this is nor a char nor a double
% therefore we have to turn it into double number, to do so and to ensure that every number is transformed into double the same way we transform them into string (which seems to be already the case for excel 2 to 21)
% and then we transform them into double..
% Weird but only things that seemed to work for me
%G = double(G_exc);
%G = str2double(G_string);
end
