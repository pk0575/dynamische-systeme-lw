# Fig. 1.41: Parameter study and bifurcation diagram of the APD model (book, Section 1.6, Eq. 1.49)
# APD_{n+1} = f(APD_n) with APD_0 = 150 ms, DI_min = 5 ms, and different pacing cycle lengths PCL
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
DImin <- 5; APD0 <- 150; N <- 120
r <- function(DI) 220 - 180 * exp(-DI / 60)
f <- function(APD, PCL) r(ceiling((APD + DImin) / PCL) * PCL - APD)

n <- 0:N
farben <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)); zeichen <- c(16, 15, 18)
PCLliste <- list(c(400, 220, 180), 110, 100)
par(mfrow = c(2, 2))
for (p in 1:3) {
  PCLs <- PCLliste[[p]]
  plot(NULL, xlim = c(0, N), ylim = c(40, 230), xlab = "n", ylab = "APD_n (ms)")
  for (i in seq_along(PCLs)) {
    A <- numeric(N + 1); A[1] <- APD0
    for (k in 1:N) A[k + 1] <- f(A[k], PCLs[i])
    lines(n, A, type = "o", lty = 2, pch = zeichen[i], cex = 0.5, col = farben[i])
    cat(sprintf("PCL = %d ms:  APD_117 ... APD_120 =", PCLs[i]), sprintf("%.1f", A[118:121]), "\n")
  }
  legend("bottomright", legend = sprintf("PCL = %d", PCLs), col = farben[seq_along(PCLs)], pch = zeichen, lty = 2, cex = 0.8)
}

PCL <- seq(50, 250, length.out = 4000)   # bifurcation diagram with respect to PCL
A <- rep(APD0, length(PCL))
for (k in 1:10000) A <- f(A, PCL)
P <- c(); W <- c()
for (k in 1:150) { A <- f(A, PCL); P <- c(P, PCL); W <- c(W, A) }
plot(P, W, pch = ".", col = rgb(0, 0.39, 0), xlab = "PCL (ms)", ylab = "APD_n (ms) for n > 10000")
