% Abb. 1.12: Aktualisierungsfunktionen und Treppendiagramme (Buch, Abschnitt 1.2)
% links: arithmetische Folge f(x) = x + 2 mit x_0 = 20;  rechts: geometrische Folge f(x) = a x mit a = 1.2 und 0.5, x_0 = 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
blau = [0 0.447 0.741]; hellblau = [0.45 0.70 0.90];
rot = [0.64 0.08 0.18]; hellrot = [0.89 0.44 0.49];

subplot(1, 2, 1); hold on
plot([18 33], [20 35], 'Color', blau);
plot([18 33], [18 33], 'k-');
x = zeros(1, 7); x(1) = 20;
for k = 1:6
    x(k + 1) = x(k) + 2;
end
px = x(1); py = 0;
for k = 1:6
    px = [px x(k) x(k + 1)]; py = [py x(k + 1) x(k + 1)];
end
plot(px, py, '--', 'Color', rot);
fprintf('arithmetisch: '); fprintf('%g  ', x); fprintf('\n');
hold off; axis([18 33 18 33]); xlabel('x'); ylabel('f(x)'); legend('f(x) = x + 2', 'y = x', 'Location', 'southeast');

subplot(1, 2, 2); hold on
as = [1.2 0.5]; schritte = [5 4]; farbeF = [blau; hellblau]; farbeT = [rot; hellrot];
for i = 1:2
    a = as(i); N = schritte(i);
    plot([0 2.6], [0 a * 2.6], 'Color', farbeF(i, :));
    x = zeros(1, N + 1); x(1) = 1;
    for k = 1:N
        x(k + 1) = a * x(k);
    end
    px = x(1); py = 0;
    for k = 1:N
        px = [px x(k) x(k + 1)]; py = [py x(k + 1) x(k + 1)];
    end
    plot(px, py, '--', 'Color', farbeT(i, :));
    fprintf('geometrisch a = %g: ', a); fprintf('%.4f ', x); fprintf('\n');
end
plot([0 2.6], [0 2.6], 'k-');
hold off; axis([0 2.6 0 2.6]); xlabel('x'); ylabel('f(x)');
