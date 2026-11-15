# Abb. 4.21: Auswaschen im Bioreaktor (Buch, Abschnitt 4.4, Gl. 4.17)
# stationäre Biomasse b* = (n_in - D k50/(kmax - D))/nu in Abhängigkeit von D; oberhalb von D_c = K(n_in) wird die Biomasse ausgewaschen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

D = 0.2; nin = 10; nu = 2; kmax = 1.0; k50 = 0.5    # D in 1/h, Konzentrationen in g/l
K(n) = kmax * n / (k50 + n)                         # Wachstumsrate nach Monod
Dc = K(nin)
bst(D) = (nin - D * k50 / (kmax - D)) / nu
gruen = RGB(0, 0.39, 0)
Dg = range(0.001, 1.2, length = 600)
D1 = Dg[Dg .<= Dc]; D2 = Dg[(Dg .>= Dc) .& (Dg .<= 0.985)]
p = plot(D1, bst.(D1), color = gruen, lw = 3, label = "stabil", xlims = (0, 1.2), ylims = (-1.5, 5.5), legend = :bottomleft,
         xlabel = "Verdünnungsrate D (pro Stunde)", ylabel = "b* (g/l)")
plot!(p, D2, bst.(D2), ls = :dash, color = gruen, lw = 2, label = "")
plot!(p, [0, Dc], [0, 0], ls = :dash, color = gruen, lw = 2, label = "instabil")
plot!(p, [Dc, 1.2], [0, 0], color = gruen, lw = 3, label = "")
vline!(p, [Dc], color = :gray, ls = :dot, label = ""); scatter!(p, [D], [bst(D)], color = :black, label = "")
@printf("D_c = K(n_in) = %.4f pro Stunde\n", Dc)
for DD in (0.2, 0.5, 0.9)
    @printf("D = %g: b* = %.4f g/l,  Ertrag D b* = %.4f g/(l h)\n", DD, bst(DD), DD * bst(DD))
end
display(p)
