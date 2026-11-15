# Abb. 3.8: exponentielles Wachstum und Abklingen (Buch, Abschnitt 3.2, Gl. 3.15 und 3.16)
# x(t) = e^(0.5 t) und x(t) = e^(-0.5 t); links lineare, rechts logarithmische Achse (dort werden beide zu Geraden)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
t <- seq(0, 6, length.out = 300)
par(mfrow = c(1, 2))
for (achse in c("", "y")) {
  plot(t, exp(0.5 * t), type = "l", log = achse, col = rgb(0.43, 0.04, 0.12), lwd = 2, ylim = c(0.04, 21), xlab = "t", ylab = "",
       main = if (achse == "") "lineare Achse" else "logarithmische Achse: Geraden")
  lines(t, exp(-0.5 * t), lty = 2, col = rgb(0.89, 0.44, 0.49), lwd = 2)
  if (achse == "") legend("topleft", legend = c("e^(0.5t) (Wachstum)", "e^(-0.5t) (Abklingen)"),
                          col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), lty = c(1, 2), lwd = 2)
}
cat(sprintf("Verdopplungszeit ln(2)/0.5 = %.4f,  Halbwertszeit = %.4f\n", log(2) / 0.5, log(2) / 0.5))
