% This function open the Excel file and write as an arguments write a table
% with all the important result of the file
function [T] = Open_Excel(filePath,NameVariable)

arguments (Input)
    filePath string % Name of the Excel File
    NameVariable string % Name of the variable i need to take from the Excel file
end

arguments (Output)
    T table % The table as a result, ready to be put in Clean_Table function
end

% Specify the subset of variables to import by modifying the import options object. Then, import the subset of data using readtable with the import options object.
opts = detectImportOptions(filePath,'Sheet','DAQ- Running Time, … - (Timed)','VariableNamesRange', 'A7','DataRange', 'A10');
opts.SelectedVariableNames = NameVariable; % Dico with all the caracteristic of my excel files, SelectedVariableNames is the key for the name of the column

T = readtable(filePath,opts,'Sheet','DAQ- Running Time, … - (Timed)'); % We ensure that we are reading the sheet where there is the data and not the sheet with the curve
end
