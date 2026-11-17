% Fig. 2.16: Scenario B of the SIR model in the phase plane (book, Section 2.4, Eq. 2.21)
% states (S_n, I_n), light: early, dark: late; cross: steady state x_b* = (N/R_0, alpha (N - S*)/(gamma + alpha))
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N = 100000; alpha = 0.1; gamma = 0.1; beta = 7.6e-6;
M = 80;
S = zeros(1, M + 1); I = zeros(1, M + 1);
S(1) = 99999; I(1) = 1;
for k = 1:M
    S(k + 1) = S(k) - beta * S(k) * I(k) + alpha * (N - S(k));
    I(k + 1) = I(k) + beta * S(k) * I(k) - (gamma + alpha) * I(k);
end
R0 = beta * N / (gamma + alpha);
Ss = N / R0; Is = alpha * (N - Ss) / (gamma + alpha);
fprintf('R_0 = %.1f,  steady state x_b*: S* = %.0f, I* = %.0f\n', R0, Ss, Is);
fprintf('(S_80, I_80) = (%.0f, %.0f)\n', S(end), I(end));

plot(S, I, 'Color', [0.75 0.75 0.75]); hold on
rot = [linspace(1, 0.43, 64)' linspace(0.85, 0.04, 64)' linspace(0.85, 0.12, 64)'];
colormap(rot); scatter(S, I, 30, 0:M, 'filled');      % light: early, dark: late
plot(Ss, Is, 'kx', 'MarkerSize', 12, 'LineWidth', 2);
plot(N, 0, 'ko', 'MarkerFaceColor', 'w'); hold off   % x_a* = (N, 0): disease-free
xlabel('S_n'); ylabel('I_n');
