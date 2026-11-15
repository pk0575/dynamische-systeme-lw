# Abb. 3.23: schnelle Dynamik des Mitchell-Schaeffer-Modells (Buch, Abschnitt 3.5, Gl. 3.29 und 3.31)
# dv/dt = h v^2 (1 - v)/tin - v/tout + J(t) mit festem h = 1; links f(v) mit Ruhe, Schwelle und erregtem Zustand,
# rechts Antwort auf einen Reiz der Dauer 2 ms unter (J = 0.02) und über (J = 0.04) der Schwelle
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

f <- function(v) v^2 * (1 - v) / tin - v / tout
w <- sqrt(1 - hc); vs <- (1 - w) / 2; ve <- (1 + w) / 2   # Schwelle und erregter Zustand
cat(sprintf("h_c = %.2f,  Schwelle v_s* = %.4f,  erregt v_e* = %.4f\n", hc, vs, ve))
par(mfrow = c(1, 2))
v <- seq(-0.05, 1.05, length.out = 500)
plot(v, f(v), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2.5, xlab = "v", ylab = "")
abline(h = 0); points(c(0, ve), c(0, 0), pch = 16); points(vs, 0, pch = 21, bg = "white")
legend("topleft", legend = "f(v), h = 1", col = rgb(0, 0.447, 0.741), lwd = 2.5)
plot(NULL, xlim = c(0, 15), ylim = c(0, 1), xlab = "t (ms)", ylab = "v(t)")
rect(1, -1, 3, 2, col = "grey88", border = NA)
Js <- c(0.02, 0.04); farben <- c(rgb(0.89, 0.44, 0.49), rgb(0.43, 0.04, 0.12))
for (i in 1:2) {
  x <- simuliere(15, 1, J = Js[i], h_fest = TRUE)
  lines(x$t, x$v, col = farben[i], lwd = 2)
  cat(sprintf("J = %g: v(15) = %.3f\n", Js[i], x$v[length(x$v)]))
}
abline(h = vs, lty = 3)
legend("right", legend = sprintf("J = %g", Js), col = farben, lwd = 2)
