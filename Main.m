
% G = table(Size=[22 1], VariableTypes="double", VariableNames="Play_[mm]"); % Table of all the play for each excel
% Gioco = 0;
% 
 for i = 1 : 22
%    if i ~= 22
%       filename = sprintf("C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Xcel\\P%d EN riel.xlsx", i);
%       [Table_Excel, Gioco] = Open_Excel(filename,["RunningTime","Dislacement","Force_1"]); %There is a typo on the "displacement column" as it read "dislacement" instead of displacement, doesn't matter will be corrected in Result_table
%       G{i,1} = Gioco; 
%       TP{i} = Clean_Table(Table_Excel);
%       Result_table{i} = Cicli(TP{i});
% 
%    else 
%       [Table_Excel, Gioco] = Open_Excel("C:\Users\sonia\OneDrive\Bureau\Aurélien\Stage\Stage 2A Trento LPMS\Xcel\P22 NTC riel.xlsx",["RunningTime","Dislacement","Force_1"]);
%       G{i,1} = Gioco; 
%       TP{i} = Clean_Table(Table_Excel);
%       Result_table{22} = Cicli_bis(TP{22}); %The last excel file has only 5 cycles (could make it on the same fonction with if i=!22 condition)
% 
%    end
% 
%    Result_table{i}{:,7} = Result_table{i}{:,3} + d_eff(Result_table{i},i,G); % Determination of the column d_eff
%    Result_table{i} = K_eff(Result_table{i},i); % Calculation of K_eff
%    Result_table{i} = Ksi(Result_table{i},i); % Calculation of Ksi
    Result_table{i} = Delta(Result_table{i},i); % Calculation of DK_eff and DKsi
end