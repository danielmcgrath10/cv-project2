function[nxcorr] = nxcorr(f, g)
    n = size(g, 1);
    
    f_hat = normalize(f);
    g_hat = normalize(g);
    nxcorr = sum(f_hat .* g_hat, 'all');
end
