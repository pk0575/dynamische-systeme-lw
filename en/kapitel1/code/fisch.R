# Fig. 1.1: Fish length after n years (book, Section 1.1, Eq. 1.1)
# explicit sequence x_n = 60 n / (n + 2)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
n <- 0:10                          # n = 0, 1, ..., 10
x <- 60 * n / (n + 2)              # formula for the n-th term (elementwise)

cat(sprintf("%.1f", x), "\n")      # 0.0 20.0 30.0 36.0 40.0 42.9 45.0 ...

rot <- rgb(0.64, 0.08, 0.18)
plot(n, x, type = "o", lty = 2, pch = 16, col = rot, ylim = c(-3, 60),
     xlab = "n (years)", ylab = "Fish length x_n (cm)")
text(n, x + 2.5, sprintf("%.1f", x), col = rot, cex = 0.8)
