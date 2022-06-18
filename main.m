% 本组课设完成了汉明码、循环码、卷积码的编码与译码
% 并将每一种编码方式通过三种不同信道均封装成函数形式，在主函数中完成调用
% 主函数利用三种比对方式详细比对了不同编码方式与不同信道之间的组合在信噪比不同时误码率的变化
% ①不同信道下，同一编码方式的误码率与信噪比的关系
%   亮点：针对卷积码，根据编码器结构的不同，采用了三种常见的编码器结构完成编码，并分别进行了比对
% ②同一信道下，不同编码方式的误码率与信噪比的关系
% ③以Rayleigh为例,三种不同结构的卷积码的误码率与信噪比关系
%% 主函数
clear all；
clc;
n = 7;
k = 4;                            
d = 1e5;                          % 编码分组数 
% n,k可以控制循环码的编码方式，d可以控制循环码输入信息流的长度
data = randi([0 1],d,k);      % 定义大量比特流
theor_Rice = [0.0926,0.0812,0.0706,0.0607,0.0515,0.0433,0.0359,0.02946,0.0237,0.0189,0.0148,0.0115,0.0088];    % 预先仿真过的未编码数据莱斯信道后的信噪比
EbN0dB = 0:0.5:6;

%% ①下面按照汉明码、循环码、卷积码的顺序依次给出同一编码方式不同信道的误码率
%% 汉明码
[H_theor_AWGN,H_BER_AWGN] = Hamming_BPSK_AWGN(data);                     % Hamming_BPSK_AWGN
[H_theor_Rayleigh,H_BER_Rayleigh] = Hamming_BPSK_Rayleigh(data);         % Hamming_BPSK_Rayleigh
[H_BER_Rice] = Hamming_BPSK_Rice(data);                                  % Hamming_BPSK_Rice

figure(1);
semilogy(EbN0dB,H_theor_AWGN,'c-','Linewidth',2);                       % 作图未编码过AWGN
hold on;
semilogy(EbN0dB,H_theor_Rayleigh,'k:s','Linewidth',2);                  % 作图未编码过Rayleigh
hold on;
semilogy(EbN0dB,theor_Rice,'m','Linewidth',2);                          % 作图未编码过Rice
hold on;
semilogy(EbN0dB,H_BER_AWGN,'r--d','Linewidth',2);                       % 作图Hamming过AWGN
hold on;
semilogy(EbN0dB,H_BER_Rayleigh,'g-*','Linewidth',2);                    % 作图Hamming过Rayleigh
hold on;
semilogy(EbN0dB,H_BER_Rice,'bp-','Linewidth',2);                        % 作图Hamming过Rice
hold off;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码AWGN','未编码Rayleigh','未编码Rice','AWGN','Rayleigh','Rice');
title('BPSK调制,汉明码编码方式下三种信道的BER');
grid on;

%% 循环码
[C_theor_AWGN,C_BER_AWGN]= Cyclic_BPSK_AWGN(data,n,k,d);                % Cyclic_BPSK_AWGN
[C_theor_Rayleigh,C_BER_Rayleigh]= Cyclic_BPSK_Rayleigh(data,n,k,d);    % Cyclic_BPSK_Rayleigh
[C_BER_Rice] = Cyclic_BPSK_Rice(data,n,k,d);                            % Cyclic_BPSK_Rice

figure(2);
semilogy(EbN0dB,C_theor_AWGN,'c-','Linewidth',2);                       % 作图未编码过AWGN
hold on;
semilogy(EbN0dB,C_theor_Rayleigh,'k:s','Linewidth',2);                  % 作图未编码过Rayleigh
hold on;
semilogy(EbN0dB,theor_Rice,'m','Linewidth',2);                          % 作图未编码过Rice
hold on;
semilogy(EbN0dB,C_BER_AWGN,'r--d','Linewidth',2);                       % 作图Cyclic过AWGN
hold on;
semilogy(EbN0dB,C_BER_Rayleigh,'g-*','Linewidth',2);                    % 作图Cyclic过Rayleigh
hold on;
semilogy(EbN0dB,C_BER_Rice,'bp-','Linewidth',2);                        % 作图Cyclic过Rice
hold off;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码AWGN','未编码Rayleigh','未编码Rice','AWGN','Rayleigh','Rice');
title('BPSK调制,循环码编码方式下三种信道的BER');
grid on;
%% 卷积码
% 卷积码可以按照编码器结构的种类不同完成区分，一些常见的编码器结构有(3,1,2)、(2,1,2)、(2,1,4)等
% 下面将依次将这三种编码器生成的卷积码通过三种不同信道进行仿真
%% (3,1,2)卷积码
CtLength = [3];
CdGener = [7 4 6];
[Conv1_theor_AWGN,Conv1_BER_AWGN] = conv_awgn_BER(data, CtLength, CdGener);
[Conv1_theor_Rayleigh,Conv1_BER_Rayleigh] = conv_rayleigh_BER(data, CtLength, CdGener);
[Conv1_BER_Rice] = conv_rice_BER(data, CtLength, CdGener);

