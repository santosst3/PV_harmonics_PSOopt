function run_simulink(in1,in2,in3)

    tr_L = in1;
    tr_H = in2;
    ksmc = in3;

    % Testes com SMC em dq, rede com harmônicos
    smc_param;

    % Roda simulação
    out = sim('simulacao.slx');

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
    writematrix([thd_irede mean(potQ(t_ini1:t_fim1))/50 ...
        (id_ref-saida(13)*sqrt(3/2))*10]*10,'outputs.csv','WriteMode','append');
    
    % Fecha modelos do Simulink
    bdclose('all')

end
