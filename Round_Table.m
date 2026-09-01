% To round a number we need to transform it into char because round a double mean that you round to the superior number BUT it will keep the same amount of number after the ',' as '0' so it is not good to look at 
% Hence the solution that is kept here is the following : 
function [Di] = Round_Table(Di)
arguments (Input)
    Di table
end

arguments (Output)
    Di table
end

% The column to round are as follows : 

% Time : Di{:,2}; 
% Disp : Di{:,3};  
% Force : Di{:,4}; 
% D_eff :  Di{:,7};
% K_eff : Di{:,8};
% DK_eff : Di{:, 9}; 
% Ksi_eff : Di{:, 10};
% DKsi_ef : Di{:, 11};

% Di(:,2) = string(num2str(Di(:,2), '%.1f'));
% Di(:,3) = string(num2str(Di(:,3), '%.2f')); % If I round to 1 decimal after the ',' d_eff is calculated as 0 
% Di(:,4) = string(num2str(Di(:,4), '%.1f'));
% Di(:,7) = string(num2str(Di(:,7), '%.1f'));
% Di(:, 8) = string(num2str(Di(:, 8), '%.2f'));
% Di(:, 9) = string(num2str(Di(:, 9), '%.2f')); % I need to round to 2 decimal for D_Keff or else it as a lot of 0 (and not 0.x)
% Di(:, 10) = string(num2str(Di(:, 10), '%.2f'));
% Di(:, 11) = string(num2str(Di(:, 11), '%.2f')); 

% On extrait la donnée brute avec {}, on la formate avec compose, 
% et on re-stocke le résultat sous forme de string dans la table.

% Convertit les colonnes numériques pures en vecteurs STRING
    Di.("T [s]")          = compose("%.1f", Di.("T [s]"));
    Di.("d [mm]") = compose("%.2f", Di.("d [mm]"));
    Di.("F [kN]")        = compose("%.1f", Di.("F [kN]"));
    Di.("E [J]")           = compose("%.0f", Di.("E [J]"));
    Di.("E_Cycle [J]")     = compose("%.0f", Di.("E_Cycle [J]"));
    Di.("d_eff [mm]")        = compose("%.1f", Di.("d_eff [mm]"));
    Di.("K_eff [kN/mm]")     = compose("%.2f", Di.("K_eff [kN/mm]"));
    Di.("ΔK_eff [%]")        = compose("%.2f", Di.("ΔK_eff [%]"));
    Di.("Ⲝ_eff [%]")       = compose("%.2f", Di.("Ⲝ_eff [%]"));
    Di.("ΔⲜ_eff [%]")      = compose("%.2f", Di.("ΔⲜ_eff [%]"));
end