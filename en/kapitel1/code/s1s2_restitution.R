# Fig. 1.39: S1-S2 protocol and restitution curve (book, Section 1.6, Eq. 1.48)
# left: periodic stimulation (S1, PCL = 400 ms) is followed by a stimulus S2 after a shorter or longer interval
# right: measured pairs (DI, APD) and restitution curve r(DI) = 220 - 180 exp(-DI/60)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
tin <- 0.3; tout <- 6; topen <- 100; tclose <- 115; vgate <- 0.13; vref <- 0.1; dt <- 0.01
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49))
par(mfrow = c(1, 2))
plot(NULL, xlim = c(-40, 800), ylim = c(0, 1), xlab = "t (ms)", ylab = "v")
for (p in 1:2) {
  tS2 <- c(300, 430)[p]
  reize <- c(0, 400, 800, 800 + tS2)
  t <- (0:159999) * dt; v <- numeric(length(t)); vv <- 0; h <- 1
  for (i in 2:length(t)) {
    J <- 0.2 * any(reize <= t[i] & t[i] < reize + 2)
    dv <- h * vv^2 * (1 - vv) / tin - vv / tout + J
    dh <- if (vv < vgate) (1 - h) / topen else -h / tclose
    vv <- vv + dt * dv; h <- h + dt * dh; v[i] <- vv
  }
  m <- t >= 760
  lines(t[m] - 800, v[m], col = farben[p])
  kreuz <- t[which(diff(sign(v - vref)) != 0)] - 800
  ende_s1 <- kreuz[kreuz > 50 & kreuz < tS2][1]         # end of the last S1 action potential
  ende_s2 <- kreuz[kreuz > tS2 + 20][1]                 # end of the S2 action potential
  cat(sprintf("S2 at %d ms:  DI = %.1f ms,  APD = %.1f ms\n", tS2, tS2 - ende_s1, ende_s2 - tS2))
}
abline(h = vref, lty = 3, col = "grey35")
legend("topright", legend = c("S2 at 300 ms", "S2 at 430 ms"), col = farben, lwd = 1)

r <- function(DI) 220 - 180 * exp(-DI / 60)
daten <- rbind(c(60, 150), c(80, 178), c(100, 182), c(120, 190), c(140, 198), c(160, 204), c(180, 208),
               c(200, 214), c(220, 214), c(240, 219), c(260, 212), c(280, 223))   # (DI, APD) in ms
DI <- seq(50, 300, length.out = 300)
plot(DI, r(DI), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, xlab = "DI (ms)", ylab = "APD (ms)", ylim = c(140, 230))
points(daten[, 1], daten[, 2], pch = 16)
legend("bottomright", legend = c("r(DI) = 220 - 180 exp(-DI/60)", "S1-S2 data"), col = c(rgb(0, 0.447, 0.741), "black"),
       lwd = c(2, NA), pch = c(NA, 16))
