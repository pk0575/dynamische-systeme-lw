# Abb. 5.2: Ein Puls auf der Faser (Buch, Abschnitt 5.2, Gl. 5.2)
# Kabelgleichung mit dem Mitchell-Schaeffer-Modell, Faser 150 mm, Reiz am linken Ende; Linienmethode mit dem Euler-Verfahren
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # Parameter in ms
D <- 0.1; dx <- 0.1; dt <- 0.01                                     # D in mm^2/ms, Gitterabstand in mm, Zeitschritt in ms
L <- 150; T <- 500
N <- round(L / dx) + 1; x <- dx * (0:(N - 1))
v <- numeric(N); h <- rep(1, N)
reiz <- x <= 1                                                       # Reiz J = 0.2 auf dem ersten Millimeter für 2 ms
zeiten <- c(100, 250, 400); schnapp <- matrix(0, 3, N)
K <- round(T / dt); s25 <- numeric(K); s75 <- numeric(K); t_akt <- rep(NA, N)
innen <- 2:(N - 1)
for (n in 0:(K - 1)) {
  t <- n * dt
  j <- which(abs(zeiten - t) < 1e-6); if (length(j)) schnapp[j, ] <- v
  lap <- c(v[2] - v[1], v[innen + 1] - 2 * v[innen] + v[innen - 1], v[N - 1] - v[N])   # Rand ohne Fluss
  dv <- h * v^2 * (1 - v) / tin - v / tout + D * lap / dx^2
  if (t < 2) dv[reiz] <- dv[reiz] + 0.2
  dh <- ifelse(v < vgate, (1 - h) / topen, -h / tclose)
  v <- v + dt * dv; h <- h + dt * dh
  neu <- is.na(t_akt) & v > 0.5; t_akt[neu] <- t + dt                # Zeitpunkt, an dem v erstmals 0.5 erreicht
  s25[n + 1] <- v[251]; s75[n + 1] <- v[751]
}
c <- (x[751] - x[251]) / (t_akt[751] - t_akt[251])
ts <- dt * (1:K); a <- ts[s75 > 0.1]; apd <- a[length(a)] - a[1]
cat(sprintf("v = 0.5 bei x = 25 mm nach %.1f ms, bei x = 75 mm nach %.1f ms\n", t_akt[251], t_akt[751]))
cat(sprintf("Leitungsgeschwindigkeit c = %.4f mm/ms,  APD = %.1f ms,  Wellenlänge c APD = %.1f mm\n", c, apd, c * apd))
farben <- c(rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18), rgb(0.43, 0.04, 0.12))
par(mfrow = c(1, 2))
plot(x, schnapp[1, ], type = "l", col = farben[1], lwd = 2, ylim = c(0, 1), xlab = "x (mm)", ylab = "v(x, t)")
for (j in 2:3) lines(x, schnapp[j, ], col = farben[j], lwd = 2)
legend("topright", legend = sprintf("t = %d ms", zeiten), col = farben, lwd = 2)
plot(ts, s25, type = "l", col = farben[3], lwd = 2, ylim = c(0, 1), xlab = "t (ms)", ylab = "v(x, t)")
lines(ts, s75, col = farben[1], lwd = 2)
legend("topright", legend = c("x = 25 mm", "x = 75 mm"), col = farben[c(3, 1)], lwd = 2)
