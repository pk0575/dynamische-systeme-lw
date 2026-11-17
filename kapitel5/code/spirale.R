# Abb. 5.5: Entstehung einer Spiralwelle (Buch, Abschnitt 5.4, Gl. 5.6)
# Quadrat 100 mm x 100 mm, Reiz S1 am linken Rand bei t = 0, Reiz S2 in der unteren Hälfte bei t = 380 ms
# Die Rechnung dauert etwa fünf Minuten.
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # Parameter in ms
D <- 0.1; dx <- 0.25; dt <- 0.05; Lq <- 100                         # mm^2/ms, mm, ms, Seitenlänge in mm
N <- round(Lq / dx); xs <- dx * ((1:N) - 0.5)
X <- matrix(xs, N, N); Y <- t(X)                                     # erster Index: x, zweiter Index: y
S1 <- X <= 1; S2 <- Y <= Lq / 2
v <- matrix(0, N, N); h <- matrix(1, N, N)
vor <- c(2:N, N); zur <- c(1, 1:(N - 1))                             # Nachbarindizes, am Rand die Zelle selbst (kein Fluss)
zeiten <- c(100, 300, 390, 450, 550, 650, 800, 1000, 1200); bilder <- list()
for (n in 0:round(1200 / dt)) {
  t <- n * dt
  j <- which(abs(zeiten - t) < 1e-6); if (length(j)) bilder[[j]] <- v
  lap <- v[vor, ] + v[zur, ] + v[, vor] + v[, zur] - 4 * v
  dv <- h * v^2 * (1 - v) / tin - v / tout + D * lap / dx^2
  if (t < 2) dv[S1] <- dv[S1] + 0.2                                  # Reiz S1
  if (t >= 380 && t < 382) dv[S2] <- dv[S2] + 0.2                    # Reiz S2
  dh <- ifelse(v < vgate, (1 - h) / topen, -h / tclose)
  v <- v + dt * dv; h <- h + dt * dh
}
weissrot <- colorRampPalette(c("white", rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18), rgb(0.43, 0.04, 0.12)))(64)
par(mfrow = c(3, 3), mar = c(2, 2, 2, 1))
for (j in 1:9) {
  cat(sprintf("t = %4d ms: Anteil erregt (v > 0.5) = %.3f\n", zeiten[j], mean(bilder[[j]] > 0.5)))
  image(xs, xs, bilder[[j]], col = weissrot, zlim = c(0, 1), main = sprintf("t = %d ms", zeiten[j]), asp = 1)
}
