% The goal of this function is to sort the table/test in the structure in numerical order since matlab sort them in alphabetical order, this will not change how they are seen on matlab but it will change how the program look at it
function [sorted_Test_names] = Sort_struct(S)

arguments (Input)
    S struct
end

arguments (Output)
    sorted_Test_names table
end
    
Test_names = fieldnames(S);
nums = zeros(size(Test_names));

for k = 1 : numel(Test_names) % for each elements (name) in Test_names
    nums(k) = sscanf(Test_names{k}, 'EN_%d_22');   % Take the number of the test (the format of the names are EN_n°test_22
end
[~, order] = sort(nums); % Create a table with the id sorted of the structure (the value aren't necessary so they are ignored by '~'

sorted_Test_names = Test_names(order); % The table sorted_Test_names has all the name of the structure sorted by numerical order

end
