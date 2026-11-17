% Fig. 1.15: Newton's law of cooling (book, Section 1.2, Eq. 1.21)
% T_{n+1} = T_n + alpha (T^u - T_n) with T_0 = 35 and T^u = 23
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
T0 = 35; Tu = 23; N = 20;
n = 0:N;
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; marker = 'osd';
alphas = [0.1 0.2 0.5 1.9 2.0 2.1];

for i = 1:6
    alpha = alphas(i);
    T = zeros(1, N + 1);
    T(1) = T0;
    for k = 1:N
        T(k + 1) = T(k) + alpha * (Tu - T(k));
    end
    if i <= 3                            % 0 < alpha < 1: monotone approach to T^u, all in one plot
        subplot(2, 2, 1); hold on
        plot(n, T, ['--' marker(i)], 'Color', rot(i, :), 'DisplayName', sprintf('\\alpha = %g', alpha));
    else                                 % 1 < alpha: oscillations
        subplot(2, 2, i - 2); hold on
        plot(n, T, '--o', 'Color', rot(2, :), 'DisplayName', sprintf('\\alpha = %g', alpha));
        fprintf('alpha = %g:  T_19 = %.3f,  T_20 = %.3f\n', alpha, T(20), T(21));
    end
    plot([0 N], [Tu Tu], 'k-', 'HandleVisibility', 'off');
    hold off; xlabel('n'); ylabel('T_n'); legend('show', 'Location', 'northeast');
end
