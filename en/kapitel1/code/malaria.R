# Fig. 1.3: Malaria parasites after n days (book, Section 1.1, Eq. 1.2 and 1.3)
# recursion rule x_{n+1} = 8 x_n, x_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N <- 4                             # number of days
x <- numeric(N + 1)
x[1] <- 1                          # initial value x_0 = 1 (R counts from 1: x[1] is x_0)
for (k in 1:N) {
  x[k + 1] <- 8 * x[k]             # recursion rule
}

n <- 0:N
cat(x, "\n")                         # 1 8 64 512 4096
cat(8^n * x[1], "\n")                # solution formula x_n = 8^n x_0 gives the same

rot <- rgb(0.64, 0.08, 0.18)
plot(n, x, type = "o", lty = 2, pch = 16, col = rot, xaxt = "n", ylim = c(0, 4500),
     xlab = "n (days)", ylab = "Number of parasites x_n")
axis(1, at = n)
text(n, x + 250, x, col = rot, cex = 0.8)
