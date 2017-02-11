function dct = dct_matrix(N,M)

dct =  sqrt(2.0/M) * cos( repmat([0:N-1].',1,M).* repmat(pi*([1:M]-0.5)/M,N,1) ) ;
