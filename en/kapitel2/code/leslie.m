% Fig. 2.9: Leslie model with three age classes (book, Section 2.2, Eq. 2.11)
% x_{n+1} = L x_n with birth rate 9 of class 3 and survival rates 0.1 and 0.6, x_0 = (0, 0, 1000)
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
L = [0   0   9;
     0.1 0   0;
     0   0.6 0];
N = 20;
X = zeros(3, N + 1);
X(:, 1) = [0; 0; 1000];
for k = 1:N
    X(:, k + 1) = L * X(:, k);
end
fprintf('class 3 every three steps: '); fprintf('%.1f  ', X(3, 1:3:end)); fprintf('\n');
fprintf('factor per period: 9 * 0.1 * 0.6 = %g < 1, the population dies out\n', 9 * 0.1 * 0.6);

farben = [0.43 0.04 0.12; 0.89 0.44 0.49; 0.64 0.08 0.18]; marker = 'osd';
for i = 1:3
    subplot(3, 1, i);
    plot(0:N, X(i, :), ['--' marker(i)], 'Color', farben(i, :)); legend(sprintf('Class %d', i));
end
xlabel('n');
