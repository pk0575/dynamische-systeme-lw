% Abb. 4.24: Phasenebene des Mitchell-Schaeffer-Modells (Buch, Abschnitt 4.5, Gl. 4.20)
% dv/dt = h v^2 (1 - v)/tin - v/tout + J0,  dh/dt = (1 - h)/topen für v < vgate, -h/tclose sonst;  J0 = 0
% Nullklinen, Richtungsfeld, Ruhezustand (1, 0), Schwelle und das Aktionspotential nach einem Reiz bei t = 1 ms
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % Parameter in ms
hc = 4 * tin / tout;
J = 0.2; dauer = 2; dt = 0.01;
J0 = 0; T = 500; reize = 1;
N = round(T / dt); t = dt * (0:N);
Jt = J0 * ones(1, N + 1);
for s = reize
    Jt(t >= s - 1e-9 & t < s + dauer - 1e-9) = J0 + J;   % Reiz der Stärke J für 'dauer' ms
end
v = zeros(1, N + 1); h = ones(1, N + 1);
for n = 1:N                                         % Euler-Verfahren
    dv = h(n) * v(n)^2 * (1 - v(n)) / tin - v(n) / tout + Jt(n);
    if v(n) < vgate, dh = (1 - h(n)) / topen; else, dh = -h(n) / tclose; end
    v(n + 1) = v(n) + dt * dv; h(n + 1) = h(n) + dt * dh;
end
vs = (1 - sqrt(1 - hc)) / 2;
fprintf('Ruhezustand (h, v) = (1, 0),  Schwelle (1, %.4f),  Spitze des Aktionspotentials v = %.4f\n', vs, max(v));
fprintf('nach 500 ms: (h, v) = (%.4f, %.4f)\n', h(end), v(end));
% Richtungsfeld (Pfeile gleicher Länge) und Nullklinen
[hg, vg] = meshgrid(linspace(0.05, 1.05, 12), linspace(0.05, 1.0, 11));
dvg = hg .* vg.^2 .* (1 - vg) / tin - vg / tout + J0;
dhg = (vg < vgate) .* (1 - hg) / topen - (vg >= vgate) .* hg / tclose;
L = sqrt(dvg.^2 + dhg.^2);
quiver(hg, vg, dhg ./ L, dvg ./ L, 0.4, 'Color', [0.2 0.6 0.25]); hold on
vv = linspace(0.003, 0.997, 2000);
H = (vv / tout - J0) ./ (vv.^2 .* (1 - vv) / tin);      % dv/dt = 0 nach h aufgelöst
m = H >= -0.05 & H <= 1.1;
plot(H(m), vv(m), 'Color', [0 0.447 0.741], 'LineWidth', 2.5);
if J0 == 0, plot([-0.05 1.1], [0 0], 'Color', [0 0.447 0.741], 'LineWidth', 2.5); end
plot([1 1], [-0.05 vgate], 'Color', [0.45 0.70 0.90], 'LineWidth', 2.5);
plot([0 0], [vgate 1.05], 'Color', [0.45 0.70 0.90], 'LineWidth', 2.5);
plot(h, v, 'Color', [0.64 0.08 0.18], 'LineWidth', 2);
plot(1, 0, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 9); plot(1, vs, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 9); hold off
xlim([-0.05 1.1]); ylim([-0.05 1.05]); xlabel('h'); ylabel('v');
