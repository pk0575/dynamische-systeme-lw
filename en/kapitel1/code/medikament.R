# Fig. 1.16: Drug level with a daily dose (book, Section 1.2, Eq. 1.23)
# x_{n+1} = a x_n + b_n, b_n = d if n is divisible by 24, otherwise 0;  a = 0.99, d = 0.4, x_0 = 0, n in hours
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a <- 0.99; d <- 0.4; x0 <- 0
N <- 504                                 # 21 days
x <- numeric(N + 1)
x[1] <- x0                               # x[1] is x_0
for (k in 1:N) {
  n <- k - 1                             # time step n
  b <- if (n %% 24 == 0) d else 0        # one dose every 24 hours
  x[k + 1] <- a * x[k] + b
}

xmax <- d / (1 - a^24)                   # limit of the peak values
cat(sprintf("x_max = %.4f\n", xmax))
cat(sprintf("peak value after 20 days: x_481 = %.4f\n", x[482]))

rot <- rgb(0.64, 0.08, 0.18)
par(mfrow = c(2, 1))
for (ende in c(73, N + 1)) {
  plot(0:(ende - 1), x[1:ende], type = "o", lty = 2, pch = 16, cex = 0.4, col = rot, xlab = "n (hours)", ylab = "x_n")
  abline(h = xmax)
}
