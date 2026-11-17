# Fig. 4.11: Trace-determinant plane (book, Section 4.2)
# The trace T and the determinant det A of a 2x2 matrix determine the type and stability of the origin; gray: stable
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
namen <- c("Ex. 1", "Ex. 2", "Ex. 3", "PK")
As <- list(matrix(c(-2, 1, 1, -2), 2, byrow = TRUE), matrix(c(-1, 2, -2, -1), 2, byrow = TRUE),
           matrix(c(0, -2, 2, 0), 2, byrow = TRUE), matrix(c(-1, 0, 1, -0.2), 2, byrow = TRUE))
T <- seq(-5, 5, length.out = 400)
plot(NULL, xlim = c(-5, 5), ylim = c(-2.5, 7.5), xlab = "trace T", ylab = "Determinant det A")
rect(-5, 0, 0, 7.5, col = "grey90", border = NA)
lines(T, T^2 / 4, col = rgb(0, 0.447, 0.741), lwd = 2.5); abline(h = 0, v = 0)
for (i in 1:4) {
  A <- As[[i]]; Sp <- sum(diag(A)); De <- det(A)
  typ <- if (De < 0) "saddle" else if (Sp == 0) "center" else if (Sp^2 >= 4 * De) "node" else "spiral"
  if (Sp < 0 && De > 0) typ <- paste0(typ, ", stable")
  cat(sprintf("%s: trace = %4.1f,  det A = %4.1f  -> %s\n", namen[i], Sp, De, typ))
  points(Sp, De, pch = 16); text(Sp + 0.15, De + 0.2, namen[i], adj = 0)
}
text(c(-3.3, -3.6, 3.3, 2.2, 2.2), c(0.9, 6.2, 0.9, 5.6, -1.5), c("stable node", "stable spiral", "unstable node", "unstable spiral", "saddle"))
legend("bottomleft", legend = c("stable", "det A = T^2/4"), fill = c("grey90", NA), border = NA, col = c(NA, rgb(0, 0.447, 0.741)), lwd = c(NA, 2.5))
