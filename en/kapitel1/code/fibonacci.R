# Fig. 1.4: Fibonacci sequence (book, Section 1.1, Eq. 1.5 and 1.6)
# x_{n+1} = x_n + x_{n-1}, x_0 = x_1 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
N <- 10                            # number of months
x <- numeric(N + 1)
x[1] <- 1; x[2] <- 1               # two initial values x_0 and x_1 (R counts from 1)
for (k in 2:N) {
  x[k + 1] <- x[k] + x[k - 1]      # recursion rule
}

n <- 0:N
phi <- (1 + sqrt(5)) / 2; psi <- (1 - sqrt(5)) / 2
formel <- (phi^(n + 1) - psi^(n + 1)) / sqrt(5)   # solution formula (Eq. 1.6)
cat(x, "\n")                         # 1 1 2 3 5 8 13 21 34 55 89
cat(round(formel), "\n")             # the solution formula gives the same numbers

rot <- rgb(0.64, 0.08, 0.18)
plot(n, x, type = "o", lty = 2, pch = 16, col = rot, xaxt = "n", ylim = c(0, 95),
     xlab = "n (months)", ylab = "Rabbit pairs x_n")
axis(1, at = n)
text(n, x + 4, x, col = rot, cex = 0.8)
