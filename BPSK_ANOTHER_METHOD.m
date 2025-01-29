% 
fc = 5;                   
T = 1;                      
fs = 1000;       
N = 10;       
SNR_dB = 3;

t = 0:1/fs:T-1/fs;   

data = [0 1 0 0 1 0 0 0 0 1];

polar_sequence = 2 * data - 1;

modulated_signal = zeros(1, N * length(t));
for i = 1:N
    if data(i) == 1
        modulated_signal((i-1)*length(t) + 1:i*length(t)) = sqrt(2/T) * cos(2 * pi * fc * t);
    else
        modulated_signal((i-1)*length(t) + 1:i*length(t)) = -sqrt(2/T) * cos(2 * pi * fc * t);
    end
end

received_signal = awgn(modulated_signal, SNR_dB, 'measured');  % Add noise

demodulated_data = zeros(1, N);
for i = 1:N
    received_symbol = received_signal((i-1)*length(t) + 1:i*length(t));
    corr_bit_1 = sum(received_symbol ...
        .* (sqrt(2/T) * cos(2 * pi * fc * t)));
    corr_bit_0 = sum(received_symbol ...
    .* (-sqrt(2/T) * cos(2 * pi * fc * t)));
   
    if corr_bit_1 > corr_bit_0
        demodulated_data(i) = 1; 
    else
        demodulated_data(i) = 0;
    end
end

errors = sum(data ~= demodulated_data);
BER = errors / N;

disp(['Bit Error Rate (BER): ', num2str(BER)]);
figure;

subplot(5,1,1);
stairs(0:N-1, data, 'r', 'LineWidth', 1.5);
title('Polar NRZ Input Binary Sequence');
xlabel('Symbol Index');
ylabel('Amplitude');
grid on;

subplot(5,1,2);
plot(0:length(modulated_signal)-1, modulated_signal, 'b', 'LineWidth', 1.5); % BPSK Modulated signal
title('BPSK Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% (b) Received BPSK Signal in AWGN
subplot(5,1,3);
plot(0:length(received_signal)-1, received_signal, 'r', 'LineWidth', 1.5); % Received signal in AWGN
title('Received BPSK Signal in AWGN');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

integrated_signal = zeros(1, N);  
for i = 1:N
   
    received_symbol = received_signal((i-1)*length(t) + 1:i*length(t));
    
    integrated_signal(i) = sum(received_symbol .* (sqrt(2/T) * cos(2 * pi * fc * t))); % For Q1(t)
end
subplot(5,1,4);
t_int = 0:T:(N-1)*T;  % Time vector for integration plot
plot(t_int, integrated_signal, 'k', 'LineWidth', 1.5); % Output of the receiver
title('Output of Coherent Correlation Receiver');
xlabel('Symbol Index');
ylabel('Amplitude');
grid on;

% (d) Signal Space Diagram for BPSK
subplot(5,1,5);
hold on;
plot(polar_sequence, zeros(1, N), 'bo', 'MarkerFaceColor', 'b');  % Plot BPSK constellation points (I, Q)
title('Signal Space Diagram for BPSK');
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
xlim([-1.5 1.5]);
ylim([-0.5 0.5]);
grid on;
