function [D] = DeltaK(D,i,Nb_Cycle,Nb_Sequence)
% This function will calculate DK_eff and DKsi of each cycle and put it in the Result_table under the right column
arguments (Input)
    D table
    i int32
    Nb_Cycle double
    Nb_Sequence int32
  
end

arguments (Output)
    D table
end

% In this function we are going to calculate Dk_eff = (K_effi -K_eff_ref)/K_eff_ref 
% The problem is that K_eff_ref is different if you are on a positive (traction) or negative (compression) semi cycle and it is different for each sequence of cycle
% Therefore here is the solution that I found (explained at the end)

a = 1; % This is the start of our 2nd for loop
b = 0; % This is the end of our 2nd for loop (will be changer later)

for i = 1 : Nb_Sequence 
    a = a + b; % Therefore a is 1 for the first for loop, 11 for the second iteration and so on
    b = b + Nb_Cycle(i)*2; % Therefore b is 10 for the first loop, 20 for the second and so on

    for k = a : b
        l = (i-1)*10; % l is the number of line I have to add at the line corresponding at the third cycle of the first sequence for each sequences
        if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle, because we use different referential for positive and negative semi cycle
            D{k,9} = 100*(D{k,8} - D{5+l,8})/D{5+l,8} ; % Calculation of DK_eff
            D{k,11} = 100*(D{k,10} - D{5+l,10})/D{5+l,10}; % Calculation of DKsi
        else
            D{k,9} = 100*(D{k,8} - D{6+l,8})/D{6+l,8} ; % DK_eff
            D{k,11} = 100*(D{k,10} - D{6+l,10})/D{6+l,10}; % DKsi
        end
        
    end
end

end
% Here is what it does in summary : 

% if i ~= 22 % First of all we check if we are on the last file 
%     for k = 1 : 10
%         if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle, because we use different referential for positive and negative semi cycle (infact it's always the 3rd cycle of each sequences)
%             D{k,9} = 100*(D{k,8} - D{5,8})/D{5,8} ;
%             D{k,11} = 100*(D{k,10} - D{5,10})/D{5,10};
%         else
%             D{k,9} = 100*(D{k,8} - D{6,8})/D{6,8} ;
%             D{k,11} = 100*(D{k,10} - D{6,10})/D{6,10};
%         end
% 
%     end
%     for k = 11 : 20
%         if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
%             D{k,9} = 100*(D{k,8} - D{15,8})/D{15,8} ;
%             D{k,11} = 100*(D{k,10} - D{15,10})/D{15,10};
%         else
%             D{k,9} = 100*(D{k,8} - D{16,8})/D{16,8} ;
%             D{k,11} = 100*(D{k,10} - D{16,10})/D{16,10};
%         end
% 
%     end
%     for k = 21 : 40
%         if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
%             D{k,9} = 100*(D{k,8} - D{25,8})/D{25,8} ;
%             D{k,11} = 100*(D{k,10} - D{25,10})/D{25,10};
%         else
%             D{k,9} = 100*(D{k,8} - D{26,8})/D{26,8} ;
%             D{k,11} = 100*(D{k,10} - D{26,10})/D{26,10};
%         end
% 
%     end
% else
%     for k = 1 : 10
%         if mod(k,2) ~= 0 % We verify if we are on a + (odd line) or - (even line) semi cycle
%             D{k,9} = 100*(D{k,8} - D{5,8})/D{5,8} ;
%             D{k,11} = 100*(D{k,10} - D{5,10})/D{5,10};
%         else
%             D{k,9} = 100*(D{k,8} - D{6,8})/D{6,8} ;
%             D{k,11} = 100*(D{k,10} - D{6,10})/D{6,10};
%         end
%     end
% end
% end