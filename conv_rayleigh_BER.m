function [BER_theor_Rayleigh,BER] = conv_rayleigh_BER(msg, CtLength, CdGener)
%% 卷积码编码
% [CtLength, CdGener]的推荐取值有[[3], [7 4 6]](3,1,2), [[3], [7 5]](2,1,2),
% [[5], [23 35]](2,1,4)等
msg = reshape(msg, 1, []);
n = size(CdGener, 2);                               % n为每次输出字长
trellis = poly2trellis(CtLength, CdGener);          % 卷积码编码器结构
code = convenc(msg, trellis);                       % 编码

%% BPSK调制
code_tsm = 2*code-1;                                % 发射端发射的信号

%% 信息通过AWGN信道、解调、解码、计算信噪比
EbN0dB_min = 0;
EbN0dB_max = 6;
EbN0dB = EbN0dB_min:0.5:EbN0dB_max;                 % EbN0以分贝形式表示的范围取0-6
EbN0 = 10.^(EbN0dB/10);
len_EbN0 = length(EbN0);
BER = zeros(1, len_EbN0);
tb = 25;                                            % 解码回溯深度

for j = 1:len_EbN0                                  % 根据不同信噪比加入噪声
    h = 1/sqrt(2) .* (randn(1, n*length(msg)) + 1i.*randn(1,n*length(msg)));
    sigma = sqrt(1/(2*EbN0(j)));
    noise = sigma * (randn(1, n*length(msg)) + 1i*randn(1, n*length(msg)));
    code_rec = h .* code_tsm + noise;
    
    code_rec = code_rec ./ h;
    code_dem = real(code_rec) > 0;
    
    decoded = vitdec(code_dem, trellis, tb, 'trunc', 'hard');   % 使用维特比算法解码，硬判决
    BER(j) = sum(abs(decoded - msg),'all')/(length(msg));       % 计算误码率
end

%% 作图
BER_theor_Rayleigh = 0.5*(1-sqrt(EbN0./(1+EbN0)));
% semilogy(EbN0dB, BER_theor_Rayleigh, EbN0dB,BER, 'bp-','Linewidth', 2);
% axis([EbN0dB_min EbN0dB_max 10^-5 1]);
% xlabel('EbN0(dB)');
% ylabel('BER');
% legend('理论BER','卷积码');
% title('BPSK调制、不同编码方式下的BER');
