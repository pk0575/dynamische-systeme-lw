% Fig. 2.24: Spiral wave after a brief block (book, Section 2.5, Eq. 2.35)
% as Fig. 2.23, but in steps 50 to 52 the coupling d is zero in the region [28, 30] x [1, 50]: the wave breaks and rotates
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
blockade = true; schritte = 301;
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4;
f1 = @(y1, y2) y1.^2 .* exp(y2 - y1) + k;
y1r = 0.2; y2r = c / (1 - a);
for j = 1:180                                        % resting state of a single cell
    y1neu = f1(y1r, y2r); y2r = a * y2r - b * y1r + c; y1r = y1neu;
end

Z = 100;
Y1 = y1r * ones(Z); Y2 = y2r * ones(Z);
Y1(1, :) = 0.3;                                      % left edge (i = 1) starts excited
vor = [2:Z Z]; zur = [1 1:Z-1];                      % neighbor indices, at the boundary the cell itself (no flux)
Y = zeros(Z, Z, schritte + 1); Y(:, :, 1) = Y1;      % Y(:, :, n+1) = state y1 after n steps
for n = 1:schritte
    D = d * ones(Z);
    if blockade && n >= 50 && n <= 52
        D(28:30, 1:50) = 0;                          % block in the region [28, 30] x [1, 50]
    end
    F = f1(Y1, Y2);
    Y1neu = (1 - D) .* F + D / 4 .* (F(vor, :) + F(zur, :) + F(:, vor) + F(:, zur));
    Y2 = a * Y2 - b * Y1 + c;
    Y1 = Y1neu;
    Y(:, :, n + 1) = Y1;
end
weissrot = [linspace(1, 0.43, 64)' linspace(1, 0.04, 64)' linspace(1, 0.12, 64)'];

zeiten = 54:20:214;
for p = 1:9
    n = zeiten(p);
    subplot(3, 3, p);
    imagesc([1 100], [1 100], Y(:, :, n + 1)', [0 4]); axis xy; colormap(weissrot); title(sprintf('n = %d', n));
end
erregt = [nnz(Y(:, :, 101) > 1) nnz(Y(:, :, 201) > 1) nnz(Y(:, :, 301) > 1)];
fprintf('number of excited cells at n = 100, 200, 300: [%d, %d, %d]  -> the excitation does not stop\n', erregt);
