function [saida] = func_satlin_ismc(entrada,inclinacao)

%          ^
%        1 |     -----
%          |   /
%   -1/k   | /
% ---------/------------->
%        / |    1/k
%      /   | 
%  ---     | -1
%

saida = inclinacao * entrada;

if abs(saida) > 1
    saida = sign(entrada);
end