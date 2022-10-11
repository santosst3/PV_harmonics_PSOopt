function [P1,f] = calculafft_final(entrada,Fs)
    
L = length(entrada);  % Length of signal
if mod(L,2)
    entrada = entrada(1:end-1);
    L=L-1;
end

Y = fft(entrada);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;