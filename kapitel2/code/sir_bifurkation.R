# Abb. 2.17: stationäre Werte I* des SIR-Modells in Abhängigkeit von R_0 (Buch, Abschnitt 2.4, Gl. 2.30)
# x_a*: I* = 0, stabil für R_0 < 1;  x_b*: I* = alpha N (1 - 1/R_0)/(gamma + alpha), stabil für R_0 > 1 (alpha = gamma = 0.1)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
N <- 100000; alpha <- 0.1; gamma <- 0.1
R0 <- seq(0.01, 5, length.out = 500)
Ib <- alpha * N * (1 - 1 / R0) / (gamma + alpha)
gruen <- rgb(0, 0.39, 0)
li <- R0 <= 1; re <- R0 >= 1; nah <- R0 > 0.85 & R0 <= 1
plot(R0[li], 0 * R0[li], type = "l", col = gruen, lwd = 3, xlim = c(0, 5), ylim = c(-6000, 52000), xlab = "R_0", ylab = "I*")   # stabil
lines(R0[re], 0 * R0[re], lty = 2, col = gruen, lwd = 2)          # instabil
lines(R0[re], Ib[re], col = gruen, lwd = 3)
lines(R0[nah], Ib[nah], lty = 2, col = gruen, lwd = 2)
for (sz in list(list(0.6, "A"), list(3.8, "B"))) {
  r <- sz[[1]]; i <- if (r < 1) 0 else alpha * N * (1 - 1 / r) / (gamma + alpha)
  points(r, i, pch = 16); text(r, i + 2500, sz[[2]])
  cat(sprintf("Szenario %s: R_0 = %g,  I* = %.0f\n", sz[[2]], r, i))
}
abline(v = 1, lty = 3)
