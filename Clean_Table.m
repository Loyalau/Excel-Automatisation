% This function aim to clean the table created by Open_Excel, to do so we wants to delete all the row before the offset zero of the test.
function [T] = Clean_Table(Table_Excel)

arguments (Input)
    Table_Excel table
end

arguments (Output)
    T table
end

% Take less time to work with array instead of directly looking into the table Table_Excel :
% That's why we transform the column of the table into array in each function

c_disp = Table_Excel{:,2};
c_force = Table_Excel{:,3};
l = 1;

while c_disp(l)<0.1 || c_force(l)<0 % We consider the offset of the file the time where the displacement is reaching 0.1mm, we also need to ensure that the forces are positive
    l=l+1;
end

T = Table_Excel(l:end, :); % Slice of the table, we keep all the thing after our selected "0"

end
