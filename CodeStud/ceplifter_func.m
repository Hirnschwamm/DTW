%=======================================
% Cepstrale Liftering
%=======================================
function lifter_func = ceplifter_func(N,L)

lifter_func = ( 1+0.5*L*sin(pi*[0:N-1]/L) );