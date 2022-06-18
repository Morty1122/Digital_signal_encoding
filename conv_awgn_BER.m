function [BER_theor_AWGN,BER] = conv_awgn_BER(msg, CtLength, CdGener)
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
    sigma = sqrt(1/(2*EbN0(j)));
    noise = randn(1, n*length(msg)) * sigma;
    code_rec = code_tsm + noise;                    % 接收端接收到的信号
    
    code_dem = zeros(1, n*length(msg));             %解调
    code_dem(code_rec>0) = 1;
    
    decoded = vitdec(code_dem, trellis, tb, 'trunc', 'hard');   % 使用维特比算法解码，硬判决
    BER(j) = sum(abs(decoded - msg),'all')/(length(msg));       % 计算误码率
end

%% 作图
BER_theor_AWGN = qfunc(sqrt(2*EbN0));
% semilogy(EbN0dB, BER_theor_AWGN, EbN0dB,BER, 'bp-','Linewidth', 2);
% axis([EbN0dB_min EbN0dB_max 10^-5 0.1]);
% xlabel('EbN0(dB)');
% ylabel('BER');
% legend('理论BER','(3, 1, 3)卷积码');
% title('BPSK调制、不同编码方式下的BER');
  
