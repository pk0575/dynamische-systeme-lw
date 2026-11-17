% Fig. 3.5: Direction field of cooling with some solutions (book, Section 3.1, Eq. 3.3)
% At each point (t, T) a short dash shows the slope dT/dt = 0.03 (5 - T); the solutions follow these slopes
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
k = 0.03; Tu = 5;
[t, T] = meshgrid(linspace(5, 175, 18), linspace(2, 88, 12));
S = k * (Tu - T);                                        % slope dT/dt at each point
dt = 4 ./ sqrt(1 + (S * 180 / 90).^2);                   % dashes of equal length in the plot
plot([t(:) - dt(:) t(:) + dt(:)]', [T(:) - S(:) .* dt(:) T(:) + S(:) .* dt(:)]', 'Color', [0.2 0.6 0.25]); hold on
tt = linspace(0, 180, 300);
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49]; T0s = [80 40 0];
for i = 1:3
    plot(tt, Tu + (T0s(i) - Tu) * exp(-k * tt), 'Color', rot(i, :), 'LineWidth', 2);
    fprintf('T(0) = %2d: T(60) = %.2f\n', T0s(i), Tu + (T0s(i) - Tu) * exp(-60 * k));
end
plot([0 184], [Tu Tu], 'k--'); hold off
xlabel('t (min)'); ylabel('T (°C)'); xlim([0 184]); ylim([-3 92]);
