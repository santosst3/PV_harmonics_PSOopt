function vabc = func_svpwm(vabc_in, tiposvpwm)
    switch tiposvpwm
        case 1
            VA = vabc_in(1);
    	    VB = vabc_in(2);
    	    VC = vabc_in(3);
            if (VA>VB && VA>VC)
                Vmax = VA;
            elseif (VB>VC && VB>VA)
                Vmax = VB;
            else
                Vmax = VC;
            end
            if (VA<VB && VA<VC)
                Vmin = VA;
            elseif (VB<VC && VB<VA)
                Vmin = VB;
            else
                Vmin = VC;
            end
    	    triang = -(Vmax + Vmin)*0.5;
    	    vabc(1) =((VA   + triang)*sqrt(3)/3 + 0.5);
    	    vabc(2) =((VB   + triang)*sqrt(3)/3 + 0.5);
    	    vabc(3) =((VC   + triang)*sqrt(3)/3 + 0.5);
        otherwise
            vabc = (vabc_in + 1) / 2;
    end
end