%This function aim to clean the table created by Open_Excel, to do so we
%wants to delete all the row before the offset zero of the test.
function [T] = Clean_Table(Table_Excel)
%CLEAN_TABLE undefined
%   undefined
arguments (Input)
    Table_Excel table
end

arguments (Output)
    T table
end
c_disp = 2;
c_force = 3;
l = 1;
while Table_Excel{l,c_disp}<0.1 || Table_Excel{l,c_force}<0
    l=l+1;
end
T = Table_Excel(l:end, :);
end
