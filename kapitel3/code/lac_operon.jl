# Abb. 3.18: Genschalter des lac-Operons (Buch, Abschnitt 3.3, Gl. 3.23)
# dX/dt = (a + X^2)/(1 + X^2) - r X mit a = 0.02; links Import und Abbau für r = 0.4, rechts X* in Abhängigkeit von r (Hysterese)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using LinearAlgebra

a = 0.02
imp(X) = (a + X^2) / (1 + X^2)
X = range(0, 3, length = 400); r = 0.4
p1 = plot(X, imp.(X), color = RGB(0, 0.447, 0.741), lw = 2.5, label = "Import (a + X²)/(1 + X²)", legend = :topleft, xlabel = "X")
plot!(p1, X, r .* X, ls = :dash, color = RGB(0.64, 0.08, 0.18), lw = 2, label = "Abbau r X, r = 0.4")
# stationär: (a + X^2) = r X (1 + X^2), also -r X^3 + X^2 - r X + a = 0 (Koeffizienten aufsteigend)
# Nullstellen als Eigenwerte der Begleitmatrix von X^3 - X^2/r + X - a/r
B = [1/r -1 a/r; 1 0 0; 0 1 0]
xs = sort(real.(eigvals(B)))
scatter!(p1, xs, r .* xs, color = [:black, :white, :black], msc = :black, label = "")
println("r = 0.4: X* = ", join([@sprintf("%.3f", x) for x in xs], "  "), "  (aus, Schwelle, an)")
# Bifurkationsdiagramm: zu jedem X* gehört r = Import(X*)/X*
Xs = range(0.005, 4, length = 4000); R = imp.(Xs) ./ Xs
i1 = argmin(ifelse.(Xs .< 0.5, R, Inf))              # Umkehrpunkte der Kurve: kleinstes r auf dem unteren Ast,
i2 = argmax(ifelse.((Xs .> 0.5) .& (Xs .< 2), R, 0.0))   # größtes r auf dem mittleren Ast
gruen = RGB(0, 0.39, 0)
p2 = plot(R[1:i1], Xs[1:i1], color = gruen, lw = 3, legend = false, xlims = (0.1, 0.82), ylims = (-0.1, 3.2), xlabel = "Abbaurate r", ylabel = "X*")
plot!(p2, R[i1:i2], Xs[i1:i2], ls = :dash, color = gruen, lw = 2)
plot!(p2, R[i2:end], Xs[i2:end], color = gruen, lw = 3)
@printf("bistabil für %.2f < r < %.2f\n", R[i1], R[i2])
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
