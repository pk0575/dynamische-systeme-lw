% Abb. 1.38: Aktionspotentiale bei periodischer Anregung (Buch, Abschnitt 1.6)
% Mitchell-Schaeffer-Modell (zwei Ströme), Euler-Verfahren mit dt = 0.01 ms, Reiz alle PCL = 400 ms;
% gemessen wird die Zeit oberhalb des Referenzwerts 0.1 (Aktionspotentialdauer APD) und darunter (diastolisches Intervall DI)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin = 0.3; tout = 6; topen = 100; tclose = 115; vgate = 0.13;    % Zeitkonstanten in ms
PCL = 400; T = 2050; dt = 0.01; vref = 0.1;

t = 0:dt:T - dt;
v = zeros(size(t));
vv = 0; h = 1;
for i = 2:numel(t)
    if mod(t(i), PCL) < 2                % Reiz: 2 ms lang
        J = 0.2;
    else
        J = 0;
    end
    dv = h * vv^2 * (1 - vv) / tin - vv / tout + J;
    if vv < vgate
        dh = (1 - h) / topen;
    else
        dh = -h / tclose;
    end
    vv = vv + dt * dv;
    h = h + dt * dh;
    v(i) = vv;
end

s = sign(v - vref);                      % Durchgänge durch den Referenzwert
kreuz = t(find(diff(s) ~= 0));
auf = kreuz(1:2:end); ab = kreuz(2:2:end);
for k = 1:numel(ab)
    if k < numel(auf)
        fprintf('AP %d:  APD = %6.1f ms,  DI = %6.1f ms\n', k, ab(k) - auf(k), auf(k + 1) - ab(k));
    else
        fprintf('AP %d:  APD = %6.1f ms\n', k, ab(k) - auf(k));
    end
end

plot(t, v, 'Color', [0.64 0.08 0.18]); hold on
plot([0 T], [vref vref], ':', 'Color', [0.35 0.35 0.35]); hold off
xlabel('t (ms)'); ylabel('v (dimensionslos)');
