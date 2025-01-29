clc;
clear;
close;
fm = 10;
fc = 100;
am = 1;
ac = 1;
t = 0:0.001:0.5;
df = 50;
wc1 = 2*pi*fm;
wc2 = 2*pi*fc;
mt = am*sin(wc1*t);
ct = ac*sin(wc2*t);
mod_signal = ac*cos(wc2*t+(2*pi*df/fm)*sin(wc1*t));
figure(1)
subplot(311)
plot(t,mt)
title('Modulating Signal')

subplot(312)
plot(t,ct)
title('Carrier Signal')

subplot(313)
plot(t,mod_signal)
title('Modulated Signal')