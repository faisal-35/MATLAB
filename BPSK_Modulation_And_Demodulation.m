clc;
clear;
close all;
binary_sequence = randi([0 1],1,10);
N = length(binary_sequence);
T = 1;
fs = 1000;
fc = 5;
SNR_dB = 3;
t = 0:1/fs:(N*T)-1/fs;
polar_sequence = 2 * binary_sequence - 1;
polar_NRZ_signal = zeros(1,N*fs);
for i = 1 : N
    polar_NRZ_signal((i-1)*fs+1:i*fs) = polar_sequence(i);
end
carrier_signal = cos(2 * pi * fc * t);
BPSK_signal = polar_NRZ_signal .* carrier_signal;
received_signal = awgn(BPSK_signal,SNR_dB,'measured');
demodulated_signal = received_signal .*carrier_signal;
integrated_signal = zeros(1,N);
for i = 1 : N
    integrated_signal(i) = mean(demodulated_signal((i-1)*fs+1:i*fs));
end
detected_sequence = zeros(1,N);
for i = 1 : N
    if integrated_signal(i) > 0
        detected_sequence(i) = 1;
    else
        detected_sequence(i) = 0;
    end
end
bit_error = sum(binary_sequence~=detected_sequence);
BER = bit_error/N;
disp('Transmitted Binary Sequence : ');
disp(binary_sequence);
disp('Detected Binary Sequence : ');
disp(detected_sequence);
disp(['Number of Bit Error : ',num2str(bit_error)]);
disp(['Bit Error Rate : ',num2str(BER)]);

figure(1);

subplot(411)
stairs(0:N-1,binary_sequence,'r','Linewidth',1.5)
title('Polar NRZ Input Binary Sequence');
xlabel('Time (s)')
ylabel('Amplitude')
ylim([-0.5 1.5])
grid on

subplot(412)
plot(t,BPSK_signal,'c','Linewidth',1.5)
title('BPSK Modulated Signal');
xlabel('Time (s)')
ylabel('Amplitude')
grid on

subplot(413)
plot(t,received_signal,'g','Linewidth',1.5)
title('Received Signal In AWGN Channel');
xlabel('Time (s)')
ylabel('Amplitude')
grid on

subplot(414)
t_integrated = 0:T:(N-1)*T;
plot(t_integrated,integrated_signal,'b','Linewidth',1.5)
title('Output of the Coherent Correlation Receiver');
xlabel('Time (s)')
ylabel('Amplitude')
grid on

figure(2);

subplot(411)
plot(t,carrier_signal)
title('Carrier Signal');
xlabel('Time (s)')
ylabel('Amplitude');
grid on

subplot(412)
stairs(0:N-1,binary_sequence,'g','Linewidth',1.5)
title('Input Binary Sequence');
xlabel('Time (s)')
ylabel('Amplitude')
ylim([-0.5 1.5])
grid on

subplot(413)
stairs(0:N-1,binary_sequence,'b','Linewidth',1.5)
title('Detected Binary Sequence');
xlabel('Time (s)')
ylabel('Amplitude')
ylim([-0.5 1.5])
grid on

subplot(414)
plot(polar_sequence,zeros(1,N),'bo','MarkerFaceColor','r')
title('Signal Space Diagram for BPSK');
xlabel('In Phase (I)')
ylabel('Quadrature (Q)')
xlim([-1.5 1.5])
ylim([-0.5 0.5])
grid on
