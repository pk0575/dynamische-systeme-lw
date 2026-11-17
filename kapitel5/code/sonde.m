% Abb. 5.6: Eine Rhythmusstörung im Modell (Buch, Abschnitt 5.4, Gl. 5.6)
% wie Abb. 5.5 bis t = 3000 ms; Verlauf von v im Punkt (25, 25) mm, Abstände, Dauer und diastolische Intervalle der Aktionspotentiale
% Die Rechnung dauert etwa zehn Minuten.
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;   % Parameter in ms
D = 0.1; dx = 0.25; dt = 0.05; Lq = 100;                        % mm^2/ms, mm, ms, Seitenlänge in mm
N = round(Lq / dx); xs = dx * ((1:N) - 0.5);
[X, Y] = ndgrid(xs, xs);
S1 = X <= 1; S2 = Y <= Lq / 2;
i0 = floor(25 / dx) + 1;                                        % Gitterpunkt bei (25, 25) mm
v = zeros(N); h = ones(N); r = [1 1:N N];
K = round(3000 / dt); spur = zeros(1, K);
for n = 0:K-1
    t = n * dt;
    vp = v(r, r);
    lap = vp(3:end, 2:end-1) + vp(1:end-2, 2:end-1) + vp(2:end-1, 3:end) + vp(2:end-1, 1:end-2) - 4 * v;
    dv = h .* v.^2 .* (1 - v) / tin - v / tout + D * lap / dx^2;
    if t < 2, dv(S1) = dv(S1) + 0.2; end
    if t >= 380 && t < 382, dv(S2) = dv(S2) + 0.2; end
    dh = (v < vgate) .* (1 - h) / topen - (v >= vgate) .* h / tclose;
    v = v + dt * dv; h = h + dt * dh;
    spur(n + 1) = v(i0, i0);
end
ts = dt * (1:K);
akt = ts([false, spur(2:end) > 0.5 & spur(1:end-1) <= 0.5]);    % v steigt über 0.5
auf = ts([false, spur(2:end) > 0.1 & spur(1:end-1) <= 0.1]); ab = ts([false, spur(2:end) < 0.1 & spur(1:end-1) >= 0.1]);
m = min(numel(auf), numel(ab)); apd = ab(1:m) - auf(1:m); di = auf(2:numel(auf)) - ab(1:numel(auf)-1);
abst = diff(akt);
fprintf('Abstände der Aktionspotentiale (ms): [%s]\n', strtrim(sprintf(' %.1f', abst)));
fprintf('ab dem 4. Abstand: Mittel %.0f ms,  APD im Mittel %.0f ms,  DI im Mittel %.0f ms\n', mean(abst(4:end)), mean(apd(5:end)), mean(di(5:end)));
plot(ts, spur, 'Color', [0.64 0.08 0.18], 'LineWidth', 1.5);
xlabel('t (ms)'); ylabel('v bei (25, 25) mm');
