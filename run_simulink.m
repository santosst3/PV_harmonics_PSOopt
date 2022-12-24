function run_simulink(tr_L,tr_H,ksmc,index1)

    t_sim = 1.5;
    t_id = 0.1;
    t_iq = 0.1;
    
    % vfase_rms = 127;
    vfase_rms = 110/sqrt(2);
    
    Vg = [1 5 7 11 13 17 19; % harmônico
        vfase_rms * [100 3.94 3.15 2.36 1.5 1.1 0.7]/100; % amplitude
        0 0.7 1.25 0.8 4 0.6 5.1]; % fase
    
    wg = 2*pi*60;
    
    Vcc = 300;
    
    fs = 1.8e4;
    Ts = 1/fs;
    
    % Rg = 100e-3;
    % Lg = 15e-3;
    Rg = 500e-3;
    Lg = 13.2e-3;
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
    tipo_rejharm = 1;

    % Roda simulação
    options = simset('SrcWorkspace','current');
    out = sim('simulacao.slx',[],options);

    % Trata resultados de simulação
    tempo = out.vgig.Time;
    vg_ab = out.vgig.Data(:,1);
    vg_bc = out.vgig.Data(:,2);
    vg_ca = -(vg_ab+vg_bc);
    vg_fase =  1/3 * [2 1; -1 1] * [vg_ab';vg_bc'];
    vg_fase = vg_fase';
    va = vg_fase(:,1);
    ia = out.vgig.Data(:,3);
    ib = out.vgig.Data(:,4);
    ic = -(ia+ib);
    
    % Pegando últimos 200 ms da simulação (12 ciclos)
    t_ini1 = find(tempo < out.vgig.Time(end)-0.2, 1, 'last');
    t_fim1 = length(tempo);
    
    % Porém, plota apenas 100 ms
    t_ini2 = find(tempo < out.vgig.Time(end)-0.1, 1, 'last')+2;
    t_fim2 = length(tempo);
    tempo = tempo - tempo(t_ini2);
    
    % Análise harmônica
    freq1 = 1/mean(diff(tempo));
    aux = ia(t_ini1:t_fim1,1);
    [saida,freq] = calculafft_final(aux,freq1);
    irede_harm2 = saida(13:12:end).^2;
    thd_irede = 100*sqrt(sum(irede_harm2(2:end))/irede_harm2(1));
    
    % Potencia reativa
    potQ = sqrt(3)/3*(vg_ab.*ic + vg_bc.*ia + vg_ca.*ib);
    
    % Salva thd_irede e potQ no arquivo outputs.csv
    writematrix([index1 thd_irede mean(potQ(t_ini1:t_fim1))/50 ...
        (id_ref-saida(13)*sqrt(3/2))*10]*10,'outputs.csv','WriteMode','append');
    
    % Fecha modelos do Simulink
    bdclose('all')

end
