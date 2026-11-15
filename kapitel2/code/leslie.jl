# Abb. 2.9: Leslie-Modell mit drei Altersklassen (Buch, Abschnitt 2.2, Gl. 2.11)
# x_{n+1} = L x_n mit Geburtenrate 9 der Klasse 3 und Überlebensraten 0.1 und 0.6, x_0 = (0, 0, 1000)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra

L = [0   0   9;
     0.1 0   0;
     0   0.6 0]
N = 20
X = zeros(3, N + 1)
X[:, 1] = [0, 0, 1000]
for k in 1:N
    X[:, k + 1] = L * X[:, k]
end
println("Klasse 3 alle drei Schritte: ", join([@sprintf("%.1f", x) for x in X[3, 1:3:end]], "  "))
@printf("Faktor pro Periode: 9 * 0.1 * 0.6 = %g < 1, die Population stirbt aus\n", 9 * 0.1 * 0.6)

namen = ["Klasse 1", "Klasse 2", "Klasse 3"]
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18)]; zeichen = [:circle, :rect, :diamond]
bilder = [begin
    b = plot(0:N, X[i, :], ls = :dash, marker = zeichen[i], color = farben[i], label = namen[i], legend = :right)
    b
end for i in 1:3]
display(plot(bilder..., layout = (3, 1), size = (800, 700), xlabel = "n"))
