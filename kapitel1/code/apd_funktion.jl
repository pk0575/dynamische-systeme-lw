# Abb. 1.40: Aktualisierungsfunktion des APD-Modells (Buch, Abschnitt 1.6, Gl. 1.49 und 1.50)
# f(APD) = r(m PCL - APD) mit m = ceil((APD + DI_min)/PCL), r(DI) = 220 - 180 exp(-DI/60), DI_min = 5 ms
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Plots

DImin = 5
r(DI) = 220 - 180 * exp(-DI / 60)
f(APD, PCL) = r(ceil((APD + DImin) / PCL) * PCL - APD)   # ceil: nach wie vielen Perioden der nächste Reiz wirkt

APD = range(0, 800, length = 4001)
farben = [RGB(0, 0.447, 0.741), RGB(0.45, 0.70, 0.90)]
bilder = []
for PCLs in ([400], [400, 220])
    b = plot(xlabel = "APD (ms)", ylabel = "f(APD)", legend = :bottomleft)
    for (i, PCL) in enumerate(PCLs)
        y = f.(APD, PCL)
        y[[false; abs.(diff(y)) .> 20]] .= NaN    # Sprungstellen nicht verbinden
        plot!(b, APD, y, color = farben[i], lw = 2, label = "PCL = $PCL ms")
    end
    push!(bilder, b)
end
println("Sprungstellen bei APD = k PCL - DI_min, z. B. 395 und 795 ms für PCL = 400 ms")
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
