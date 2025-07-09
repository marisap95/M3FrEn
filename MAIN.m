%{
Author: Maria Cacciapuoti
Date: 02/02/2025 

Script from "A Novel Entropy Metric for Unified Analysis of Temporal, Spatial, and Spectral EEG Properties"

MAIN SCRIPT for evaluating mFreEn, M2FrEn, and M3FrEn on simulated EEG signals
using the MIX MODEL.
%}

clear;
clc; 
close all;

%% Parameters
fs = 500;         % Sampling frequency (Hz)
N = 1000;         % Signal length
num_channels = 3; % Number of channels
p = 0.2;          % MIX proportion: fraction of sinusoid replaced with noise
m = 2;            % Embedding dimension
tau = 1;          % Time lag
num_Scales = 20;  % Number of scales for multiscale metrics
t = (0:N-1)/fs;   % Time vector

% Frequency and amplitude per EEG band
bands = struct( ...
    'delta', struct('f', 2, 'A', 7/2 * sqrt(2)), ...
    'theta', struct('f', 6, 'A', 3 * sqrt(2)), ...
    'alpha', struct('f', 10, 'A', 2 * sqrt(2)), ...
    'beta',  struct('f', 20, 'A', sqrt(2)) ...
);

%% Signal Generation with MIX MODEL
% For each band, create a sinusoidal signal and replace p*N points with uniform noise
fields = fieldnames(bands);
for i = 1:numel(fields)
    band = fields{i};
    f = bands.(band).f;
    A = bands.(band).A;

    % Sinusoidal signal per channel
    X = A * sin(2*pi*f*t);                 % (1×N)
    signal = repmat(X, num_channels, 1);   % (channels×N)

    % Uniform noise in range [-sqrt(3), sqrt(3)]
    noise = (rand(num_channels, N) * 2 * sqrt(3)) - sqrt(3);

    % Randomly select p*N indices to replace
    num_noise = round(p * N);
    idx = randperm(N, num_noise);

    % Apply MIX: replace sinusoid with noise at random time points
    for ch = 1:num_channels
        signal(ch, idx) = noise(ch, idx);
    end

    % Store in struct
    data.(band) = signal;
end

%% Apply mFreEn (per channel)
fprintf("Computing mFreEn per channel...\n");
mFreEn_vals = zeros(num_channels, 1);
for ch = 1:num_channels
    mFreEn_vals(ch) = mFreEn(data.alpha(ch,:), data.beta(ch,:), ...
                             data.theta(ch,:), data.delta(ch,:), ...
                             'm', m, 't', tau);
end

%% Apply M2FrEn (per channel and scale)
fprintf("Computing M2FrEn per channel...\n");
M2FrEn_vals = zeros(num_channels, num_Scales);
for ch = 1:num_channels
    M2FrEn_vals(ch,:) = M2FrEn(data.alpha(ch,:), data.beta(ch,:), ...
                               data.theta(ch,:), data.delta(ch,:), ...
                               'm', m, 't', tau, 'Scale', num_Scales);
end

%% Apply M3FrEn (on all channels)
fprintf("Computing M3FrEn on multichannel signal...\n");
M3FrEn_vals = M3FrEn(data.alpha, data.beta, data.theta, data.delta, ...
                     'm', m, 't', tau, 'Scale', num_Scales);

%% Plotting

% mFreEn
figure;
bar(mFreEn_vals);
title('mFreEn per channel');
xlabel('Channel'); ylabel('Entropy value');

% M2FrEn
figure;
plot(1:num_Scales, M2FrEn_vals, 'LineWidth', 1.5);
title('M2FrEn per channel over scales');
xlabel('Scale'); ylabel('Entropy'); legend('Ch1', 'Ch2', 'Ch3');

% M3FrEn
figure;
plot(1:num_Scales, M3FrEn_vals, 'k-', 'LineWidth', 2);
title('M3FrEn (Multivariate over 3 channels)');
xlabel('Scale'); ylabel('Entropy');
