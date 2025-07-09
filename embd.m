function A=embd(m, t, ts)
% This function creates a delay embedded vector with 
% embedding dimension value m and time lag value t.
% ts is the time series-a vector of dimension (1 * nsamp);

% Ref: M. U. Ahmed and D. P. Mandic, "Multivariate multiscale entropy
% analysis", IEEE Signal Processing Letters, vol. 19, no. 2, pp.91-94.2012

nsamp = length(ts);
A=[];

for i=1:nsamp-m
 temp1(i,:)=ts(i:t:i+m-1);
end
A=horzcat(A,temp1);

temp1=[];

end