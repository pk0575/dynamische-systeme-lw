# Abb. 3.3: Lösungsschar einer linearen Differentialgleichung (Buch, Abschnitt 3.1, Gl. 3.6 und 3.7)
# dx/dt = a x + b mit a = -0.5, b = 1; Lösungen x(t) = C e^(at) - b/a für verschiedene Startwerte, x* = -b/a = 2
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
a <- -0.5; b <- 1
xs <- -b / a                             # konstante Lösung
t <- seq(0, 8, length.out = 400)
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49))
plot(NULL, xlim = c(0, 8), ylim = c(-0.25, 5.25), xlab = "t", ylab = "x(t)", main = "schwarz: x* = -b/a = 2")
x0s <- c(5, 3.5, 2.5, 1, 0)
for (i in seq_along(x0s)) {
  C <- x0s[i] - xs
  lines(t, C * exp(a * t) + xs, col = rot[(i - 1) %% 3 + 1], lwd = 2)
  cat(sprintf("x(0) = %g: C = %4.1f, x(8) = %.4f\n", x0s[i], C, C * exp(8 * a) + xs))
}
abline(h = xs, lwd = 1.5)
