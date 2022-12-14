function [result, M] = BER_FSO_AMR1(SNR_av1, C_0)
SNR_av = 10^(SNR_av1/10);

lambda = 1550*10^-9; 
k = 2*pi/lambda;
hv = 1.5; % m - height of vehicle
H = 600*10^3; % m
phi1 = 55*pi/4;

[alpha, beta] = alpha_beta(k, hv, H, phi1, C_0);
Pf = FSO_CSS_prob_AMR(SNR_av1, C_0);
% Pf(length(Pf)) = 1;
state_thres = zeros(5,1);

for i =1:1:5
    state_thres(i) = SNR_FSO_AMR1(10^(i/10));
end

M = length(state_thres);
% state_thres = SNR_FSO(lamda, hv, H, t_av, SNR_av, phi1, C_0);
N = length(state_thres)-1;
result = zeros(1,N);

% tmp = (erfc(sqrt((3*SNR_FSO)/(2*(N-1)*(2*N-1)))));
% BER_FSO =  ( ((N-1).*(erfc(sqrt((3.*x)./(2.*(N-1).*(2.*N-1))))))./(N.*log2(N)) );

% 
C_besselk = ((alpha*beta)^((alpha+beta)/2))/(gamma(alpha)*gamma(beta)*(SNR_av)^(((alpha+beta)/4)));
% fun =@(x)C_besselk.*(x.^(((alpha+beta)/4)-1).*besselk((alpha-beta),2.*sqrt(alpha.*beta.*sqrt(x./SNR_av)))).*0.2.*exp(-3.*x./2);
% fun =@(x)C_besselk.*(x.^(((alpha+beta)/4)-1).*besselk((alpha-beta),2.*sqrt(alpha.*beta.*sqrt(x./SNR_av)))).*( (((2^i)-1).*(erfc(sqrt((3.*x)./(2.*((2^i)-1).*(2.*(2^i)-1))))))./((2^i).*log2((2^i))) );

for i =1:1:N
   
    fun =@(x)C_besselk.*(x.^(((alpha+beta)/4)-1).*besselk((alpha-beta),2.*sqrt(alpha.*beta.*sqrt(x./SNR_av)))).*(1 - (1-( (((2^i)-1).*(erfc(sqrt((3.*x)./(2.*((2^i)-1).*(2.*(2^i)-1))))))./((2^i).*log2((2^i))) )).^1080);

    core = integral(fun, 10^(state_thres(i)/10) ,10^(state_thres(i+1)/10));
    result(i) = (1/Pf(i))*core;
%     if result(i) >1
%         result(i) =1;
%     end 
end

end

% function [result, M] = FSO_BER_av(lamda, hv, H, t_av, SNR_av1, phi1, C_0)
% % Z = 2; %BPSK 
% 
% SNR_av = 10^(SNR_av1/10);
% % 
% lambda = 1550*10^-9; 
% k = 2*pi/lambda;
% % 
% [alpha, beta] = alpha_beta(k, hv, H, phi1, C_0);
% state_thres = SNR_FSO(lamda, hv, H, t_av, SNR_av1, phi1, C_0);
% Pf = FSO_CSS_prob(lamda, hv, H, t_av, SNR_av1, phi1, C_0);
% 
% N = length(state_thres)-1;
% M = N;
% result = zeros(1,N);
% 
% C_besselk = ((alpha*beta)^((alpha+beta)/2))/(gamma(alpha)*gamma(beta)*(SNR_av)^(((alpha+beta)/4)));
% fun =@(x)C_besselk.*(x.^(((alpha+beta)/4)-1).*besselk((alpha-beta),2.*sqrt(alpha.*beta.*sqrt(x./SNR_av)))).*0.2.*exp(-3.*x./2);
% 
% for i =1:1:N
%     core = integral(fun, 10^(state_thres(i)/10) ,10^(state_thres(i+1)/10));
%     result(i) = (1/Pf(i)) * core;
%     if result(i) >1
%         result(i) =1;
%     end 
%     
% end