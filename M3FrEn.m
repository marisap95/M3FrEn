function [M3FrEn] = M3FrEn(data_alpha, data_beta, data_theta, data_delta, varargin)

%{
 M3FrEn returns the Multivariate Multiscale Multi-Frequency Entropy for four frequency bands from a multivariate signal.

   M3FrEn = M3FrEn(data_alpha, data_beta, data_theta, data_delta)

   Calculates the Multivariate Multiscale Multi-Frequency Entropy ``M3FrEn`` for input signals filtered
   in the Alpha [8–13 Hz], Beta [13–30 Hz], Theta [4–8 Hz], and Delta [0.5–4 Hz] bands,
   for multivariate signals with multiple channels and multiple scales.

   Input:
       ``data_alpha`` - (z × N) matrix, multichannel signal filtered in the alpha band [8–13 Hz].
       ``data_beta``  - (z × N) matrix, multichannel signal filtered in the beta band [13–30 Hz].
       ``data_theta`` - (z × N) matrix, multichannel signal filtered in the theta band [4–8 Hz].
       ``data_delta`` - (z × N) matrix, multichannel signal filtered in the delta band [0.5–4 Hz].
                        where ``z`` is the number of channels and ``N`` is the number of samples.

   Optional input name-value pairs:
       ``'m'``     - Embedding dimension (default = 2)
       ``'t'``     - Time lag (default = 1)
       ``'Scale'`` - Number of scales for coarse-graining (default = 20)

   Output:
       ``M3FrEn`` - (1 × Scale) array containing Multivariate Multiscale Multi-Frequency Entropy values.

 .. caution::
   If ``m``, ``t``, or ``Scale`` are not specified, default values of 2, 1, and 20 are used respectively.

 See also: MSampEn, MvFuzzEn, MvMSE

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

N = size(data_alpha,2); % number of samples
z= size(data_alpha,1);  % number of channels

M= m*ones(z,1);  % M: embedding vector, uniform embedding dimensions for all channels.
tau= t*ones(z,1); % tau: time lag vector, unifrom time delay for all channels.

% M3FrEn initialisation
M3FrEn= zeros(1, Scale);

%% Construction of the matrix U
% Considering alpha, beta, theta, and delta as frequency bands, 
% we obtain a matrix U, which contains 
% the time series of the frequency bands of length (N * z),
% where N is the number of samples for each channel and z is the number of channels.
%
% U = [  𝑢_𝐴,1(1)   𝑢_𝐴,1(2) ... 𝑢_𝐴,1(𝑁),  ... ,𝑢_𝐴,z(1)   𝑢_𝐴,z(2) ... 𝑢_𝐴,z(𝑁)
%        𝑢_𝐵,1(1)   𝑢_𝐵,1(2) ... 𝑢_𝐵,1(𝑁),  ... ,𝑢_𝐵,z(1)   𝑢_𝐵,z(2) ... 𝑢_𝐵,z(𝑁)
%        𝑢_𝑇,1(1)   𝑢_𝑇,1(2)) ... 𝑢_𝑇,1(𝑁),  ... ,𝑢_𝑇,z(1)   𝑢_𝑇,z(2)) ... 𝑢_𝑇,z(𝑁)
%        𝑢_D,1(1)   𝑢_D,1(2)) ... 𝑢_D,1(𝑁),  ... ,𝑢_D,z(1)   𝑢_D,z(2)) ... 𝑢_D,z(𝑁)]
%
% Where 𝑢_𝐴,c(𝑖), 𝑢_𝐵,c(𝑖), 𝑢_𝑇,c(𝑖), and 𝑢_D,c(𝑖) respectively represent 
% each time point corresponding to the frequency band
% associated with alpha, beta, theta and delta for each channel.

Alpha= data_alpha';
Beta= data_beta';
Theta= data_theta';
Delta= data_delta';

% Matrix U
U = [Alpha(:)'; Beta(:)'; Theta(:)'; Delta(:)'];


