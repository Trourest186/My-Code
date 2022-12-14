
function  result = Pt_FSO_RF(SNR_av, SNR_thres, phi, C_0)
% SNR_av = 10^(SNR_av_dB/10);
% SNR_thres = 10^(SNR_thres_dB/10);

fd = 50*10^3;
m = 1.5;
t_av1 = 3.568e-03;
t_av = 2.3787e-05;

hv = 1.5; % m - height of vehicle
H = 300*10^3; % m
lamda = 1550*10^-9;

Rf =  1*10^9;
Rr = 150*10^6;

[BER_RF, N] = RF_BER_av(m, fd, t_av, SNR_av, SNR_thres, phi, C_0);
[BER_FSO, M] = FSO_BER_av(lamda, hv, H, t_av1, SNR_av, phi, C_0);
disp(BER_FSO);
Pf = FSO_CSS_prob(lamda, hv, H, t_av1, SNR_av, phi, C_0);
Pr = RF_CSS_prob(m, fd, t_av, SNR_av, SNR_thres, phi, C_0);

% Sum for FSO
TS_FSO = 0;                                                                         
MS_FSO = 0;
for m=1:1:M
%     disp(".....");
    tmp_TS_FSO = Rf*Pf(m)*FSO_FER_av(BER_FSO(m));
    TS_FSO = TS_FSO + (tmp_TS_FSO);
%     disp(TS_FSO);
    tmp_MS_FSO = Rf*Pf(m);
    MS_FSO = MS_FSO + (tmp_MS_FSO);
end

% Sum for RF
TS_RF = 0;
MS_RF = 0;
disp("M="); disp(M);
disp("N="); disp(N);
for n=1:1:N
    tmp_TS_RF = Rr*Pr(n)*RF_FER_av(BER_RF(n));
    TS_RF = TS_RF + (tmp_TS_RF);
    tmp_MS_RF = Rr*Pr(n);
    MS_RF =  MS_RF +  (tmp_MS_RF);
    
end
% TS_RF(isnan(TS_RF)) =0;
% TS_FSO(isnan(TS_FSO)) =0;
FER = ((TS_FSO) + TS_RF)/(MS_FSO +MS_RF);
FER(isnan(FER)) =0;
disp("FER="); disp(FER);
disp("===");
disp("TS_FSO");
disp(TS_FSO);
disp("TS_RF");
disp(TS_RF);
disp("MS_FSO");
disp(MS_FSO);
disp("MS_RF");
disp(MS_RF);
X = 2; % Fix: Nhớ nhé
nf =5;

result = 1-(1- (FER)^(X+1))^nf;
end


