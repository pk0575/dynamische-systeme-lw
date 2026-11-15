% Abb. 4.23: Membranpotential im Noble-Modell (Buch, Abschnitt 4.4, Gl. 4.19)
% Cm dV/dt = -(400 m^3 h + 0.14)(V - 40) - (1.2 e^((-V-90)/50) + 0.015 e^((V+90)/60) + 1.2 n^4)(V + 100) - gL (V - VL) + I(t), Cm = 12
% links Schrittmacherzelle (gL = 0.075, VL = -60), rechts erregbare Zelle (gL = 0.3, VL = -85) mit Reizen alle 700 ms; Zeit in ms
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
namen = {'Schrittmacher', 'gereizt'};
gLs = [0.075 0.3]; VLs = [-60 -85]; reiz = [false true]; T0s = [2000 0];
opt = odeset('RelTol', 1e-8, 'AbsTol', 1e-10, 'MaxStep', 0.25);
for j = 1:2
    gL = gLs(j); VL = VLs(j); mitReiz = reiz(j);
    % z = (V, m, h, n); Raten alpha und beta der Kanäle
    am = @(V) 0.1 * (-V - 48) / (exp((-V - 48) / 15) - 1);   bm = @(V) 0.12 * (V + 8) / (exp((V + 8) / 5) - 1);
    ah = @(V) 0.17 * exp((-V - 90) / 20);                    bh = @(V) 1 / (1 + exp((-V - 42) / 10));
    an = @(V) 0.0001 * (-V - 50) / (exp((-V - 50) / 10) - 1); bn = @(V) 0.002 * exp((-V - 90) / 80);
    iNa = @(z) (400 * z(2)^3 * z(3) + 0.14) * (z(1) - 40);
    iK = @(z) (1.2 * exp((-z(1) - 90) / 50) + 0.015 * exp((z(1) + 90) / 60) + 1.2 * z(4)^4) * (z(1) + 100);
    I = @(t) 300 * (mitReiz && mod(t, 700) < 2);              % Reiz: 2 ms lang alle 700 ms
    f = @(t, z) [(-(iNa(z) + iK(z) + gL * (z(1) - VL)) + I(t)) / 12;
                 am(z(1)) * (1 - z(2)) - bm(z(1)) * z(2);
                 ah(z(1)) * (1 - z(3)) - bh(z(1)) * z(3);
                 an(z(1)) * (1 - z(4)) - bn(z(1)) * z(4)];
    T = T0s(j) + 2100;
    [t, z] = ode15s(f, 0:0.1:T, [-80; 0.02; 0.8; 0.05], opt);
    i = t >= T0s(j); tt = (t(i) - T0s(j)) / 1000; V = z(i, 1);
    hoch = tt(find(V(1:end-1) < 0 & V(2:end) >= 0) + 1);      % Zeitpunkte, an denen V von unten 0 mV erreicht
    txt = sprintf('%s: V zwischen %.0f und %.0f mV, %d Aktionspotentiale in 2.1 s', namen{j}, min(V), max(V), numel(hoch));
    if numel(hoch) > 1, txt = [txt sprintf(', Periode %.2f s', mean(diff(hoch)))]; end
    fprintf('%s\n', txt);
    subplot(1, 2, j);
    plot(tt, V, 'Color', [0.64 0.08 0.18], 'LineWidth', 2); title(namen{j}); xlabel('t (s)');
    if j == 1, ylabel('Membranpotential V (mV)'); end
end
