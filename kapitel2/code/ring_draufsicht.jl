# Abb. 2.22: die drei Szenarien des Ringmodells in der Draufsicht (Buch, Abschnitt 2.5, Gl. 2.34)
# waagrecht die Zellen, senkrecht die Zeitschritte n, Farbe = y1; jede schräge Spur ist eine wandernde Welle
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra
a = 0.89; b = 0.6; c = 0.28; k = 0.02; d = 0.4
f1(y1, y2) = y1^2 * exp(y2 - y1) + k

# Ruhezustand: einzelne Zelle 180 Schritte lang ab (0.2, c/(1 - a)) rechnen
y1r = 0.2; y2r = c / (1 - a)
for j in 1:180
    global y1r, y2r = f1(y1r, y2r), a * y2r - b * y1r + c
end

function ring(n_stoer = -1; Z = 50, schritte = 201)
    # Ring aus Z Zellen; Zelle 1 startet erregt (0.3), optional zweite Anregung der Zelle 36 nach n_stoer Schritten
    Y1 = fill(y1r, schritte + 1, Z); Y2 = fill(y2r, schritte + 1, Z)   # Zeile n+1 = Zeitschritt n
    Y1[1, 1] = 0.3
    rechts = [2:Z; 1]; links = [Z; 1:Z-1]                            # Nachbarn auf dem Ring
    for n in 0:schritte-1
        F = f1.(Y1[n + 1, :], Y2[n + 1, :])
        Y1[n + 2, :] = (1 - d) .* F .+ d / 2 .* (F[rechts] .+ F[links])
        Y2[n + 2, :] = a .* Y2[n + 1, :] .- b .* Y1[n + 1, :] .+ c
        n + 1 == n_stoer && (Y1[n + 2, 36] = 0.3)                     # zweite Anregung der Zelle 36
    end
    return Y1
end

weissrot = cgrad([RGB(1, 1, 1), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18), RGB(0.43, 0.04, 0.12)])
bilder = []
for (name, n_stoer) in [("a", 37), ("b", 45), ("c", 41)]
    Y1 = ring(n_stoer)
    push!(bilder, heatmap(1:50, 0:201, Y1, color = weissrot, clims = (0, 4.2), xlabel = "Zelle", ylabel = "n", title = "Szenario $name)"))
    zeiten = [n for n in 100:201 if Y1[n + 1, 1] > 1]
    @printf("Szenario %s): Zeitschritte mit erregter Zelle 1 ab n = 100: [%s]\n", name, join(first(zeiten, 6), ", "))
end
display(plot(bilder..., layout = (1, 3), size = (1100, 420)))