figure(3);
semilogy(EbN0dB,Conv1_theor_AWGN,'c-','Linewidth',2);                       % 作图未编码过AWGN
hold on;
semilogy(EbN0dB,Conv1_theor_Rayleigh,'k:s','Linewidth',2);                  % 作图未编码过Rayleigh
hold on;
semilogy(EbN0dB,theor_Rice,'m','Linewidth',2);                              % 作图未编码过Rice
hold on;
semilogy(EbN0dB,Conv1_BER_AWGN,'r--d','Linewidth',2);                       % 作图Conv1过AWGN
hold on;
semilogy(EbN0dB,Conv1_BER_Rayleigh,'g-*','Linewidth',2);                    % 作图Conv1过Rayleigh
hold on;
semilogy(EbN0dB,Conv1_BER_Rice,'bp-','Linewidth',2);                        % 作图Conv1过Rice
hold off;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码AWGN','未编码Rayleigh','未编码Rice','AWGN','Rayleigh','Rice');
title('BPSK调制,(3,1,2)卷积码编码方式下三种信道的BER');
grid on;

%% (2,1,2)卷积码
CtLength = [3];
CdGener = [7 5];
[Conv2_theor_AWGN,Conv2_BER_AWGN] = conv_awgn_BER(data, CtLength, CdGener);
[Conv2_theor_Rayleigh,Conv2_BER_Rayleigh] = conv_rayleigh_BER(data, CtLength, CdGener);
[Conv2_BER_Rice] = conv_rice_BER(data, CtLength, CdGener);

figure(4);
semilogy(EbN0dB,Conv2_theor_AWGN,'c-','Linewidth',2);                       % 作图未编码过AWGN
hold on;
semilogy(EbN0dB,Conv2_theor_Rayleigh,'k:s','Linewidth',2);                  % 作图未编码过Rayleigh
hold on;
semilogy(EbN0dB,theor_Rice,'m','Linewidth',2);                              % 作图未编码过Rice
hold on;
semilogy(EbN0dB,Conv2_BER_AWGN,'r--d','Linewidth',2);                       % 作图Conv2过AWGN
hold on;
semilogy(EbN0dB,Conv2_BER_Rayleigh,'g-*','Linewidth',2);                    % 作图Conv2过Rayleigh
hold on;
semilogy(EbN0dB,Conv2_BER_Rice,'bp-','Linewidth',2);                        % 作图Conv2过Rice
hold off;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码AWGN','未编码Rayleigh','未编码Rice','AWGN','Rayleigh','Rice');
title('BPSK调制,(2,1,2)卷积码编码方式下三种信道的BER');
grid on;

%% (2,1,4)卷积码
CtLength = [5];
CdGener = [23 25];
[Conv3_theor_AWGN,Conv3_BER_AWGN] = conv_awgn_BER(data, CtLength, CdGener);
[Conv3_theor_Rayleigh,Conv3_BER_Rayleigh] = conv_rayleigh_BER(data, CtLength, CdGener);
[Conv3_BER_Rice] = conv_rice_BER(data, CtLength, CdGener);

