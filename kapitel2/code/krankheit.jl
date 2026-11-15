# Abb. 2.7: Krankheitsverlauf als lineares System (Buch, Abschnitt 2.2, Gl. 2.8)
# x_{n+1} = A x_n mit x = (gesund, leicht erkrankt, schwer erkrankt), x_0 = (100000, 0, 0), ein Schritt = ein Jahr
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra

A = [0.997 0.6 0;
     0.003 0   0.35;
     0     0.4 0.65]
N = 20
X = zeros(3, N + 1)
X[:, 1] = [100000, 0, 0]
for k in 1:N
    X[:, k + 1] = A * X[:, k]            # Matrix mal Vektor
end
@printf("x_20 = (%.0f, %.0f, %.0f)\n", X[:, end]...)
s = vec(sum(A, dims = 1))
@printf("Spaltensummen von A: %g %g %g -> die Gesamtzahl bleibt erhalten: %.0f\n", s..., sum(X[:, end]))

namen = ["gesund g_n", "leicht erkrankt l_n", "schwer erkrankt k_n"]
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18)]; zeichen = [:circle, :rect, :diamond]
bilder = [begin
    b = plot(0:N, X[i, :], ls = :dash, marker = zeichen[i], color = farben[i], label = namen[i], legend = :right)
    b
end for i in 1:3]
display(plot(bilder..., layout = (3, 1), size = (800, 700), xlabel = "n (Jahre)"))
