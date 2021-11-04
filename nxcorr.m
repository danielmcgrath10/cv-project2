function[nxcorr] = nxcorr(f, g)
    n = size(g, 1);
    border = floor(n/2);
    x = size(f, 1);
    y = size(f, 2);
    
    g_hat = normalize(g);
    
    nxcorr = f(:,:);
    for i = (border + 1) : (x - border)
       for j = (border + 1) : (y - border)
          slice = f((i - border):(i + border), (j - border):(j + border));
          slice_hat = normalize(slice); 
          nxcorr(i, j) = sum(slice_hat .* g_hat, 'all');
       end
    end
end
