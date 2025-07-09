function [mFreEn] = mFreEn(data_alpha,data_beta, data_theta,data_delta, varargin)

%{

mFreEn returns the Multi-Frequency Entropy for four frequency bands from a single-channel signal.

mFreEn = mFreEn(data_alpha, data_beta, data_theta, data_delta)

Calculates the Multi-Frequency Entropy ``mFreEn`` for input signals filtered
in the Alpha [8-13 Hz], Beta [13-30 Hz], Theta [4-8 Hz], and Delta [0.5-4 Hz] bands.

  Input:
       ``data_alpha`` - (1 × N) array, signal filtered in the alpha band [8–13 Hz].
       ``data_beta``  - (1 × N) array, signal filtered in the beta band [13–30 Hz].
       ``data_theta`` - (1 × N) array, signal filtered in the theta band [4–8 Hz].
       ``data_delta`` - (1 × N) array, signal filtered in the delta band [0.5–4 Hz].

   Optional input name-value pairs:
       ``m`` - Embedding dimension (default = 2)
       ``t`` - Time lag (default = 1)

   Output:
       ``mFreEn`` - Scalar value of the Multi-Frequency Entropy.

 .. caution::
   If ``m`` and ``t`` are not specified, default values of 2 and 1 are used respectively.

 See also: M2FrEn, M3FrEn.

 References:
 [1] Niu, Y., et al. (2024). Multi-frequency entropy for quantifying complex dynamics 
     and its application on EEG Data. Entropy, 26(9), 728.

 Script from "A Novel Entropy Metric for Unified Analysis of Temporal, Spatial, and Spectral EEG Properties"
 Author: Maria Cacciapuoti
 Date: 22/01/2025

%}

% Set default parameters and parse optional inputs
p = inputParser;
addParameter(p, 'm', 2);
addParameter(p, 't', 1);
parse(p, varargin{:});

m = p.Results.m;
t = p.Results.t;


% Considering alpha, beta, theta, and delta as frequency bands, 
% we obtain a matrix U, which contains 
% the time series of the frequency bands of length N.
%
% U = [  𝑢_𝐴(1)   𝑢_𝐴(2) ... 𝑢_𝐴(𝑁)
%        𝑢_𝐵(1)   𝑢_𝐵(2) ... 𝑢_𝐵(𝑁)
%        𝑢_𝑇(1)   𝑢_𝑇(2)) ... 𝑢_𝑇(𝑁)
%        𝑢_D(1)   𝑢_D(2)) ... 𝑢_D(𝑁)]
%
% Where 𝑢_𝐴(𝑖), 𝑢_𝐵(𝑖), 𝑢_𝑇(𝑖) and 𝑢_D(i) respectively represent 
% each time point corresponding to the frequency band
% associated with alpha, beta, theta and delta.


% Matrix U
U = [data_alpha; data_beta; data_theta; data_delta];


% Construction of the time-frequency space, with a predefined 
% embedding dimension m and a certain time-delay t,
% embedding vectors are constructed.
%
% 𝑌_𝑚(𝑖) = [ 𝑢_𝐴(𝑖)    𝑢_𝐴(𝑖+𝑡) ... 𝑢_𝐴(𝑖+(𝑚−1)𝑡)
%            𝑢_𝐵(𝑖)    𝑢_𝐵(𝑖+𝑡) ... 𝑢_𝐵(𝑖+(𝑚−1)𝑡)
%            𝑢_𝑇(𝑖)    𝑢_𝑇(𝑖+𝑡)) ... 𝑢_𝑇(𝑖+(𝑚−1)𝑡)) 
%            𝑢_D(𝑖)    𝑢_D(𝑖+𝑡)) ... 𝑢_D(𝑖+(𝑚−1)𝑡)) ]
%
% Thus, a time-frequency space is constructed including different frequency bands:
% 𝑌_𝑚(1), 𝑌_𝑚(2), …, 𝑌_𝑚(𝑁−𝑚+1)

Y_alpha = embd(m, t, U(1,:));
Y_beta = embd(m, t, U(2,:));
Y_theta = embd(m, t, U(3,:));
Y_delta = embd(m, t, U(4,:));


