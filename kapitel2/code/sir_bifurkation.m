% Abb. 2.17: stationäre Werte I* des SIR-Modells in Abhängigkeit von R_0 (Buch, Abschnitt 2.4, Gl. 2.30)
% x_a*: I* = 0, stabil für R_0 < 1;  x_b*: I* = alpha N (1 - 1/R_0)/(gamma + alpha), stabil für R_0 > 1 (alpha = gamma = 0.1)
% (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N = 100000; alpha = 0.1; gamma = 0.1;
R0 = linspace(0.01, 5, 500);
Ib = alpha * N * (1 - 1 ./ R0) / (gamma + alpha);
gruen = [0 0.39 0];
li = R0 <= 1; re = R0 >= 1; nah = R0 > 0.85 & R0 <= 1;
plot(R0(li), 0 * R0(li), 'Color', gruen, 'LineWidth', 3); hold on       % stabil
plot(R0(re), 0 * R0(re), '--', 'Color', gruen, 'LineWidth', 2)          % instabil
plot(R0(re), Ib(re), 'Color', gruen, 'LineWidth', 3)
plot(R0(nah), Ib(nah), '--', 'Color', gruen, 'LineWidth', 2)
r = [0.6 3.8]; namen = 'AB';
for j = 1:2
    if r(j) < 1, i = 0; else, i = alpha * N * (1 - 1 / r(j)) / (gamma + alpha); end
    plot(r(j), i, 'ko', 'MarkerFaceColor', 'k'); text(r(j), i + 2000, namen(j));
    fprintf('Szenario %s: R_0 = %g,  I* = %.0f\n', namen(j), r(j), i);
end
plot([1 1], [-6000 52000], 'k:'); hold off
ylim([-6000 52000]); xlabel('R_0'); ylabel('I*');
