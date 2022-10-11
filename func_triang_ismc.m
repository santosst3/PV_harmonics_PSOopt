function [saida] = func_triang_ismc(entrada,largura,altura)

%          ^
%          |
%          | H
%        / | \
%      /   |   \
%    /     |     \
% ----------------------->
%   -L     |      L
%
    
if abs(entrada) > largura
    saida = 0;
else
    saida = altura - abs(entrada)*altura/largura;
end

