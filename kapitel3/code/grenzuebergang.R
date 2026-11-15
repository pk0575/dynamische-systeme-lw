# Abb. 3.1: vom zeitdiskreten zum kontinuierlichen Wachstum (Buch, Abschnitt 3.1, Gl. 3.1 und 3.2)
# x(t + dt) = (1 + r dt) x(t) mit r = 0.5, x(0) = 1 für dt = 1, 0.5, 0.1; für dt -> 0 entsteht x(t) = e^(r t)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
r <- 0.5
rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)); zeichen <- c(16, 15, 17)
plot(NULL, xlim = c(0, 4), ylim = c(1, 7.5), xlab = "t", ylab = "x")
dts <- c(1, 0.5, 0.1)
for (i in 1:3) {
  dt <- dts[i]
  n <- 0:round(4 / dt)
  x <- (1 + r * dt)^n                    # Lösung der Differenzengleichung
  points(n * dt, x, pch = zeichen[i], col = rot[i], cex = c(1.4, 1.1, 0.7)[i])
  cat(sprintf("dt = %g: x(4) = %.4f\n", dt, x[length(x)]))
}
t <- seq(0, 4, length.out = 300)
lines(t, exp(r * t), col = rot[1], lwd = 2)
cat(sprintf("e^(0.5*4) = %.4f\n", exp(2)))
legend("topleft", legend = c(sprintf("Delta t = %g", dts), "x(t) = e^(rt)"), col = c(rot, rot[1]), pch = c(zeichen, NA), lwd = c(NA, NA, NA, 2))
