# Abb. 2.11: Krankheitsverlauf mit stationärem Zustand (Buch, Abschnitt 2.3, Gl. 2.8)
# Der stationäre Zustand x* = A x* ist ein Eigenvektor zum Eigenwert 1, skaliert auf 100000 Personen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra

A = [0.997 0.6 0;
     0.003 0   0.35;
     0     0.4 0.65]
w, Vec = eigen(A)
println("Eigenwerte: ", join([@sprintf("%.4f", l) for l in sort(real.(w))], "  "))
i1 = argmin(abs.(w .- 1))
v = real.(Vec[:, i1])                    # Eigenvektor zum Eigenwert 1
xs = v ./ sum(v) .* 100000
@printf("stationärer Zustand x* = (%.0f, %.0f, %.0f)\n", xs...)

N = 30
X = zeros(3, N + 1); X[:, 1] = [100000, 0, 0]
for k in 1:N
    X[:, k + 1] = A * X[:, k]
end

namen = ["g_n", "l_n", "k_n"]
farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18)]; zeichen = [:circle, :rect, :diamond]
bilder = [begin
    b = plot(0:N, X[i, :], ls = :dash, marker = zeichen[i], color = farben[i], label = namen[i], legend = :right)
    hline!(b, [xs[i]], ls = :dash, color = :black, label = "")
    b
end for i in 1:3]
display(plot(bilder..., layout = (3, 1), size = (800, 700), xlabel = "n (Jahre)"))
