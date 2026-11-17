% Fig. 2.19: Action potentials in the Chialvo model (book, Section 2.5, Eq. 2.33)
% y1_{n+1} = y1_n^2 exp(y2_n - y1_n) + k,  y2_{n+1} = a y2_n - b y1_n + c  with a = 0.89, c = 0.28, k = 0.03
% left b = 0.26 (regular), right b = 0.18 (chaotic, early afterdepolarizations); top y1, bottom y2
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a = 0.89; c = 0.28; k = 0.03; N = 150;
bs = [0.26 0.18];
for sp = 1:2
    b = bs(sp);
    y1 = zeros(1, N + 1); y2 = zeros(1, N + 1);
    y1(1) = 0.2; y2(1) = c / (1 - a);
    for j = 1:N
        y1(j + 1) = y1(j)^2 * exp(y2(j) - y1(j)) + k;
        y2(j + 1) = a * y2(j) - b * y1(j) + c;
    end
    ap = sum(y1(2:end) > 1 & y1(1:end-1) <= 1);        % number of excursions above 1
    fprintf('b = %g: %d action potentials in %d steps, max y1 = %.2f\n', b, ap, N, max(y1));
    subplot(2, 2, sp);
    plot(0:N, y1, 'o--', 'MarkerSize', 2, 'Color', [0.64 0.08 0.18]); title(sprintf('b = %g', b));
    if sp == 1, ylabel('y_{1,n}'); end
    subplot(2, 2, sp + 2);
    plot(0:N, y2, 'o--', 'MarkerSize', 2, 'Color', [0.89 0.44 0.49]); xlabel('n');
    if sp == 1, ylabel('y_{2,n}'); end
end