for S=1:Scale

    %% Multivariate Coarse Graining Process
    % For each scale S, we apply the multivariate coarse-graining process 
    % to the signals filtered in the alpha, beta, theta, and delta bands.
    % This results in four scaled matrices: M_alpha, M_beta, M_theta, and M_delta,
    % each representing the coarse-grained signal for the respective frequency band,
    % with dimension (N/S × z), where N/S is the number of samples after coarse-graining 
    % and z is the number of channels.

    % From these, we construct the matrix U_S, which represents the scaled version 
    % of the original matrix U for scale S:
    %
    % U_S = [  M_alpha,1(1)   M_alpha,1(2) ... M_alpha,1(N/S), ..., M_alpha,z(1) ... M_alpha,z(N/S)
    %          M_beta,1(1)    M_beta,1(2)  ... M_beta,1(N/S),  ..., M_beta,z(1)  ... M_beta,z(N/S)
    %          M_theta,1(1)   M_theta,1(2) ... M_theta,1(N/S), ..., M_theta,z(1) ... M_theta,z(N/S)
    %          M_delta,1(1)   M_delta,1(2) ... M_delta,1(N/S), ..., M_delta,z(1) ... M_delta,z(N/S) ]
    %
    % Where M_band,c(i) refers to the i-th coarse-grained time point of the c-th channel
    % for the corresponding frequency band (alpha, beta, theta, or delta).
    % The matrix U_S is then used to compute the entropy at scale S.

    data_alpha_scaled = Multivariate_Multi(data_alpha, S);
    data_beta_scaled= Multivariate_Multi(data_beta, S);
    data_theta_scaled= Multivariate_Multi(data_theta, S);
    data_delta_scaled= Multivariate_Multi(data_delta, S);

    M_alpha= data_alpha_scaled';
    M_beta= data_beta_scaled';
    M_theta= data_theta_scaled';
    M_delta= data_delta_scaled';

    U_S = [M_alpha(:)'; M_beta(:)'; M_theta(:)'; M_delta(:)'];

    %% Multivariate Time-Frequency Space Construction
    % Construction of the time-frequency space, with a predefined 
    % embedding dimension m (uniform for all channels) and a certain time-delay t, for the scale S,
    % embedding vectors are constructed.
    %
    % 𝑌_𝑚(𝑖) = [ M_alpha,1(𝑖)    M_alpha,1(𝑖+𝑡) ... M_alpha,1(𝑖+(𝑚−1)𝑡), ... , M_alpha,z(𝑖)     M_alpha,z(𝑖+𝑡) ... M_alpha,z(𝑖+(𝑚−1)𝑡)
    %            M_beta,1(𝑖)     M_beta,1(𝑖+𝑡) ...  M_beta,1(𝑖+(𝑚−1)𝑡), ... ,  M_beta,z(𝑖)      M_beta,z(𝑖+𝑡) ...  M_beta,z(𝑖+(𝑚−1)𝑡)
    %            M_theta,1(𝑖)    M_theta,1(𝑖+𝑡) ... M_theta,1(𝑖+(𝑚−1)𝑡)), ... ,M_theta,z(𝑖)     M_theta,z(𝑖+𝑡) ... M_theta,z(𝑖+(𝑚−1)𝑡))
    %            M_delta,1(𝑖)    M_delta,1(𝑖+𝑡) ... M_delta,1(𝑖+(𝑚−1)𝑡)), ... ,M_delta,z(𝑖)     M_delta,z(𝑖+𝑡) ... M_delta,z(𝑖+(𝑚−1)𝑡)) ]
    %
    % Thus, a time-frequency space is constructed including different frequency bands and different channels
    % where 1 ≤ i ≤ N/S − (m − 1)t
    
    Y_alpha = embd_multivariate(M, tau, U_S(1,:));
    Y_beta = embd_multivariate(M, tau, U_S(2,:));
    Y_theta = embd_multivariate(M, tau, U_S(3,:));
    Y_delta = embd_multivariate(M, tau, U_S(4,:));
    
    
    %% Distance calculation: 
    % the maximum absolute distance 𝑑_𝑖𝑗^𝑚𝑎𝑥 is calculated between pairs of vectors 𝑌_𝑚(𝑖) and 𝑌_𝑚(𝑗).
    %
    %       𝑑_𝑖𝑗^𝑚𝑎𝑥 =    max              max           { |M_alpha,c(𝑖+𝑘) − M_alpha,c(𝑗+𝑘)|,      = {𝐷_𝑖𝑗^𝑚 (𝐴), 𝐷_𝑖𝑗^𝑚 (𝐵), 𝐷_𝑖𝑗^𝑚 (𝑇), 𝐷_𝑖𝑗^𝑚 (D)}
    %                  1<=c<=z    k∈{0,τ,2τ,..,(m − 1)τ}   |M_beta,c(𝑖+𝑘) − M_beta,c(𝑗+𝑘)|,
    %                                                      |M_theta,c(𝑖+𝑘) − M_theta,c(𝑗+𝑘)|,
    %                                                      |M_delta,c(𝑖+𝑘) − M_delta,c(𝑗+𝑘)| }
    
    d_alpha = pdist(Y_alpha, 'chebychev');
    d_beta = pdist(Y_beta, 'chebychev');
    d_theta = pdist(Y_theta, 'chebychev');
    d_delta = pdist(Y_delta, 'chebychev');
    
    d_max = [d_alpha; d_beta; d_theta; d_delta];
    
    
    %% Symbolization and Permutations
    % The obtained distances are vectors with 4 components corresponding 
    % to the considered bands (alpha, beta, theta, delta).
    %
    %    𝑑_𝑖𝑗^𝑚𝑎𝑥 =  {𝐷_𝑖𝑗^𝑚 (𝐴), 𝐷_𝑖𝑗^𝑚 (𝐵), 𝐷_𝑖𝑗^𝑚 (𝑇), 𝐷_𝑖𝑗^𝑚 (D)}
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
    symbols = ['A', 'B', 'T', 'D']; % Symbols for the bands
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
    
    
    %% Calculate Shannon entropy
    % The definition of Shannon entropy is used to calculate entropy associated with permutations.
    %
    % 𝐻_𝑝=−∑_(𝑡=1)^𝑔! 𝑝_𝑡 ln⁡(𝑝_𝑡)
    %
    % To normalize, 𝐻_𝑝 is divided by the maximum entropy value ln(g!)
    %
    % M3FrEn= 𝑯_𝒑/(𝐥𝐧⁡(𝒈!))
    
    % Calculate Shannon entropy
    H_p = 0;
    for p = 1:g_factorial
        if probabilities(p) > 0 % Avoid log(0)
            H_p = H_p - probabilities(p) * log(probabilities(p));
        end
    end
    
    % Normalize entropy
    max_entropy = log(g_factorial); % ln(g!)
    M3FrEn(1, S) = H_p / max_entropy;  % Normalized Entropy, corresponds to M3FrEn

end

end
