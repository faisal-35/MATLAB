clc;
clear;
close;
t = 0:0.001:0.5;
fm = 5;
fc = 20;
A = 5;
mt = square(2*pi*fm*t);
ct = A*sin(2*pi*fc*t);
psk_signal = ct.*mt;

figure(1)
subplot(311)
plot(t,ct)
title('Carrier Signal')
grid on

subplot(312)
plot(t,mt,'r')
title('Message Signal')
grid on

subplot(313)
plot(t,psk_signal)
title('PSK Signal')
grid on
 