figure(5);
semilogy(EbN0dB,Conv3_theor_AWGN,'c-','Linewidth',2);                       % 作图未编码过AWGN
hold on;
semilogy(EbN0dB,Conv3_theor_Rayleigh,'k:s','Linewidth',2);                  % 作图未编码过Rayleigh
hold on;
semilogy(EbN0dB,theor_Rice,'m','Linewidth',2);                              % 作图未编码过Rice
hold on;
semilogy(EbN0dB,Conv3_BER_AWGN,'r--d','Linewidth',2);                       % 作图Conv3过AWGN
hold on;
semilogy(EbN0dB,Conv3_BER_Rayleigh,'g-*','Linewidth',2);                    % 作图Conv3过Rayleigh
hold on;
semilogy(EbN0dB,Conv3_BER_Rice,'bp-','Linewidth',2);                        % 作图Conv3过Rice
hold off;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码AWGN','未编码Rayleigh','未编码Rice','AWGN','Rayleigh','Rice');
title('BPSK调制,(2,1,4)卷积码编码方式下三种信道的BER');
grid on;

%% ②下面按照AWGN信道、Rayleigh信道、Rice信道的顺序依次给出同一信道下不同编码方式的误码率
% 从三种常见的卷积码中选择(3,1,2)卷积码完成与汉明码和循环码的比对
%% AWGN信道
figure(6);
semilogy(EbN0dB,H_theor_AWGN,'c-','Linewidth',2);                           % 作图未编码过AWGN
hold on;
semilogy(EbN0dB,H_BER_AWGN,'k:s','Linewidth',2);                            % 作图Hamming过AWGN
hold on;
semilogy(EbN0dB,C_BER_AWGN,'m','Linewidth',2);                              % 作图Cyclic过AWGN
hold on;
semilogy(EbN0dB,Conv1_BER_AWGN,'r--d','Linewidth',2);                       % 作图Conv1过AWGN
hold on;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码AWGN','Hamming过AWGN','Cyclic过AWGN','(3,1,2)卷积码过AWGN');
title('BPSK调制,不同编码方式过AWGN的BER');
grid on;

%% Rayleigh信道
figure(7);
semilogy(EbN0dB,H_theor_Rayleigh,'c-','Linewidth',2);                           % 作图未编码过Rayleigh
hold on;
semilogy(EbN0dB,H_BER_Rayleigh,'k:s','Linewidth',2);                            % 作图Hamming过Rayleigh
hold on;
semilogy(EbN0dB,C_BER_Rayleigh,'m','Linewidth',2);                              % 作图Cyclic过Rayleigh
hold on;
semilogy(EbN0dB,Conv1_BER_Rayleigh,'r--d','Linewidth',2);                       % 作图Conv1过Rayleigh
hold on;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码Rayleigh','Hamming过Rayleigh','Cyclic过Rayleigh','(3,1,2)卷积码过Rayleigh');
title('BPSK调制,不同编码方式过Rayleigh的BER');
grid on;

%% Rice信道
figure(8);
semilogy(EbN0dB,theor_Rice,'c-','Linewidth',2);                             % 作图未编码过Rice
hold on;
semilogy(EbN0dB,H_BER_Rice,'k:s','Linewidth',2);                            % 作图Hamming过Rice
hold on;
semilogy(EbN0dB,C_BER_Rice,'m','Linewidth',2);                              % 作图Cyclic过Rice
hold on;
semilogy(EbN0dB,Conv1_BER_Rice,'r--d','Linewidth',2);                       % 作图Conv1过Rice
hold on;
axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码Rice','Hamming过Rice','Cyclic过Rice','(3,1,2)卷积码过Rice');
title('BPSK调制,不同编码方式过Rice的BER');
grid on;

%% ③针对Rayleigh信道，比较卷积码的三种不同编码器结构的误码率关系
figure(9);
semilogy(EbN0dB,H_theor_Rayleigh,'c-','Linewidth',2);                           % 作图未编码过Rayleigh
hold on;
semilogy(EbN0dB,Conv1_BER_Rayleigh,'r--d','Linewidth',2);                       % 作图Conv1过Rayleigh
hold on;
semilogy(EbN0dB,Conv2_BER_Rayleigh,'k:s','Linewidth',2);                        % 作图Conv2过Rayleigh
hold on;
semilogy(EbN0dB,Conv3_BER_Rayleigh,'m','Linewidth',2);                          % 作图Conv3过Rayleigh
hold on;

axis([0 6 10^-5 1]);
xlabel('EbN0(dB)');
ylabel('BER');
legend('未编码Rayleigh','(3,1,2)卷积码过Rayleigh','(2,1,2)卷积码过Rayleigh','(2,1,4)卷积码过Rayleigh');
title('BPSK调制,三种不同结构的卷积码过Rayleigh的BER');
grid on;
