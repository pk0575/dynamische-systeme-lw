# Abb. 2.2: Luchse und Schneeschuhhasen (Buch, Abschnitt 2.1)
# Anzahl der von der Hudson's Bay Company angekauften Felle (in Tausend), 1900-1920, nach Odum (1953)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
jahr <- 1900:1920
hasen <- c(30, 47.2, 70.2, 77.4, 36.3, 20.6, 18.1, 21.4, 22, 25.4, 27.1, 40.3, 57, 76.6, 52.3, 19.5, 11.2, 7.6, 14.6, 16.2, 24.7)
luchse <- c(4, 6.1, 9.8, 35.2, 59.4, 41.7, 19, 13, 8.3, 9.1, 7.4, 8, 12.3, 19.5, 45.7, 51.1, 29.7, 15.8, 9.7, 10.1, 8.6)

for (g in list(c(1900, 1909), c(1910, 1920))) {      # Maxima je Jahrzehnt: die Luchse folgen den Hasen
  m <- jahr >= g[1] & jahr <= g[2]
  cat(sprintf("%d-%d: meiste Hasen %d, meiste Luchse %d\n", g[1], g[2], jahr[m][which.max(hasen[m])], jahr[m][which.max(luchse[m])]))
}

plot(jahr, hasen, type = "o", lty = 2, pch = 16, col = rgb(0.43, 0.04, 0.12), ylim = c(0, 80), xlab = "Jahr", ylab = "Felle (Tausend)")
lines(jahr, luchse, type = "o", lty = 2, pch = 15, col = rgb(0.89, 0.44, 0.49))
legend("topright", legend = c("Schneeschuhhasen", "Luchse"), col = c(rgb(0.43, 0.04, 0.12), rgb(0.89, 0.44, 0.49)), pch = c(16, 15), lty = 2)
