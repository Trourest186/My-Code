function [result,N1] = BER_RF_AMR1(SNR_avf, C_0)
SNR_av =15; % Using for RF thres
m = 1.5;
% fd = 50*10^3;

% lambda = 1550*10^-9; 
% k = 2*pi/lambda;
% hv = 1.5; % m - height of vehicle
% H = 600*10^3; % m
% phi1 = pi/4;
% fd = 50*10^3;
% SNR_thres = SNR_FSO_AMR1(10^(2/10));
state_thres = zeros(5,1);

for i =1:1:5
    state_thres(i) = SNR_RF_AMR1(10^(i/10));
end
N1 = length(state_thres);

N = length(state_thres)-1;
result = zeros(1,N);
% state_thres = SNR_RF(m, fd, t_av, SNR_avf, SNR_thres, phi, C_0);
% BER_RF = ( 0.2.*exp((-3.*SNR_RF)./(2.*(M-1))) );
Pr = RF_CSS_prob_AMR(SNR_avf, C_0);

SNR_av1 = 10^(SNR_av/10);
% func = @(x) ((m^m.*x.^(m-1))./(SNR_av1^m*gamma(m))).*exp(-m.*x./SNR_av1).*( 0.2.*exp((-3.*SNR_RF)./(2.*(M-1))) );
for i =1:1:N
    
    func = @(x) ((m^m.*x.^(m-1))./(SNR_av1^m*gamma(m))).*exp(-m.*x./SNR_av1).*(1 - (1-( 0.2.*exp((-3.*x)./(2.*((2^i)-1))) ) ).^1080);

    core = integral(func, 10^(state_thres(i)/10) ,10^(state_thres(i+1)/10));
    result(i) =  (1/Pr(i))*core;
%     if result(i) >1
%         result(i) =1;
%     end
end
end

% function [result, N] = RF_BER_av(m, fd, t_av, SNR_avf, SNR_thres, phi, C_0)
% SNR_av =15;
% % SNR_avt = 10^(SNR_av/10);
% % dB
% % SNR_av = 10^(SNR_av_dB/10);
% % SNR_thres = 10^(SNR_thres_dB/10);
% 
% state_thres = SNR_RF(m, fd, t_av, SNR_avf, SNR_thres, phi, C_0);
% N = length(state_thres)-1;
% result = zeros(1,N);
% Pr = RF_CSS_prob(m, fd, t_av, SNR_avf, SNR_thres, phi, C_0);
% 
% SNR_av1 = 10^(SNR_av/10);
% % 
% func = @(x) ((m^m.*x.^(m-1))./(SNR_av1^m*gamma(m))).*exp(-m.*x./SNR_av1).*0.2.*exp(-3.*x/2);
% for i =1:1:N
%     core = integral(func, 10^(state_thres(i)/10) ,10^(state_thres(i+1)/10));
%     result(i) = (1/Pr(i)) * core;
%     if result(i) >1
%         result(i) =1;
%     end
% end
% % for i=1:1:N
% %     bn = (1.5/SNR_avt) + 1.5;
% %     tmp = (upper_incomplete_gamma(m, bn*10^(state_thres(i)/10)))/(bn^1.5) -(upper_incomplete_gamma(m, bn*10^(state_thres(i+1)/10)))/(bn^1.5) ;
% %     result(i) = (0.2*(m^m)*tmp)/(Pr(i)*gamma(m)*(SNR_avt)^m);
% % %     if result(i) >1
% % %         result(i) =1;
% % %     end
% % end
% end
