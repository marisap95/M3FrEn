function [M2FrEn]= M2FrEn(data_alpha,data_beta, data_theta,data_delta,varargin)

%{

 M2FrEn returns the Multiscale Multi-Frequency Entropy for four frequency bands from a single-channel signal.

   M2FrEn = M2FrEn(data_alpha, data_beta, data_theta, data_delta)

   Calculates the Multiscale Multi-Frequency Entropy ``M2FrEn`` for input signals filtered
   in the Alpha [8-13 Hz], Beta [13-30 Hz], Theta [4-8 Hz], and Delta [0.5-4 Hz] bands,
   using mean-based coarse-graining.

   Input:
       ``data_alpha`` - (1 × N) array, signal filtered in the alpha band [8–13 Hz].
       ``data_beta``  - (1 × N) array, signal filtered in the beta band [13–30 Hz].
       ``data_theta`` - (1 × N) array, signal filtered in the theta band [4–8 Hz].
       ``data_delta`` - (1 × N) array, signal filtered in the delta band [0.5–4 Hz].

   Optional input name-value pairs:
       ``m``     - Embedding dimension (default = 2)
       ``t``     - Time lag (default = 1)
       ``Scale`` - Number of scales for coarse-graining (default = 20)

   Output:
       ``M2FrEn`` - (1 × Scale) array containing Multiscale Multi-Frequency Entropy values.

 .. caution::
   If ``m``, ``t``, or ``Scale`` are not specified, default values of 2, 1, and 20 are used respectively.

 See also: mFreEn, M3FrEn

 References:
 [1] Niu, Y., et al. (2024). Multi-frequency entropy for quantifying complex dynamics 
     and its application on EEG Data. Entropy, 26(9), 728.

 Author: Maria Cacciapuoti
 Date: 22/01/2025

Script from "A Novel Entropy Metric for Unified Analysis of Temporal, Spatial, and Spectral EEG Properties"
%}

% Set default parameters and parse optional inputs
p = inputParser;
addParameter(p, 'm', 2);
addParameter(p, 't', 1);
addParameter(p, 'Scale', 20);
parse(p, varargin{:});

m = p.Results.m;
t = p.Results.t;
Scale = p.Results.Scale;

M2FrEn(1)= mFreEn(data_alpha, data_beta, data_theta, data_delta,'m',m,'t',t);

for S=2:Scale

    data_alpha_scaled = Multi(data_alpha, S);
    data_beta_scaled= Multi(data_beta, S);
    data_theta_scaled= Multi(data_theta, S);
    data_delta_scaled= Multi(data_delta, S);

    M2FrEn(S) = mFreEn(data_alpha_scaled, data_beta_scaled, data_theta_scaled, data_delta_scaled,'m',m,'t',t);
end


end