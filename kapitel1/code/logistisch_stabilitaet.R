# Abb. 1.29: stationäre Zustände des logistischen Modells und ihre Stabilität (Buch, Abschnitt 1.4, Gl. 1.35)
# y*_alpha = 0 und y*_beta = 1 - 1/a (durchgezogen stabil, gestrichelt instabil) mit dem Bifurkationsdiagramm
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
blau <- rgb(0, 0.447, 0.741)
a <- seq(3.0, 4.0, length.out = 1001)   # Bifurkationsdiagramm (hellgrün) für 3 <= a <= 4
y <- rep(0.5, length(a))
for (k in 1:2000) y <- a * y * (1 - y)
A <- c(); Y <- c()
for (k in 1:300) { y <- a * y * (1 - y); A <- c(A, a); Y <- c(Y, y) }
plot(A, Y, pch = ".", col = rgb(0.47, 0.71, 0.47), xlim = c(0, 4), ylim = c(-0.25, 1.05), xlab = "a", ylab = "y")

lines(c(0, 1), c(0, 0), col = blau, lwd = 2); lines(c(1, 4), c(0, 0), lty = 2, col = blau, lwd = 2)   # y*_alpha = 0
aa <- seq(0.8, 1, length.out = 50);  lines(aa, 1 - 1/aa, lty = 2, col = blau, lwd = 2)              # y*_beta = 1 - 1/a
aa <- seq(1, 3, length.out = 200);   lines(aa, 1 - 1/aa, col = blau, lwd = 2)
aa <- seq(3, 4, length.out = 100);   lines(aa, 1 - 1/aa, lty = 2, col = blau, lwd = 2)
abline(v = c(1, 3), lty = 3, col = "grey60")
cat("f'(y) = a (1 - 2y):  f'(0) = a, f'(1 - 1/a) = 2 - a\n")
cat("y*_alpha stabil für a < 1, y*_beta stabil für 1 < a < 3\n")
