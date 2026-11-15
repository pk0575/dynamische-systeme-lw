% Abb. 1.34: Newton-Verfahren ohne Konvergenz (Buch, Abschnitt 1.5, Gl. 1.44)
% g(x) = x^3 - 2x + 2 mit x_0 = 0: die Näherungen springen zwischen 0 und 1, die Nullstelle bei -1.769 wird nicht gefunden
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
g = @(x) x.^3 - 2 * x + 2;
dg = @(x) 3 * x.^2 - 2;

x = zeros(1, 7);
for k = 1:6
    x(k + 1) = x(k) - g(x(k)) / dg(x(k));
end
fprintf('x_0 ... x_6 = '); fprintf('%g  ', x); fprintf('\n');

xs = -1;                                 % mit einem besseren Startwert klappt es
for k = 1:8
    xs = xs - g(xs) / dg(xs);
end
fprintf('Start bei -1: Nullstelle x* = %.6f\n', xs);

xx = linspace(-2.2, 1.8, 400);
plot(xx, g(xx), 'Color', [0 0.447 0.741]); hold on
plot([-2.2 1.8], [0 0], 'k-');
zz = linspace(-0.6, 1.6, 10);
for a = [0 1]                            % die beiden Tangenten
    plot(zz, g(a) + dg(a) * (zz - a), 'k-');
end
plot([0 1], [0 0], 'o', 'Color', [0.64 0.08 0.18], 'MarkerFaceColor', [0.64 0.08 0.18]);
plot(xs, 0, 'ko', 'MarkerFaceColor', 'k');
hold off; ylim([-2.2 4.5]); xlabel('x');
