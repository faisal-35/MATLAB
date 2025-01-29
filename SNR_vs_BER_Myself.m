clc;
clear;
close all;

% Parameters
M = 8; % Modulation order
bps = log2(M); % Bits per symbol
txt = 'Information and Communication Engineering';
symbols = double(txt);

% Symbol to Bit Mapping
symbolToBitMapping = de2bi(symbols, 8, 'left-msb');
totalNumberOfBits = numel(symbolToBitMapping);
inputReshapedBits = reshape(symbolToBitMapping, 1, totalNumberOfBits);

% Padding bits to make it divisible by bps
remainder = rem(totalNumberOfBits, bps);
if remainder == 0
    userPaddedData = inputReshapedBits;
else
    paddingBits = zeros(1, bps - remainder);
    userPaddedData = [inputReshapedBits, paddingBits];
end

% Reshape the user data into symbols
reshapedUserData = reshape(userPaddedData, [], bps);
bitToSymbolMapping = bi2de(reshapedUserData, 'left-msb');

% Modulation
modulatedSymbol = pskmod(bitToSymbolMapping, M);

% SNR and BER Initialization
SNR = 0:15; % Range of SNR in dB
BER = zeros(size(SNR)); % Preallocate BER vector

% Simulation Loop for SNR
for idx = 1:length(SNR)
    % Add AWGN Noise
    noisySymbols = awgn(modulatedSymbol, SNR(idx), 'measured');
    
    % Demodulation
    demodulatedSymbol = pskdemod(noisySymbols, M);
    demodulatedSymbolToBitMapping = de2bi(demodulatedSymbol, bps, 'left-msb');
    reshapedDemodulatedBits = reshape(demodulatedSymbolToBitMapping', 1, []);
    
    % Remove Padding Bits
    demodulatedBitsWithoutPadding = reshapedDemodulatedBits(1:totalNumberOfBits);
    
    % Calculate BER
    [~, ber] = biterr(inputReshapedBits, demodulatedBitsWithoutPadding);
    BER(idx) = ber;
end

% Plot SNR vs BER
figure(1);
semilogy(SNR, BER, 'o--', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title('SNR vs BER for 8-PSK');
