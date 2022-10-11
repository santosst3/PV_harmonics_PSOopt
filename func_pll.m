function [theta_g, vdf_pll, vqf_pll, pos_pll, vdvet_pll, vqvet_pll, theta_g_real, wg_real] = func_pll(theta_g, vg_alfabeta, vdf_pll, vqf_pll, pos_pll, vdvet_pll, vqvet_pll, wg, kp_pll, Ts)

    % Conversão de alfa-beta para dq (síncrono)
    m_conv_dq = [cos(theta_g) sin(theta_g); -sin(theta_g) cos(theta_g)];
    vg_dq = m_conv_dq*vg_alfabeta;
    vg_d = vg_dq(1);
    vg_q = vg_dq(2);
    
    % Filtro MAF
    vdf_pll = vdf_pll + (vg_d - vdvet_pll(pos_pll))/length(vdvet_pll);
    vdvet_pll(pos_pll) = vg_d;
    vqf_pll = vqf_pll + (vg_q - vqvet_pll(pos_pll))/length(vqvet_pll);
    vqvet_pll(pos_pll) = vg_q;
    
    if pos_pll < length(vdvet_pll)
        pos_pll = pos_pll + 1;
    else
        pos_pll = 1;
    end

    if vdf_pll > 0.01
        e_ugq = atan2(vqf_pll,vdf_pll);
%         e_ugq = atan2(vg_q,vg_d);
    else
        e_ugq = 1.57*sign(vqf_pll); % atan = 90°
    end
    
    deltawg = kp_pll * e_ugq + wg;
    
    % Integração de wrede
    theta_g = theta_g + deltawg * Ts;
    if theta_g > pi
        theta_g = theta_g - 2*pi;
    end
    if theta_g <-pi
        theta_g = theta_g + 2*pi;
    end
    theta_g_real = theta_g + e_ugq;
    wg_real = deltawg;

end