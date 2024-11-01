I_fc = 1:460;
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
T = 300 ;
lambda = 14;
PH2 = 2;
PO2 = 2;
CO2 = PO2/((5.08*10^6)*exp(-498/T));
if T < 171
    rm = (181.6*(1+0.03*(I_fc/A)+0.0062*((T/303)^2)*(I_fc.^2.5/A^2.5)))/((lambda-0.634-3*I_fc/A)*exp(4.18*(T-303/T))); 
else 
    rm = 0;
end
tm = 175*10^-4;
Rm = rm*tm/A;
E = 1.229-8.5*(10^-4)*(T-298.15)+4.308*(10^-5)*T*(log(PH2)+log(PO2));
Vact = m1+m2*T+m3*T*log(CO2)+m4*T*log(I_fc);
Vohmic = I_fc.*Rm;
Vcon = (-R*T/(n*F))*log(1-I_fc/(iL*A));
Vcell = E - Vact - Vohmic - Vcon;
V_fc = N*Vcell;
P_fc = V_fc.*I_fc;

    h = figure(1);
subplot(1,2,1);
yyaxis left;
ylabel('V (Volts)')
plot(I_fc,V_fc);
hold on
yyaxis right;
ylabel('P (Watt)') 
plot(I_fc,P_fc,'r--');
xlabel('I (Amperes)') 
title(['P-I V-I curve | lambda = ',num2str(lambda),' | T = ',num2str(T),' ']);

hold on
subplot(1,2,2);
% yyaxis left;
plot(V_fc,I_fc);
ylabel('I (Amperes)') 
xlabel('V (Volts)')
hold on
title('I - V curve');

fname = sprintf('q_result/charPlot_T%d_lambda%d.fig',T, lambda);
savefig(h,fname);


