% Abb. 3.22: Euler-Verfahren mit zu großer Schrittweite (Buch, Abschnitt 3.4, Gl. 3.27)
% T_{n+1} - 5 = (1 - k h)(T_n - 5): für h = 40 ist der Faktor -0.2 (gedämpfte Schwingung), für h = 70 ist er -1.1 (Aufschaukeln)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
k = 0.03; Tu = 5; T0 = 80;
tt = linspace(0, 700, 400); hs = [40 70];
for i = 1:2
    h = hs(i);
    N = ceil(700 / h);
    t = h * (0:N); T = zeros(1, N + 1); T(1) = T0;
    for n = 1:N
        T(n + 1) = T(n) + h * k * (Tu - T(n));
    end
    subplot(1, 2, i);
    plot(tt, Tu + (T0 - Tu) * exp(-k * tt), 'Color', [0.43 0.04 0.12], 'LineWidth', 2); hold on
    plot(t, T, '--o', 'Color', [0.89 0.44 0.49], 'MarkerSize', 5);
    plot([0 700], [Tu Tu], 'k:'); hold off
    title(sprintf('h = %d: Faktor 1 - kh = %.1f', h, 1 - k * h)); xlabel('t (min)');
    if h == 70, ylim([-250 250]); end
    fprintf('h = %d: T_1 ... T_4 = %s\n', h, sprintf('%.2f  ', T(2:5)));
end
