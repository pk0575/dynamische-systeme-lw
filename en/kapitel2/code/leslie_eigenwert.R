# Fig. 2.13: Dominant eigenvalue of the Leslie model as a function of b_2 (book, Section 2.3, Eq. 2.19)
# b_1 = 0, b_3 = 9, s_1 = 0.1, s_2 = 0.6; for R = b_1 + s_1 b_2 + s_1 s_2 b_3 = 1, i.e. b_2 = 4.6, lambda_1 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
b2 <- seq(0, 10, length.out = 201)
lam <- sapply(b2, function(b) max(Mod(eigen(matrix(c(0, b, 9, 0.1, 0, 0, 0, 0.6, 0), nrow = 3, byrow = TRUE))$values)))
cat(sprintf("b_2 with R = 1: %.2f\n", (1 - 0.54) / 0.1))
cat(sprintf("lambda_1 at b_2 = 4.6: %.6f\n", max(Mod(eigen(matrix(c(0, 4.6, 9, 0.1, 0, 0, 0, 0.6, 0), nrow = 3, byrow = TRUE))$values))))

plot(b2, lam, type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, xlab = "b_2", ylab = "lambda_1")
abline(h = 1); lines(c(4.6, 4.6), c(0.75, 1.2), lty = 3)
