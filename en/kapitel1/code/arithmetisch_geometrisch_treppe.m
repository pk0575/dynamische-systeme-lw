% Fig. 1.12: Update functions and staircase diagrams (book, Section 1.2)
% left: arithmetic sequence f(x) = x + 2 with x_0 = 20;  right: geometric sequence f(x) = a x with a = 1.2 and 0.5, x_0 = 1
% (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
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
fprintf('arithmetic: '); fprintf('%g  ', x); fprintf('\n');
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
    fprintf('geometric a = %g: ', a); fprintf('%.4f ', x); fprintf('\n');
end
plot([0 2.6], [0 2.6], 'k-');
hold off; axis([0 2.6 0 2.6]); xlabel('x'); ylabel('f(x)');
