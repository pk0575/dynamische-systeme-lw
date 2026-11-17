% Fig. 1.37: Parameter study and bifurcation diagram of the AV node model (book, Section 1.6, Eq. 1.47)
% V_{n+1} = f(V_n) with V_0 = 1.1, u = 1, V_g = 1, and different values of c
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
Vg = 1; u = 1; V0 = 1.1; N = 40;
f = @(V, c) c .* V + u * (c .* V <= Vg);     % c V, plus u if c V <= V_g
n = 0:N;
farben = [0.43 0.04 0.12; 0.89 0.44 0.49]; marker = 'os';
paare = [1/3 2/3; 0.5001 0.6; 0.71 0.9];
for p = 1:3
    subplot(2, 2, p); hold on
    for i = 1:2
        c = paare(p, i);
        V = zeros(1, N + 1); V(1) = V0;
        for k = 1:N
            V(k + 1) = f(V(k), c);
        end
        plot(n, V, ['--' marker(i)], 'Color', farben(i, :), 'MarkerSize', 4, 'DisplayName', sprintf('c = %.4g', c));
        fprintf('c = %.4g:  V_35 ... V_40 = ', c); fprintf('%.3f  ', V(36:41)); fprintf('\n');
    end
    hold off; ylim([0.6 2.1]); xlabel('n'); ylabel('V_n'); legend('show', 'Location', 'southeast');
end

c = linspace(0.33, 0.999, 3000);          % bifurcation diagram
V = V0 * ones(size(c));
for k = 1:10000
    V = f(V, c);
end
C = []; W = [];
for k = 1:150
    V = f(V, c);
    C = [C c]; W = [W V];
end
subplot(2, 2, 4);
plot(C, W, '.', 'Color', [0 0.39 0], 'MarkerSize', 1);
xlim([0.3 1]); xlabel('c'); ylabel('V_n for n > 10000');
