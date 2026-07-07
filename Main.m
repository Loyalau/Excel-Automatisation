% for i = 1 : 21
%     filename = sprintf("C:\\Users\\sonia\\OneDrive\\Bureau\\Aurélien\\Stage\\Stage 2A Trento LPMS\\Xcel\\P%d EN riel.xlsx", i);
%     Table_Excel = Open_Excel(filename,["RunningTime","Dislacement","Force_1"]); %There is a typo on the "displacement column" as it read "dislacement" instead of displacement
%     TP{i} = Clean_Table(Table_Excel);
% 
%     Ciclo{i} = Cicli(TP{i});
% end
% 
% Table_Excel = Open_Excel("C:\Users\sonia\OneDrive\Bureau\Aurélien\Stage\Stage 2A Trento LPMS\Xcel\P22 NTC riel.xlsx",["RunningTime","Dislacement","Force_1"]); %There is a typo on the "displacement column" as it read "dislacement" instead of displacement
% TP{22} = Clean_Table(Table_Excel);
% 
% Ciclo{22} = Cicli_bis(TP{22});
% 
