% Fig. 1.22: Parameter study of the logistic growth model (book, Section 1.3, Eq. 1.28)
% y_{n+1} = a y_n (1 - y_n) with y_0 = 0.008 and a = 0.75, 3.3, 3.55, 4
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
y0 = 0.008; N = 24;
n = 0:N;
as = [0.75 3.3 3.55 4];
for p = 1:4
    a = as(p);
    y = zeros(1, N + 1);
    y(1) = y0;
    for k = 1:N
        y(k + 1) = a * y(k) * (1 - y(k));
    end
    subplot(2, 2, p);
    plot(n, y, '--o', 'Color', [0.64 0.08 0.18], 'DisplayName', sprintf('a = %g', a)); hold on
    if a > 1
        plot([0 N], [1 - 1/a, 1 - 1/a], 'k--', 'HandleVisibility', 'off');   % steady state 1 - 1/a
    end
    hold off; xlabel('n'); ylabel('y_n'); legend('show', 'Location', 'northwest');
    fprintf('a = %g:  y_21 ... y_24 = ', a); fprintf('%.4g  ', y(22:25)); fprintf('\n');
end
