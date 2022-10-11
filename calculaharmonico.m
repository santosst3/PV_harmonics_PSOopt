function y = calculaharmonico(entrada,n_harm)
N = length(entrada);
pos_entrada = [0:(N-1)]';
y = zeros(n_harm+1,1);
for k = 0 : n_harm
    y(k+1) = entrada'*exp(-1i*2*pi*k*pos_entrada/N)/N;
end
y(2:end) = 2*y(2:end); % Para corrigir o espectro espelhado
y(2:end) = y(2:end)/sqrt(2); % Definir em valor eficaz
