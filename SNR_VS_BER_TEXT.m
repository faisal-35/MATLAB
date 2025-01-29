clc;
clear;
close all;

% Parameters
M = 8;                          % Modulation order (8-PSK)
bps = log2(M);                  % Bits per symbol
txt = 'Information and Communication Engineering';  % Input text
symbols = double(txt);          % Convert text to double (ASCII)

% Symbol to Bit Mapping (Convert text to binary)
symbolToBitMapping = de2bi(symbols, 8, 'left-msb');  % 8-bit binary representation
totalNumberOfBits = numel(symbolToBitMapping);       % Total number of bits
inputReshapedBits = reshape(symbolToBitMapping, 1, totalNumberOfBits);  % Reshape to row vector

% Padding bits to make it divisible by bps (log2(M))
remainder = rem(totalNumberOfBits, bps);
if remainder == 0
    userPaddedData = inputReshapedBits;
else
    paddingBits = zeros(1, bps - remainder);  % Padding bits
    userPaddedData = [inputReshapedBits, paddingBits];  % Append padding
end

% Reshape the user data into symbols (group bits into bps size)
reshapedUserData = reshape(userPaddedData, [], bps);   % Group bits into symbols of size bps
bitToSymbolMapping = bi2de(reshapedUserData, 'left-msb');  % Convert to symbol indices

% Modulation (8-PSK modulation)
modulatedSymbol = pskmod(bitToSymbolMapping, M);  % Perform 8-PSK modulation

% SNR and BER Initialization
SNR = 0:15;                        % Range of SNR in dB
BER = zeros(size(SNR));            % Preallocate BER vector

% Simulation Loop for SNR
for idx = 1:length(SNR)
    % Add AWGN Noise to modulated symbols
    noisySymbols = awgn(modulatedSymbol, SNR(idx), 'measured');
    
    % Demodulation (8-PSK demodulation)
    demodulatedSymbol = pskdemod(noisySymbols, M);  % Demodulate symbols
    
    % Convert demodulated symbols back to bits
    demodulatedSymbolToBitMapping = de2bi(demodulatedSymbol, bps, 'left-msb');  % Convert to binary
    reshapedDemodulatedBits = reshape(demodulatedSymbolToBitMapping', 1, []);  % Reshape to row vector
    
    % Remove Padding Bits (if any)
    demodulatedBitsWithoutPadding = reshapedDemodulatedBits(1:totalNumberOfBits);  % Remove the padding bits
    
    % Calculate Bit Error Rate (BER)
    [~, ber] = biterr(inputReshapedBits, demodulatedBitsWithoutPadding);  % Calculate number of bit errors
    BER(idx) = ber;  % Store BER for current SNR value
end

% Plot SNR vs BER
figure(1);
semilogy(SNR, BER, 'o--', 'LineWidth', 1.5);  % Plot BER vs SNR on a log scale
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title('SNR vs BER for 8-PSK Modulation');
