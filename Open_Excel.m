%This function open the Excel file and write as an arguments write a table
%with all the important result of the file
function [T] = Open_Excel(filePath,NameVariable)
%OPEN_EXCEL undefined
%   undefined
arguments (Input)
    filePath string %Name of the Excel File
    NameVariable string %Name of the variable i need to take from the Excel file
end

arguments (Output)
    T table %The table as a result, ready to be put in Clean_Table function
end

%Sert à configurer comment readtable va interpreter mon doc
%Specify the subset of variables to import by modifying the import options object. Then, import the subset of data using readtable with the import options object.
opts = detectImportOptions(filePath,'Sheet','DAQ- Running Time, … - (Timed)','VariableNamesRange', 'A7','DataRange', 'A10');
%opts.VariableNamesRange = "A7";   % ligne où sont tes vrais noms de colonnes
%opts.DataRange = "A10";            % ligne où commencent tes données numériques
opts.SelectedVariableNames = NameVariable; %c'est un dico en gros opts ça prend tout les caractéristiques du fichier excel et tu peux les ressortirs comme ça (dans l'exemple ça te sors les selected variable name)

T = readtable(filePath,opts,'Sheet','DAQ- Running Time, … - (Timed)');
end
