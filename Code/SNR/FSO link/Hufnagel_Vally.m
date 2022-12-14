function y = Hufnagel_Vally( v_wind, h, C_0 )
%y = 0.00594*((v_wind/27)^2)*(((10^-5)*h)^10)*exp(-h/1000) + (2.7*10^-16)*exp(-h/1500) + C_0*exp(-h/100);
y = 0.00594*((v_wind/27)^2).*(((10^-5).*h).^10).*exp(-h./1000) + (2.7*10^-16).*exp(-h./1500) + C_0.*exp(-h./100);

end

