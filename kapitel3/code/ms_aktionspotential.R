# Abb. 3.24: Aktionspotential des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.29 und 3.30)
# Reiz bei t = 0; links v(t) und h(t), rechts stationäre Zustände von v in Abhängigkeit von h und der Weg des Aktionspotentials
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # Parameter in ms
hc <- 4 * tin / tout

simuliere <- function(T, reize, J = 0.2, dauer = 2, dt = 0.01, h_fest = FALSE) {
  # Euler-Verfahren für das Mitchell-Schaeffer-Modell; Reizstrom J für 'dauer' ms ab jedem Zeitpunkt in 'reize'
  N <- round(T / dt); t <- dt * (0:N)
  Jt <- numeric(N + 1)
  for (s in reize) Jt[t >= s - 1e-9 & t < s + dauer - 1e-9] <- J
  v <- numeric(N + 1); h <- rep(1, N + 1)
  for (n in 1:N) {
    dv <- h[n] * v[n]^2 * (1 - v[n]) / tin - v[n] / tout + Jt[n]
    dh <- if (h_fest) 0 else if (v[n] < vgate) (1 - h[n]) / topen else -h[n] / tclose
    v[n + 1] <- v[n] + dt * dv; h[n + 1] <- h[n] + dt * dh
  }
  list(t = t, v = v, h = h)
}
durchgaenge <- function(t, v, schwelle = 0.1) t[which(diff(sign(v - schwelle)) != 0)]   # Beginn und Ende der Aktionspotentiale

x <- simuliere(500, 0)
d <- durchgaenge(x$t, x$v); apd <- d[2] - d[1]
tf <- tclose * log(1 / hc)
cat(sprintf("APD = %.1f ms,  h = h_c nach tclose ln(1/h_c) = %.1f ms\n", apd, tf))
par(mfrow = c(1, 2))
plot(x$t, x$v, type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0, 1), xlab = "t (ms)", ylab = "")
lines(x$t, x$h, col = rgb(0.89, 0.44, 0.49), lwd = 2)
abline(h = hc, lty = 3); abline(v = tf, lty = 4)
legend("topright", legend = c("v(t)", "h(t)"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lwd = 2)
gruen <- rgb(0, 0.39, 0)
H <- seq(hc, 1.05, length.out = 400); W <- sqrt(1 - hc / H)
plot(H, (1 + W) / 2, type = "l", col = gruen, lwd = 2.5, xlim = c(0, 1.05), ylim = c(0, 1), xlab = "h", ylab = "v*")
lines(H, (1 - W) / 2, lty = 2, col = gruen, lwd = 2.5); lines(c(0, 1.05), c(0, 0), col = gruen, lwd = 2.5)
lines(x$h, x$v, col = rgb(0.64, 0.08, 0.18), lwd = 1.5)
legend("right", legend = c("stabil", "instabil", "Aktionspotential"), col = c(gruen, gruen, rgb(0.64, 0.08, 0.18)), lty = c(1, 2, 1), lwd = 2)
