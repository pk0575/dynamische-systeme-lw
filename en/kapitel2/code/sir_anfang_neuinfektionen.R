# Fig. 2.18: Initial phase of the epidemic and new infections (book, Section 2.4, Eq. 2.21 and 2.20)
# left: I_n in scenario B on a logarithmic scale with the growth factor lambda = 1 + (gamma + alpha)(R_0 - 1);
# right: new infections beta S_n I_n per time step for R_0 = 2, 3, 4 (I_0 = 1, alpha = gamma = 0.1)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N <- 100000; alpha <- 0.1; gamma <- 0.1

sir <- function(beta, M) {               # S_n and I_n for I_0 = 1
  S <- numeric(M + 1); I <- numeric(M + 1); S[1] <- N - 1; I[1] <- 1
  for (k in 1:M) {
    S[k + 1] <- S[k] - beta * S[k] * I[k] + alpha * (N - S[k])
    I[k + 1] <- I[k] + beta * S[k] * I[k] - (gamma + alpha) * I[k]
  }
  list(S = S, I = I)
}
par(mfrow = c(1, 2))
beta <- 7.6e-6
x <- sir(beta, 40)
lam <- 1 + (gamma + alpha) * (beta * N / (gamma + alpha) - 1)
cat(sprintf("initial growth factor: lambda = %.2f;  I_10 = %.1f,  lambda^10 = %.1f\n", lam, x$I[11], lam^10))
n <- 0:40
plot(n, lam^n, type = "l", log = "y", col = rgb(0, 0.447, 0.741), lwd = 2, ylim = c(0.5, 1e6), xlab = "n", ylab = "")
lines(n, x$I, type = "o", lty = 2, pch = 15, col = rgb(0.89, 0.44, 0.49))
legend("topleft", legend = c(sprintf("lambda^n, lambda = %.2f", lam), "I_n"), col = c(rgb(0, 0.447, 0.741), rgb(0.89, 0.44, 0.49)), lty = c(1, 2), pch = c(NA, 15))

rot <- c(rgb(0.43, 0.04, 0.12), rgb(0.64, 0.08, 0.18), rgb(0.89, 0.44, 0.49)); zeichen <- c(16, 15, 18)
plot(NULL, xlim = c(0, 100), ylim = c(0, 17000), xlab = "n", ylab = "New infections")
for (i in 1:3) {
  R0 <- i + 1
  beta <- R0 * (gamma + alpha) / N
  x <- sir(beta, 100)
  neu <- beta * x$S * x$I
  lines(0:100, neu, type = "o", lty = 2, pch = zeichen[i], cex = 0.5, col = rot[i])
  cat(sprintf("R_0 = %d: at most %.0f new infections in step n = %d\n", R0, max(neu), which.max(neu) - 1))
}
legend("topright", legend = sprintf("R_0 = %d", 2:4), col = rot, pch = zeichen, lty = 2)
