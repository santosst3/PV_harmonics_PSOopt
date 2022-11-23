t_sim = 1.5;
t_id = 0.1;
t_iq = 0.1;

Vg = [1 5 7 11 13 17 19; % harmônico
    127* [100 3.94 3.15 2.36 1.5 1.1 0.7]/100; % amplitude
    0 0.7 1.25 0.8 4 0.6 5.1]; % fase

wg = 2*pi*60;

Vcc = 500;

fs = 1.2e4;
Ts = 1/fs;

% Rg = 100e-3;
% Lg = 15e-3;
Rg = 920e-3; % 5.5*167
Lg = 22e-3; % 5.5*4
% Rg = 3/5;
% Lg = 4/5/wg;

igmax = 10;

id_ref = 3;
iq_ref = 0;


% Simulação

% Variáveis que controlam simulação:
%
% LOCAIS:
% casosim -> roda caso único (1) ou conjunto de simulações (2)
%
% NA SIMULAÇÃO:
% ganhoruido -> ganho na potencia do ruido
% tipo_filtro -> Filtragem de tensão e corrente
%                   1 - Vg medido + Ig filtrado 1200Hz em dq
%                   2 - Vg + Ig filtrado 1200Hz em dq
%                   3 - Vg filtrado do PLL + Ig filtrado 1200Hz em dq
%                   4 - Vg + Ig filtrado repetitivo em dq
%                   5 - Vg + Ig filtrado repetitivo em alfa-beta
%                   6 - Vg filtrado repetitivo em alfa-beta + Ig filtrado 1200Hz em dq
%                   7 - Vg filtrado repetitivo em alfa-beta + Ig medido
%                   ot - Vg medido + Ig medido
%        - A priori, usar 2, 6 e ot
% tipo_rejharm -> Tipo de rejeição de harmônico e controle
%                   1 - ISMC convencional
%                   2 - ISMC repetitivo
%                   3 - ISMC convencional + exclusao de acoplamento
%                   4 - ISMC repetitivo + exclusao de acoplamento
%                   ot - ISMC convencional
%        - A priori, usar 1 e 2

ganhoruido = 5;
tipo_filtro = 6;
tipo_rejharm = 2;