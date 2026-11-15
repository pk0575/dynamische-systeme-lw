# Abb. 2.21: zweite Anregung der Zelle 36 im Ringmodell (Buch, Abschnitt 2.5, Gl. 2.34)
# Szenario a) n* = 37: Signal erlischt;  b) n* = 45: breitet sich in beide Richtungen aus;  c) n* = 41: kreist dauerhaft
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
function stamm(werte, titel)               # Säulen über den Zellen des Rings (räumliche Darstellung)
    w = range(0, 2pi, length = 51)[1:50]; cx = cos.(w); cy = sin.(w)
    p = plot3d(cos.(range(0, 2pi, length = 100)), sin.(range(0, 2pi, length = 100)), zeros(100), color = :gray, legend = false,
               zlims = (0, 4.5), title = titel, ticks = false, grid = false)
    for i in 1:50
        plot3d!(p, [cx[i], cx[i]], [cy[i], cy[i]], [0, werte[i]], color = RGB(0.64, 0.08, 0.18))
    end
    scatter3d!(p, cx, cy, werte, color = RGB(0.64, 0.08, 0.18), ms = 2)
    return p
end

szenarien = [("a", 37, [37, 39, 41, 43]), ("b", 45, [45, 52, 72, 81]), ("c", 41, [41, 52, 75, 100])]
bilder = Matrix{Any}(undef, 4, 3)
for (sp, (name, n_stoer, zeiten)) in enumerate(szenarien)
    Y1 = ring(n_stoer)
    @printf("Szenario %s) n* = %d: erregte Zellen nach 200 Schritten: [%s]\n", name, n_stoer, join(findall(Y1[201, :] .> 1), ", "))
    for (z, n) in enumerate(zeiten)
        bilder[z, sp] = stamm(Y1[n + 1, :], "$name) n = $n")
    end
end
display(plot(permutedims(bilder)..., layout = (4, 3), size = (900, 1100)))
