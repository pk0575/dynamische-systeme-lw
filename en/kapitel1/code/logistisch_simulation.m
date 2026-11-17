% Fig. 1.20: Simulation of the logistic growth model (book, Section 1.3, Eq. 1.26)
% x_{n+1} = x_n + r (1 - x_n/K) x_n with K = 5, x_0 = 0.1, and three growth rates r; 20 (left) and 50 (right) steps
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
K = 5; x0 = 0.1;
raten = [0.5 0.25 0.1];
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; marker = 'osd';
Ns = [20 50];
for p = 1:2
    N = Ns(p); n = 0:N;
    subplot(1, 2, p); hold on
    for i = 1:3
        r = raten(i);
        x = zeros(1, N + 1);
        x(1) = x0;                       % MATLAB counts from 1: x(1) is x_0
        for k = 1:N
            x(k + 1) = x(k) + r * (1 - x(k) / K) * x(k);
        end
        plot(n, x, ['--' marker(i)], 'Color', rot(i, :), 'MarkerSize', 4, 'DisplayName', sprintf('r = %g', r));
        fprintf('N = %d, r = %g:  x_N = %.4f\n', N, r, x(N + 1));
    end
    plot([0 N], [K K], 'k-', 'HandleVisibility', 'off');
    hold off; xlabel('n'); ylabel('x_n'); legend('show', 'Location', 'southeast');
end
