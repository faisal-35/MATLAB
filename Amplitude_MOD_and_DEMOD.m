clc;
clear;
close;
fm = 10;
fc = 100;
am = 1;
ac = 1;
t = 0:0.001:1;
k = am/ac;
wc1 = 2*pi*fm;
wc2 = 2*pi*fc;
mt = am*sin(wc1*t);
ct = ac*sin(wc2*t);
mod_signal = (1+k*mt).*ct;
demod_signal = (ac+mt);
figure(1)
subplot(221)
plot(t,mt)
title('Modulating Signal')

subplot(222)
plot(t,ct)
title('Carrier Signal')

subplot(223)
plot(t,mod_signal,t,ac+mt,t,-ac-mt)
title('Modulated Signal ')

subplot(224)
plot(t,mt,t,demod_signal)
title('Demodulated Signal')

