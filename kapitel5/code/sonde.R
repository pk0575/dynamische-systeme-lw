# Abb. 5.6: Eine Rhythmusstörung im Modell (Buch, Abschnitt 5.4, Gl. 5.6)
# wie Abb. 5.5 bis t = 3000 ms; Verlauf von v im Punkt (25, 25) mm, Abstände, Dauer und diastolische Intervalle der Aktionspotentiale
# Die Rechnung dauert etwa zehn Minuten.
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # Parameter in ms
D <- 0.1; dx <- 0.25; dt <- 0.05; Lq <- 100                         # mm^2/ms, mm, ms, Seitenlänge in mm
N <- round(Lq / dx); xs <- dx * ((1:N) - 0.5)
X <- matrix(xs, N, N); Y <- t(X)
S1 <- X <= 1; S2 <- Y <= Lq / 2
i0 <- floor(25 / dx) + 1                                             # Gitterpunkt bei (25, 25) mm
v <- matrix(0, N, N); h <- matrix(1, N, N)
vor <- c(2:N, N); zur <- c(1, 1:(N - 1))
K <- round(3000 / dt); spur <- numeric(K)
for (n in 0:(K - 1)) {
  t <- n * dt
  lap <- v[vor, ] + v[zur, ] + v[, vor] + v[, zur] - 4 * v
  dv <- h * v^2 * (1 - v) / tin - v / tout + D * lap / dx^2
  if (t < 2) dv[S1] <- dv[S1] + 0.2
  if (t >= 380 && t < 382) dv[S2] <- dv[S2] + 0.2
  dh <- ifelse(v < vgate, (1 - h) / topen, -h / tclose)
  v <- v + dt * dv; h <- h + dt * dh
  spur[n + 1] <- v[i0, i0]
}
ts <- dt * (1:K)
hoch <- function(s) c(FALSE, spur[-1] > s & spur[-K] <= s)
akt <- ts[hoch(0.5)]                                                 # v steigt über 0.5
auf <- ts[hoch(0.1)]; ab <- ts[c(FALSE, spur[-1] < 0.1 & spur[-K] >= 0.1)]
m <- min(length(auf), length(ab)); apd <- ab[1:m] - auf[1:m]; di <- auf[-1] - ab[1:(length(auf) - 1)]
abst <- diff(akt)
cat(sprintf("Abstände der Aktionspotentiale (ms): [%s]\n", paste(sprintf("%.1f", abst), collapse = " ")))
cat(sprintf("ab dem 4. Abstand: Mittel %.0f ms,  APD im Mittel %.0f ms,  DI im Mittel %.0f ms\n", mean(abst[-(1:3)]), mean(apd[-(1:4)]), mean(di[-(1:4)])))
plot(ts, spur, type = "l", col = rgb(0.64, 0.08, 0.18), lwd = 1.5, xlab = "t (ms)", ylab = "v bei (25, 25) mm")
