# Fig. 1.21: Update function and staircase diagram (book, Section 1.3, Eq. 1.30)
# f(y) = a y (1 - y) with a = 2.5, initial value y_0 = 0.1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
a <- 2.5; y0 <- 0.1; N <- 12
f <- function(y) a * y * (1 - y)

y <- seq(0, 1, length.out = 200)
plot(y, f(y), type = "l", col = rgb(0, 0.447, 0.741), lwd = 2, xlim = c(0, 1), ylim = c(0, 1), xlab = "y_n", ylab = "y_{n+1}")
abline(0, 1)

# staircase: vertically to the graph, horizontally to the diagonal
yn <- y0
px <- yn; py <- 0
for (k in 1:N) {
  yneu <- f(yn)
  px <- c(px, yn, yneu); py <- c(py, yneu, yneu)
  yn <- yneu
}
lines(px, py, col = rgb(0.64, 0.08, 0.18))
cat(sprintf("y_%d = %.6f,  steady state 1 - 1/a = %.6f\n", N, yn, 1 - 1/a))
legend("topleft", legend = c("f(y) = a y (1 - y)", "y_{n+1} = y_n"), col = c(rgb(0, 0.447, 0.741), "black"), lwd = c(2, 1))
