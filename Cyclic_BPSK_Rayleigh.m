%利用循环码的编码方式，在BPSK调制后经过瑞利信道的过程
%函数功能：计算利用循环码的编码方式，在BPSK调制后经过瑞利信道误码率与信噪比的关系
%函数参数说明：data 信息流，n 码长, k 信息位长度 , d 码组数
function [C_theor_Rayleigh,C_BER_Rayleigh] = Cyclic_BPSK_Rayleigh(data,n,k,d)
%% （n,k)循环码信道编码                        
% data = randi([0 1],d,k);           
C_encData = encode(data,n,k,'cyclic/binary');             %调用encode函数，对大量比特流进行（n,k）循环码信道编码
%% BPSK调制
C_modData = 2*C_encData-1;                         
%% Rayleigh信道和解调译码过程
EbN0dB_min=0;
EbN0dB_max=6;
EbN0dB=EbN0dB_min:0.5:EbN0dB_max;                         % EbN0以分贝形式表示的范围取0-6
EbN0=10.^(EbN0dB/10);
len_EbN0=length(EbN0);
for j=1:len_EbN0                                          % 根据不同信噪比加入噪声
    h_0=1/sqrt(2).*(randn(1,n*d)+1i.*randn(1,n*d));       % 瑞利衰弱信道建模
    h = reshape(h_0, d, n);
    sigma(j)=sqrt(1/(2*EbN0(j)));
    noise_0 = sigma(j)*(randn(1,n*1e5)+1i*randn(1,n*d));
    noise = reshape(noise_0, d, n);
    C_reData=h.*C_modData+noise;
   
    C_reData2=C_reData./h;                                % 接收端信号完成能量归一化
    C_demod =real(C_reData2)>0;                           % 完成BPSK解调过程

    C_decData=decode(C_demod,n,k,'cyclic/binary');        % 完成循环码译码

    C_BER_Rayleigh(j)=sum(abs(C_decData-data),'all')/(d*k); % 计算误码率
end
%% 作图
C_theor_Rayleigh=0.5*(1-sqrt(EbN0./(1+EbN0)));
% semilogy(EbN0dB,C_theor_Rayleigh,EbN0dB,C_BER_Rayleigh,'bp-','Linewidth',2);
% axis([EbN0dB_min EbN0dB_max 10^-5 1]);
% xlabel('EbN0(dB)');
% ylabel('BER');
% legend('理论BER','(7,4)循环码BER');
% title('BPSK调制、不同编码方式下的BER');
    








