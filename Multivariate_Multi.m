function M_Data = Multivariate_Multi(Data,S)
%% Multivariate Corse graining process
%  Generate the consecutive coarse-grained time series based on mean
%  Input:   Data: (z × N) matrix, multichannel time series, with z channels and N samples;
%           S: the scale factor.

% Output:
%           M_Data: (z x N/S) matrix, the coarse-grained time series at the
%           scale factor S, with z channels and N/S samples.

L = size(Data,2); % Number of samples of each channel of original time series
J = fix(L/S); % Number of samples of scaled time series
z= size(Data,1); % Number of channels

M_Data= zeros(z,J);

for ch=1:z
    for i=1:J
        M_Data(ch,i) = mean(Data(ch, (i-1)*S+1:i*S));
    end
end

end