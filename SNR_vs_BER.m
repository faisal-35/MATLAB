%BER vs SNR 
clc;
clear;
close all;
M = 8;
bps = log2(M);
txt = 'Information and Communication Engineering';
symbols = double(txt);
symbolToBitMapping = de2bi(symbols,8,'left-msb');
totalNumberOfBits = numel(symbolToBitMapping);
inputReshapedBits = reshape(symbolToBitMapping,1,totalNumberOfBits);
remainder = rem(totalNumberOfBits,bps);
if (remainder) == 0
    userPaddedData = inputReshapedBits;
else
    paddingBits = zeros(1,bps - remainder);
    userPaddedData = [inputReshapedBits paddingBits];
end
reshapedUserData = reshape(userPaddedData,numel(userPaddedData)/bps,bps);
bitToSymbolMapping  = bi2de(reshapedUserData,'left-msb');
modulatedSymbol = pskmod(bitToSymbolMapping,M);

SNR = [];
BER = [];
for snr = 0:15
    SNR = [SNR snr];
    noisySymbols =awgn(modulatedSymbol,snr,'measured');
    demodulatedSymbol = pskdemod(noisySymbols,M);
    demodulatedSymbolToBitMapping = de2bi(demodulatedSymbol,'left-msb');
    reshapedDemodulatedBits = reshape(demodulatedSymbolToBitMapping,1,...
        numel(demodulatedSymbolToBitMapping));
    demodulatedBitsWithoutPadding = reshapedDemodulatedBits(1:totalNumberOfBits);
    [noe, ber] = biterr(inputReshapedBits,demodulatedBitsWithoutPadding);
    BER  = [BER ber]; 
   txtBits = reshape(demodulatedBitsWithoutPadding,numel(demodulatedBitsWithoutPadding)/-8,8);
   txtBitsDecimal = bi2de(txtBits,'left-msb');
   msg = char(txtBitsDecimal)';
end
figure(1)
semilogy(SNR,BER,'--');
xlabel('SNR');
ylabel('BER');
title('SNR vs BER');


