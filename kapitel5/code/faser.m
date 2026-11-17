% Abb. 5.2: Ein Puls auf der Faser (Buch, Abschnitt 5.2, Gl. 5.2)
% Kabelgleichung mit dem Mitchell-Schaeffer-Modell, Faser 150 mm, Reiz am linken Ende; Linienmethode mit dem Euler-Verfahren
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % Parameter in ms
D = 0.1; dx = 0.1; dt = 0.01;                                   % D in mm^2/ms, Gitterabstand in mm, Zeitschritt in ms
L = 150; T = 500;
N = round(L / dx) + 1; x = dx * (0:N-1);
v = zeros(1, N); h = ones(1, N);
reiz = x <= 1;                                                  % Reiz J = 0.2 auf dem ersten Millimeter für 2 ms
schnapp = zeros(3, N); zeiten = [100 250 400];
K = round(T / dt); s25 = zeros(1, K); s75 = zeros(1, K); t_akt = nan(1, N);
for n = 0:K-1
    t = n * dt;
    j = find(abs(zeiten - t) < 1e-6); if ~isempty(j), schnapp(j, :) = v; end
    lap = [v(2) - v(1), v(3:end) - 2 * v(2:end-1) + v(1:end-2), v(end-1) - v(end)];   % Rand ohne Fluss
    dv = h .* v.^2 .* (1 - v) / tin - v / tout + D * lap / dx^2;
    if t < 2, dv(reiz) = dv(reiz) + 0.2; end
    dh = (v < vgate) .* (1 - h) / topen - (v >= vgate) .* h / tclose;
    v = v + dt * dv; h = h + dt * dh;
    neu = isnan(t_akt) & v > 0.5; t_akt(neu) = t + dt;          % Zeitpunkt, an dem v erstmals 0.5 erreicht
    s25(n + 1) = v(251); s75(n + 1) = v(751);
end
c = (x(751) - x(251)) / (t_akt(751) - t_akt(251));
ts = dt * (1:K); a = ts(s75 > 0.1); apd = a(end) - a(1);
fprintf('v = 0.5 bei x = 25 mm nach %.1f ms, bei x = 75 mm nach %.1f ms\n', t_akt(251), t_akt(751));
fprintf('Leitungsgeschwindigkeit c = %.4f mm/ms,  APD = %.1f ms,  Wellenlänge c APD = %.1f mm\n', c, apd, c * apd);
farben = [0.89 0.44 0.49; 0.64 0.08 0.18; 0.43 0.04 0.12];
subplot(1, 2, 1); hold on
for j = 1:3, plot(x, schnapp(j, :), 'Color', farben(j, :), 'LineWidth', 2); end
hold off; xlabel('x (mm)'); ylabel('v(x, t)'); legend('t = 100 ms', 't = 250 ms', 't = 400 ms');
subplot(1, 2, 2);
plot(ts, s25, 'Color', farben(3, :), 'LineWidth', 2); hold on
plot(ts, s75, 'Color', farben(1, :), 'LineWidth', 2); hold off
xlabel('t (ms)'); ylabel('v(x, t)'); legend('x = 25 mm', 'x = 75 mm');