% Distance calculation: the maximum absolute distance 𝑑_𝑖𝑗^𝑚𝑎𝑥 
% is calculated between pairs of vectors 𝑌_𝑚(𝑖) and 𝑌_𝑚(𝑗).
%
%       𝑑_𝑖𝑗^𝑚𝑎𝑥 = max { |𝑢_𝐴(𝑖+𝑘) − 𝑢_𝐴(𝑗+𝑘)|,      = {𝐷_𝑖𝑗^𝑚 (𝐴), 𝐷_𝑖𝑗^𝑚 (𝐵), 𝐷_𝑖𝑗^𝑚 (𝑇), 𝐷_𝑖𝑗^𝑚 (D)}
%                   k    |𝑢_𝐵(𝑖+𝑘) − 𝑢_𝐵(𝑗+𝑘)|,
%                        |𝑢_𝑇(𝑖+𝑘) − 𝑢_𝑇(𝑗+𝑘)|,
%                        |𝑢_D(𝑖+𝑘) − 𝑢_D(𝑗+𝑘)| }
%
% where k∈{0,τ,2τ,..,(m − 1)τ}

d_alpha = pdist(Y_alpha, 'chebychev');
d_beta = pdist(Y_beta, 'chebychev');
d_theta = pdist(Y_theta, 'chebychev');
d_delta = pdist(Y_delta, 'chebychev');

d_max = [d_alpha; d_beta; d_theta; d_delta];


% Symbolization and Permutations: The obtained distances are vectors
% with 4 components corresponding to the considered bands (alpha, beta, theta, delta).
%
%    𝑑_𝑖𝑗^𝑚𝑎𝑥 =   {𝐷_𝑖𝑗^𝑚 (𝐴), 𝐷_𝑖𝑗^𝑚 (𝐵), 𝐷_𝑖𝑗^𝑚 (𝑇), 𝐷_𝑖𝑗^𝑚 (D)}
%
% These are then ordered in ascending order based on their magnitude and symbolized.
% These symbolized distances are compared to all possible patterns 𝜋_(ℎ),
% where h=1,2,…, g!, and g represents the number of frequency bands.
% Then, the occurrences of the various permutations are counted, 
% and the relative frequencies of occurrence (as probabilities) are calculated.
%
%                       𝑝_𝑡 , t=1,2, …, g!
%
%         𝑝_𝑡 = (# {𝑖 |𝑖 ≤𝑁−(𝑚−1)𝑡, type(𝑈𝑚(𝑖))=𝜋_(𝑡)})/((𝑁−(𝑚−1)𝑡))

% Sorting the columns of d in ascending order
[sorted_d, idx] = sort(d_max, 1); % sorted_d is the sorted matrix, idx are the original indices

% Symbolization based on sorting indices
symbols = ['A', 'B', 'T','D']; % Symbols for the bands
symbolized_d = strings(size(sorted_d)); % Preallocation for the symbolized matrix

for col = 1:size(idx, 2)
    for row = 1:size(idx, 1)
        symbolized_d(row, col) = symbols(idx(row, col));
    end
end

% Possible permutations of the bands
g = size(U, 1); % number of bands
g_factorial = factorial(g); % g! = total number of permutations

permutations = perms(symbols); % Generate all possible permutations

% Preallocate to count occurrences
occurrences = zeros(g_factorial, 1);

% Count the occurrences of each permutation in the columns of symbolized_d
for col = 1:size(symbolized_d, 2)
    current_col = char(symbolized_d(:, col))'; % Current column as a string
    for p = 1:g_factorial
        if isequal(current_col, permutations(p, :))
            occurrences(p) = occurrences(p) + 1;
            break;
        end
    end
end

% Calculate probabilities
total_columns = size(symbolized_d, 2);
probabilities = occurrences / total_columns;


% Calculate Shannon entropy
% The definition of Shannon entropy is used to calculate entropy associated with permutations.
%
% 𝐻_𝑝=−∑_(𝑡=1)^𝑔! 𝑝_𝑡 ln⁡(𝑝_𝑡)
%
% To normalize, 𝐻_𝑝 is divided by the maximum entropy value ln(g!)
%
% mFreEn(U,m)= 𝑯_𝒑/(𝐥𝐧⁡(𝒈!))

% Calculate Shannon entropy
H_p = 0;
for p = 1:g_factorial
    if probabilities(p) > 0 % Avoid log(0)
        H_p = H_p - probabilities(p) * log(probabilities(p));
    end
end

% Normalize entropy
max_entropy = log(g_factorial); % ln(g!)
mFreEn = H_p / max_entropy;  % Normalized Entropy, corresponds to mFreEn

end
