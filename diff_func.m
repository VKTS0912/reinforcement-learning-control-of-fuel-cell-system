
function res = diff_func(I_fc,T,lambda,D,R_L)
% Parameters
N = 24;
A = 232;
m1 = 0.944;
m2 = -0.00354; 
m3 = -7.8*10^-8;
m4 = 1.96*10^-4;
n = 2;
iL = 2; 
R = 83144.7; 
F = 96484600;

PH2 = 2;
PO2 = 2;
CO2 = PO2/((5.08*10^6)*exp(-498/T));
E = 1.229-8.5*(10^-4)*(T-298.15)+4.308*(10^-5)*T*(log(PH2)+log(PO2));
tm = 175*10^-4;
if T < 171
    rm = (181.6*(1+0.03*(I_fc/A)+0.0062*((T/303)^2)*(I_fc.^2.5/A^2.5)))/((lambda-0.634-3*I_fc/A)*exp(4.18*(T-303/T))); 
else 
    rm = 0;
end
Rm = rm*tm/A;
Vact = m1+m2*T+m3*T*log(CO2)+m4*T*log(I_fc);
Vohmic = I_fc*Rm;
Vcon = (-R*T/(n*F))*log(1-I_fc/(iL*A));
Vcell = E - Vact - Vcon - Vohmic;
V_fc = N*Vcell;

% C = 7000*10^-6; 
% L = 29*10^-3;
% R1 = 50;

res = - V_fc/(R_L*((1-D)*(1-D))) + I_fc;
end
