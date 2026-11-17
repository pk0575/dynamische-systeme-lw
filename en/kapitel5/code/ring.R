# Fig. 5.4: Circulating excitation on a ring (book, Section 5.3, Eq. 5.2)
# Initial state: piece of length L behind the front of a fiber stimulated at its end; L = 100 mm circulates, L = 65 mm dies out
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13   # parameters in ms
D <- 0.1; dx <- 0.2; dt <- 0.02                                     # mm^2/ms, mm, ms
euler <- function(v, h, lap) {
  dv <- h * v^2 * (1 - v) / tin - v / tout + D * lap / dx^2
  dh <- ifelse(v < vgate, (1 - h) / topen, -h / tclose)
  list(v = v + dt * dv, h = h + dt * dh)
}
# stimulate a long fiber (250 mm) at the left until the front (v > 0.5) is at 200 mm
N <- round(250 / dx) + 1; x <- dx * (0:(N - 1)); vF <- numeric(N); hF <- rep(1, N); n <- 0; innen <- 2:(N - 1)
while (!any(vF > 0.5) || max(x[vF > 0.5]) < 200) {
  lap <- c(vF[2] - vF[1], vF[innen + 1] - 2 * vF[innen] + vF[innen - 1], vF[N - 1] - vF[N])
  z <- euler(vF, hF, lap); vF <- z$v; hF <- z$h
  if (n * dt < 2) vF[x <= 1] <- vF[x <= 1] + dt * 0.2               # stimulus J = 0.2 for 2 ms
  n <- n + 1
}
iF <- max(which(vF > 0.5))

ring <- function(L, T, alle = 10) {
  # ring of length L; returns v every 'alle' time steps and the times at which v reaches 0.5 at the middle of the ring
  M <- round(L / dx); v <- vF[(iF - M + 1):iF]; h <- hF[(iF - M + 1):iF]
  bild <- list(); akt <- c(); oben <- FALSE; mitte <- M %/% 2 + 1; vor <- c(2:M, 1); zur <- c(M, 1:(M - 1))
  for (k in 0:(round(T / dt) - 1)) {
    if (k %% alle == 0) bild[[length(bild) + 1]] <- v
    z <- euler(v, h, v[zur] - 2 * v + v[vor]); v <- z$v; h <- z$h
    if (v[mitte] > 0.5 && !oben) { akt <- c(akt, (k + 1) * dt); oben <- TRUE }
    if (v[mitte] < 0.1) oben <- FALSE
  }
  list(bild = bild, akt = akt, vmax = max(v))
}

weissrot <- colorRampPalette(c("white", rgb(0.89, 0.44, 0.49), rgb(0.64, 0.08, 0.18), rgb(0.43, 0.04, 0.12)))(64)
par(mfrow = c(1, 2))
for (L in c(100, 65)) {
  r <- ring(L, 1500)
  cat(sprintf("L = %d mm: round-trip times [%s] ms, the excitation %s\n", L, paste(sprintf("%.1f", diff(r$akt)), collapse = " "),
              if (r$vmax > 0.5) "circulates" else "dies out"))
  B <- do.call(rbind, r$bild)
  image(seq(0, L, length.out = ncol(B)), seq(0, 1500, length.out = nrow(B)), t(B), col = weissrot, zlim = c(0, 1),
        main = sprintf("L = %d mm", L), xlab = "position on the ring (mm)", ylab = "t (ms)")
}
for (L in 66:70) {                                                   # critical length
  r <- ring(L, 800, alle = 1e9)
  cat(sprintf("L = %d mm: %s\n", L, if (r$vmax > 0.5) "circulates" else "dies out"))
}
