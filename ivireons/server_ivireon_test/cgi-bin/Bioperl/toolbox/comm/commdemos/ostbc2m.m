function BER2m = ostbc2m(M, frLen, numPackets, EbNo)
%OSTBC2M  Orthogonal space-time block coding for 2xM antenna configurations.
%
%   BER2M = OSTBC2M(M, FRLEN, NUMPACKETS, EBNOVEC) computes the bit-error rate 
%   estimates via simulation for an orthogonal space-time block coded 
%	configuration using two transmit antennas and M receive antennas, where the
%	frame length, number of packets simulated and the Eb/No range of values are
%	given by FRLEN, NUMPACKETS, and EBNOVEC parameters respectively.
%
%   The simulation uses the full-rate Alamouti encoding scheme for BPSK 
%   modulated symbols with appropriate receiver combining.
%
%   Suggested parameter values:
%       M = 1 or 2; FRLEN = 100; NUMPACKETS = 1000; EBNOVEC = 0:2:20;
%
%   Example:
%       ber22 = ostbc2m(2, 100, 1000, 0:2:20);
%
%   See also MRC1M, OSTBC2M_E, OSTBC4M.

%   References:
%   [1] S. M. Alamouti, "A simple transmit diversity technique for wireless 
%       communications", IEEE Journal on Selected Areas in Communications, 
%       Vol. 16, No. 8, Oct. 1998, pp. 1451-1458.

%   Copyright 2006-2008 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2009/01/05 17:46:03 $

%% Simulation parameters
N = 2;              % Number of transmit antennas
rate = 1; inc = N/rate; repFactor = 2;

% Create BPSK mod-demod objects
P = 2; 	% modulation order 
bpskmod = modem.pskmod('M', P, 'SymbolOrder', 'Gray', 'InputType', 'Integer');
bpskdemod = modem.pskdemod(bpskmod);

%% Pre-allocate variables for speed
txEnc = zeros(frLen/rate, N); r  = zeros(frLen/rate, M);
H  = zeros(frLen/rate, N, M);
z = zeros(frLen, M); z1 = zeros(frLen/N, M); z2 = z1;
error2m = zeros(1, numPackets); BER2m = zeros(1, length(EbNo));

h = waitbar(0, 'Percentage Completed');
set(h, 'name', 'Please wait...');
wb = 100/length(EbNo);

%% Loop over EbNo points
for idx = 1:length(EbNo)
    % Loop over the number of packets
    for packetIdx = 1:numPackets
        data = randi([0 P-1], frLen, 1);         % data vector per user/channel
        tx = modulate(bpskmod, data);        % BPSK modulation

        % Alamouti Space-Time Block Encoder, G2, full rate
        %   G2 = [s1 s2; -s2* s1*]
        s1 = tx(1:N:end); s2 = tx(2:N:end);
        txEnc(1:inc:end, :) = [s1 s2];
        txEnc(2:inc:end, :) = [-conj(s2) conj(s1)];

        % Create the Rayleigh channel response matrix
        H(1:inc:end, :, :) = (randn(frLen/rate/repFactor, N, M) + ...
                                1i*randn(frLen/rate/repFactor, N, M))/sqrt(2);
        %   held constant for repFactor symbol periods
        H(2:inc:end, :, :) = H(1:inc:end, :, :);

        % Received signal for each Rx antenna
        for i = 1:M
            % with power normalization
            r(:, i) = awgn(sum(H(:, :, i).*txEnc, 2)/sqrt(N), EbNo(idx)); 
        end

        % Combiner - assume channel response known at Rx
        hidx = 1:inc:length(H);
        for i = 1:M
            z1(:, i) = r(1:inc:end, i).* conj(H(hidx, 1, i)) + ...
                       conj(r(2:inc:end, i)).* H(hidx, 2, i);

            z2(:, i) = r(1:inc:end, i).* conj(H(hidx, 2, i)) - ...
                       conj(r(2:inc:end, i)).* H(hidx, 1, i);
        end
        z(1:N:end, :) = z1; z(2:N:end, :) = z2;
                
        % ML Detector (minimum Euclidean distance)
        demod2m = demodulate(bpskdemod, sum(z, 2));

        % Determine bit errors
        error2m(packetIdx) = biterr(demod2m, data); 
    end % end of FOR loop for numPackets

    % Calculate BER for current idx
    BER2m(idx) = sum(error2m)/(numPackets*frLen);

    str_bar = [num2str(wb) '% Completed'];
    waitbar(wb/100, h, str_bar);
    wb = wb + 100/length(EbNo);
end  % end of for loop for EbNo

close(h);
    
% [EOF]
