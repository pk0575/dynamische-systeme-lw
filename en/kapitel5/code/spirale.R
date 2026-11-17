# Fig. 5.5: Formation of a spiral wave (book, Section 5.4, Eq. 5.6)
# square 100 mm x 100 mm, stimulus S1 at the left edge at t = 0, stimulus S2 in the lower half at t = 380 ms
# The computation takes about five minutes.
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # parameters in ms
D <- 0.1; dx <- 0.25; dt <- 0.05; Lq <- 100                         # mm^2/ms, mm, ms, side length in mm
N <- round(Lq / dx); xs <- dx * ((1:N) - 0.5)
X <- matrix(xs, N, N); Y <- t(X)                                     # first index: x, second index: y
S1 <- X <= 1; S2 <- Y <= Lq / 2
v <- matrix(0, N, N); h <- matrix(1, N, N)
vor <- c(2:N, N); zur <- c(1, 1:(N - 1))                             # neighbor indices, at the boundary the cell itself (no flux)
zeiten <- c(100, 300, 390, 450, 550, 650, 800, 1000, 1200); bilder <- list()
for (n in 0:round(1200 / dt)) {
  t <- n * dt
  j <- which(abs(zeiten - t) < 1e-6); if (length(j)) bilder[[j]] <- v
  lap <- v[vor, ] + v[zur, ] + v[, vor] + v[, zur] - 4 * v
  dv <- h * v^2 * (1 - v) / tin - v / tout + D * lap / dx^2
  if (t < 2) dv[S1] <- dv[S1] + 0.2                                  # stimulus S1
  if (t >= 380 && t < 382) dv[S2] <- dv[S2] + 0.2                    # stimulus S2
  dh <- ifelse(v < vgate, (1 - h) / topen, -h / tclose)
  v <- v + dt * dv; h <- h + dt * dh
}
weissrot <- colorRampPalette(c("white", rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18), rgb(0.43, 0.04, 0.12)))(64)
par(mfrow = c(3, 3), mar = c(2, 2, 2, 1))
for (j in 1:9) {
  cat(sprintf("t = %4d ms: fraction excited (v > 0.5) = %.3f\n", zeiten[j], mean(bilder[[j]] > 0.5)))
  image(xs, xs, bilder[[j]], col = weissrot, zlim = c(0, 1), main = sprintf("t = %d ms", zeiten[j]), asp = 1)
}
