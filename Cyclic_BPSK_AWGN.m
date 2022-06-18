%利用循环码的编码方式，在BPSK调制后经过AWGN信道的过程
%函数功能：计算利用循环码的编码方式，在BPSK调制后经过AWGN信道误码率与信噪比的关系
%函数参数说明：data 信息流，n 码长, k 信息位长度 , d 码组数
function [C_theor_AWGN,C_BER_AWGN] =Cyclic_BPSK_AWGN(data,n,k,d)
%% 循环码信道编码
C_encData = encode(data,n,k,'cyclic/binary');            % 调用encode函数，对大量比特流进行（n,k）循环码信道编码
%% BPSK调制
C_modData = 2*C_encData-1;                               % 编码后BPSK调制
%% AWGN信道和解调译码过程
EbN0dB_min=0;
EbN0dB_max=6;
EbN0dB=EbN0dB_min:0.5:EbN0dB_max;                        % EbN0以分贝形式表示的范围取0-6
EbN0=10.^(EbN0dB/10);
len_EbN0=length(EbN0);                                   % 计算不同信噪比的种类数量
for j=1:len_EbN0                                         % 根据不同信噪比加入噪声
    sigma(j)=sqrt(1/(2*EbN0(j)));
    Noise(j,:)=randn(1, n*d)*sigma(j);
    Noise_0= reshape(Noise(j,:), d, n);
    C_reData =Noise_0 +C_modData;                         % 完成BPSK解调过程
    
    C_demod = zeros(d,n);
    C_demod(C_reData>0)=1;
    
    C_decData=decode(C_demod,n,k,'cyclic/binary');        % 完成循环码译码
    
    C_BER_AWGN(j)=sum(abs(C_decData-data),'all')/(d*k);   % 计算误码率
    
end
%% 作图
C_theor_AWGN= qfunc(sqrt(2*EbN0));
% semilogy(EbN0dB,C_theor_AWGN,EbN0dB,C_BER_AWGN,'bp-','Linewidth',2);
% axis([EbN0dB_min EbN0dB_max 10^-5 0.1]);
% xlabel('EbN0(dB)');
% ylabel('BER');
% legend('理论BER','(n,k)循环码BER');
% title('BPSK调制、不同编码方式下的BER');









