% Fig. 2.4: Predator-prey model, predators and prey survive (book, Section 2.1, Eq. 2.3)
% u_{n+1} = (1 + r) u_n - r u_n^2 - gamma u_n v_n,  v_{n+1} = gamma u_n v_n  with r = 3.1, gamma = 2.1, u_0 = 0.5, v_0 = 0.2
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r = 3.1; gamma = 2.1; N = 40;
u = zeros(1, N + 1); v = zeros(1, N + 1);
u(1) = 0.5; v(1) = 0.2;                       % MATLAB counts from 1: u(1) is u_0
for k = 1:N
    u(k + 1) = (1 + r) * u(k) - r * u(k)^2 - gamma * u(k) * v(k);
    v(k + 1) = gamma * u(k) * v(k);
end
fprintf('steady state (1/gamma, r(1 - 1/gamma)/gamma) = (%.4f, %.4f)\n', 1/gamma, r * (1 - 1/gamma) / gamma);
fprintf('u_36 ... u_40 = '); fprintf('%.3f  ', u(37:41)); fprintf('\n');

n = 0:N;
subplot(1, 2, 1);
plot(n, u, '--o', 'Color', [0.43 0.04 0.12]); hold on
plot(n, v, '--s', 'Color', [0.89 0.44 0.49]); hold off
xlabel('n'); legend('Prey u_n', 'Predators v_n');
subplot(1, 2, 2);
rot = [linspace(1, 0.43, 64)' linspace(0.85, 0.04, 64)' linspace(0.85, 0.12, 64)'];
colormap(rot); scatter(u, v, 30, n, 'filled'); hold on              % light: early, dark: late
plot(u(1), v(1), 'ko', 'MarkerFaceColor', 'k'); hold off
xlabel('Prey u_n'); ylabel('Predators v_n');
