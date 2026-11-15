# Abb. 1.1: Fischlänge nach n Jahren (Buch, Abschnitt 1.1, Gl. 1.1)
# explizite Folge x_n = 60 n / (n + 2)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
n <- 0:10                          # n = 0, 1, ..., 10
x <- 60 * n / (n + 2)              # Formel für das n-te Folgenglied (elementweise)

cat(sprintf("%.1f", x), "\n")      # 0.0 20.0 30.0 36.0 40.0 42.9 45.0 ...

rot <- rgb(0.64, 0.08, 0.18)
plot(n, x, type = "o", lty = 2, pch = 16, col = rot, ylim = c(-3, 60),
     xlab = "n (Jahre)", ylab = "Fischlänge x_n (cm)")
text(n, x + 2.5, sprintf("%.1f", x), col = rot, cex = 0.8)
