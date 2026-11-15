% Abb. 1.11: arithmetische und geometrische Folge (Buch, Abschnitt 1.2, Gl. 1.11 und 1.13)
% oben: x_{n+1} = x_n + b mit x_0 = 20;  unten: x_{n+1} = a x_n mit x_0 = 1
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
rot = [0.43 0.04 0.12; 0.64 0.08 0.18; 0.89 0.44 0.49];   % Rottöne für mehrere Folgen
marker = 'osd';

subplot(2, 1, 1); hold on
n = 0:10; bs = [2 1 -1];
for i = 1:3
    x = 20 + bs(i) * n;                  % Lösungsformel (1.12)
    plot(n, x, ['--' marker(i)], 'Color', rot(i, :), 'DisplayName', sprintf('b = %g', bs(i)));
    fprintf('b = %g:  x_10 = %g\n', bs(i), x(end));
end
hold off; xlabel('n'); ylabel('x_n'); legend('show');

subplot(2, 1, 2); hold on
n = 0:5; as = [1.2 1.01 0.5];
for i = 1:3
    x = as(i) .^ n;                      % Lösungsformel (1.14) mit x_0 = 1
    plot(n, x, ['--' marker(i)], 'Color', rot(i, :), 'DisplayName', sprintf('a = %g', as(i)));
    fprintf('a = %g:  x_5 = %.4f\n', as(i), x(end));
end
hold off; xlabel('n'); ylabel('x_n'); legend('show');
