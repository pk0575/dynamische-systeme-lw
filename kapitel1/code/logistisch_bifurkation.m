% Abb. 1.23: Bifurkationsdiagramm des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.28)
% y_{n+1} = a y_n (1 - y_n): für jeden Wert von a wird nach n_* = 10000 Schritten das Langzeitverhalten gezeichnet
% oben: 2.8 <= a <= 4;  unten: Ausschnitt 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (das Muster kehrt wieder)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
gruen = [0 0.39 0];
bereiche = {linspace(2.8, 4.0, 2401), linspace(3.8538, 3.8541, 1501)};
behalten = [200 6000];
fenster = [0 1; 0.494 0.506];
for p = 1:2
    a = bereiche{p};
    y = 0.9 * ones(size(a));             % alle Parameterwerte gleichzeitig (Vektor)
    for k = 1:10000                      % Einschwingen
        y = a .* y .* (1 - y);
    end
    A = []; Y = [];
    for k = 1:behalten(p)                % Langzeitverhalten sammeln
        y = a .* y .* (1 - y);
        m = (y > fenster(p, 1)) & (y < fenster(p, 2));
        A = [A a(m)]; Y = [Y y(m)];
    end
    subplot(2, 1, p);
    plot(A, Y, '.', 'Color', gruen, 'MarkerSize', 1);
    xlabel('a'); ylabel('y_n für n > 10000');
end

a = 3.2; y = 0.9;                        % Beispiel a = 3.2: zwei Werte wechseln sich ab (2-Zyklus)
for k = 1:10000
    y = a * y * (1 - y);
end
fprintf('a = 3.2:  2-Zyklus %.4f <-> %.4f\n', y, a * y * (1 - y));
