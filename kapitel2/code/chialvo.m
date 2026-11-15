% Abb. 2.19: Aktionspotentiale im Chialvo-Modell (Buch, Abschnitt 2.5, Gl. 2.33)
% y1_{n+1} = y1_n^2 exp(y2_n - y1_n) + k,  y2_{n+1} = a y2_n - b y1_n + c  mit a = 0.89, c = 0.28, k = 0.03
% links b = 0.26 (regelmäßig), rechts b = 0.18 (chaotisch, frühe Nachdepolarisationen); oben y1, unten y2
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a = 0.89; c = 0.28; k = 0.03; N = 150;
bs = [0.26 0.18];
for sp = 1:2
    b = bs(sp);
    y1 = zeros(1, N + 1); y2 = zeros(1, N + 1);
    y1(1) = 0.2; y2(1) = c / (1 - a);
    for j = 1:N
        y1(j + 1) = y1(j)^2 * exp(y2(j) - y1(j)) + k;
        y2(j + 1) = a * y2(j) - b * y1(j) + c;
    end
    ap = sum(y1(2:end) > 1 & y1(1:end-1) <= 1);        % Anzahl der Ausschläge über 1
    fprintf('b = %g: %d Aktionspotentiale in %d Schritten, max y1 = %.2f\n', b, ap, N, max(y1));
    subplot(2, 2, sp);
    plot(0:N, y1, 'o--', 'MarkerSize', 2, 'Color', [0.64 0.08 0.18]); title(sprintf('b = %g', b));
    if sp == 1, ylabel('y_{1,n}'); end
    subplot(2, 2, sp + 2);
    plot(0:N, y2, 'o--', 'MarkerSize', 2, 'Color', [0.89 0.44 0.49]); xlabel('n');
    if sp == 1, ylabel('y_{2,n}'); end
end
