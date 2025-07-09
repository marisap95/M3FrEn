function M_Data = Multi(Data,S)
%% Corse graining process
%  Generate the consecutive coarse-grained time series based on mean
%  Input:   Data: (1 x N) array, time series of N samples;
%           S: the scale factor

% Output:
%           M_Data: (1 x N/S) array, the coarse-grained time series at the
%           scale factor S, with N/S samples.

L = length(Data); % Number of samples of original time series
J = fix(L/S);  % Number of samples of scaled time series
M_Data= zeros(1,J);

for i=1:J
    M_Data(1,i) = mean(Data((i-1)*S+1:i*S));
end

end