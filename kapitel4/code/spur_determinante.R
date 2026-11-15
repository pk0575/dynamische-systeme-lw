# Abb. 4.11: Spur-Determinanten-Ebene (Buch, Abschnitt 4.2)
# Die Spur T und die Determinante det A einer 2x2-Matrix entscheiden über Typ und Stabilität des Ursprungs; grau: stabil
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
namen <- c("Bsp. 1", "Bsp. 2", "Bsp. 3", "PK")
As <- list(matrix(c(-2, 1, 1, -2), 2, byrow = TRUE), matrix(c(-1, 2, -2, -1), 2, byrow = TRUE),
           matrix(c(0, -2, 2, 0), 2, byrow = TRUE), matrix(c(-1, 0, 1, -0.2), 2, byrow = TRUE))
T <- seq(-5, 5, length.out = 400)
plot(NULL, xlim = c(-5, 5), ylim = c(-2.5, 7.5), xlab = "Spur T", ylab = "Determinante det A")
rect(-5, 0, 0, 7.5, col = "grey90", border = NA)
lines(T, T^2 / 4, col = rgb(0, 0.447, 0.741), lwd = 2.5); abline(h = 0, v = 0)
for (i in 1:4) {
  A <- As[[i]]; Sp <- sum(diag(A)); De <- det(A)
  typ <- if (De < 0) "Sattel" else if (Sp == 0) "Zentrum" else if (Sp^2 >= 4 * De) "Knoten" else "Spirale"
  if (Sp < 0 && De > 0) typ <- paste0(typ, ", stabil")
  cat(sprintf("%s: Spur = %4.1f,  det A = %4.1f  -> %s\n", namen[i], Sp, De, typ))
  points(Sp, De, pch = 16); text(Sp + 0.15, De + 0.2, namen[i], adj = 0)
}
text(c(-3.3, -3.6, 3.3, 2.2, 2.2), c(0.9, 6.2, 0.9, 5.6, -1.5), c("Knoten stabil", "Spirale stabil", "Knoten instabil", "Spirale instabil", "Sattel"))
legend("bottomleft", legend = c("stabil", "det A = T^2/4"), fill = c("grey90", NA), border = NA, col = c(NA, rgb(0, 0.447, 0.741)), lwd = c(NA, 2.5))
