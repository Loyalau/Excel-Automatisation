% This function aim to clean the table created by Open_Excel, to do so we wants to delete all the row before the offset zero of the test.
function [T] = Clean_Table(Table_input)

arguments (Input)
    Table_input table
end

arguments (Output)
    T table
end

% Take less time to work with array instead of directly looking into the table Table_Excel :
% That's why we transform the column of the table into array in each function

c_disp = Table_input{:,3};
c_force = Table_input{:,4};
l = 1;

while c_disp(l)<0.1 || c_force(l)<0 % We consider the offset of the file the time where the displacement is reaching 0.1mm, we also need to ensure that the forces are positive
    l=l+1;
end

% The following sequence is the only solution i found to only keep from the
% table the 10 last cycle, it cost a lot of information so I will need to
% optimise it later (it's the same solution as cycle_format)

c = c_disp(l);
for i = 1:2
    for k = 1 : 5
        A = l; % The starting line of the semi cycle (to begin the calculation of the Energy used during said semi cycle)

        % We are now searching for the maximum as we know that we are on a "positive cycle" (cycle in traction I assume)
        while c < 0.1 || c < c_disp(l+1) % We are searching for the global max of this semi cycle, c < 0.1 is a security because at the start we can have local max that skip the loop
            l = l + 1;
            c =  c_disp(l);
        end 

        % We are now searching for the minimum as we know that we are on a "negative cycle" (cycle in compression I assume)
        while c > 0.1 || c > c_disp(l+1)
            l = l +1;
            c =  c_disp(l);
        end
        % We found the global min of the cycle, it's time to fill the table :
    end
end

while c_disp(l+1) < 0
    l = l +1;
end

Table_input{:,4} = Table_input{:,4} * 0.001; % To transform the N in kN

T = Table_input(l:end, 2:end); % Slice of the table, we keep all the thing after our selected "0"

end
