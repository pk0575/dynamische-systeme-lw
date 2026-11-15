% Abb. 3.21: Euler-Verfahren für die Abkühlung mit verschiedenen Schrittweiten (Buch, Abschnitt 3.4, Gl. 3.26)
% dT/dt = 0.03 (5 - T), T(0) = 80; Euler mit h = 10 und h = 5 im Vergleich zur exakten Lösung
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
k = 0.03; Tu = 5; T0 = 80;
exakt = @(t) Tu + (T0 - Tu) * exp(-k * t);
tt = linspace(0, 120, 300);
plot(tt, exakt(tt), 'Color', [0.43 0.04 0.12], 'LineWidth', 2, 'DisplayName', 'exakt'); hold on
farben = [0.64 0.08 0.18; 0.89 0.44 0.49]; marker = 'sd'; hs = [10 5];
for i = 1:2
    h = hs(i); N = 120 / h;
    t = h * (0:N); T = zeros(1, N + 1); T(1) = T0;
    for n = 1:N
        T(n + 1) = T(n) + h * k * (Tu - T(n));
    end
    plot(t, T, ['--' marker(i)], 'Color', farben(i, :), 'MarkerSize', 6, 'DisplayName', sprintf('Euler, h = %d', h));
    fprintf('h = %2d: T(60) ≈ %.3f,  Fehler %.3f\n', h, T(60 / h + 1), abs(T(60 / h + 1) - exakt(60)));
end
hold off
xlabel('t (min)'); ylabel('T (°C)'); legend('show');
