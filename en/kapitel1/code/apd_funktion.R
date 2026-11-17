# Fig. 1.40: Update function of the APD model (book, Section 1.6, Eq. 1.49 and 1.50)
# f(APD) = r(m PCL - APD) with m = ceil((APD + DI_min)/PCL), r(DI) = 220 - 180 exp(-DI/60), DI_min = 5 ms
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
DImin <- 5
r <- function(DI) 220 - 180 * exp(-DI / 60)
f <- function(APD, PCL) r(ceiling((APD + DImin) / PCL) * PCL - APD)   # ceiling: after how many periods the next stimulus takes effect

APD <- seq(0, 800, length.out = 4001)
farben <- c(rgb(0, 0.447, 0.741), rgb(0.45, 0.70, 0.90))
par(mfrow = c(1, 2))
for (p in 1:2) {
  PCLs <- if (p == 1) 400 else c(400, 220)
  plot(NULL, xlim = c(0, 800), ylim = c(40, 225), xlab = "APD (ms)", ylab = "f(APD)")
  for (i in seq_along(PCLs)) {
    y <- f(APD, PCLs[i])
    y[c(FALSE, abs(diff(y)) > 20)] <- NA   # do not connect the jumps
    lines(APD, y, col = farben[i], lwd = 2)
  }
  legend("bottomleft", legend = sprintf("PCL = %d ms", PCLs), col = farben[seq_along(PCLs)], lwd = 2)
}
cat("jumps at APD = k PCL - DI_min, e.g. 395 and 795 ms for PCL = 400 ms\n")
