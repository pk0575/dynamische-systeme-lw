# Fig. 1.18: Rate function of the logistic growth model (book, Section 1.3, Eq. 1.26)
# R(x) = r (1 - x/K): a small stock grows almost at the rate r, at x = K growth comes to a halt
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
r <- 1; K <- 5
R <- function(x) r * (1 - x / K)
for (x in c(0, 1, 2.5, 5)) cat(sprintf("R(%g) = %.2f\n", x, R(x)))

x <- seq(0, K, length.out = 100)
plot(x, R(x), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, xaxt = "n", yaxt = "n", xlab = "x", ylab = "R(x)")
axis(1, at = c(0, K), labels = c("0", "K")); axis(2, at = c(0, r), labels = c("0", "r"))
