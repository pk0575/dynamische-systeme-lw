# Fig. 3.13: Continuous and discrete-time logistic model (book, Section 3.2, Eq. 3.20)
# line: solution of dx/dt = r (1 - x/K) x;  points: x_{n+1} = x_n + r x_n (1 - x_n/K);  K = 210, x0 = 0.2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
K <- 210; x0 <- 0.2
t <- seq(0, 30, length.out = 400)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))
for (r in c(0.55, 2.1, 2.6, 3.0)) {
  plot(t, x0 * K / (x0 + (K - x0) * exp(-r * t)), type = "l", col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(-10, 300),
       xlab = "t or n", ylab = "", main = sprintf("r = %g", r))
  x <- numeric(31); x[1] <- x0
  for (n in 1:30) x[n + 1] <- x[n] + r * x[n] * (1 - x[n] / K)
  lines(0:30, x, type = "o", lty = 2, pch = 16, cex = 0.6, col = rgb(0.89, 0.44, 0.49))
  cat(sprintf("r = %g: x_27 ... x_30 =", r), sprintf("%.1f", x[28:31]), "\n")
}
