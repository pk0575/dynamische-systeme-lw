# Fig. 2.10: Quotient of consecutive Fibonacci numbers (book, Section 2.3, Eq. 2.15)
# system j_{n+1} = e_n, e_{n+1} = e_n + j_n; the quotient e_{n+1}/e_n tends to the dominant eigenvalue (golden ratio)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
A <- matrix(c(0, 1,
              1, 1), nrow = 2, byrow = TRUE)
x <- c(1, 0)                             # (j_0, e_0): one young pair
e <- x[2]
for (k in 1:16) { x <- A %*% x; e <- c(e, x[2]) }
q <- e[3:length(e)] / e[2:(length(e) - 1)]
cat("eigenvalues of A:", sprintf("%.6f", sort(eigen(A)$values)), "\n")
cat("e_{n+1}/e_n:", sprintf("%.6f", tail(q, 4)), " golden ratio:", sprintf("%.6f", (1 + sqrt(5)) / 2), "\n")

plot(seq_along(q), q, type = "o", lty = 2, pch = 16, col = rgb(0.64, 0.08, 0.18), xlab = "n", ylab = "")
abline(h = (1 + sqrt(5)) / 2, lty = 2)
legend("topright", legend = c("e_{n+1}/e_n", "lambda_1 = 1.618"), col = c(rgb(0.64, 0.08, 0.18), "black"), lty = 2, pch = c(16, NA))
