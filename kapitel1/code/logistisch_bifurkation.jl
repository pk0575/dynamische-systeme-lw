# Abb. 1.23: Bifurkationsdiagramm des logistischen Wachstumsmodells (Buch, Abschnitt 1.3, Gl. 1.28)
# y_{n+1} = a y_n (1 - y_n): für jeden Wert von a wird nach n_* = 10000 Schritten das Langzeitverhalten gezeichnet
# oben: 2.8 <= a <= 4;  unten: Ausschnitt 3.8538 <= a <= 3.8541, 0.494 <= y <= 0.506 (das Muster kehrt wieder)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

gruen = RGB(0, 0.39, 0)
bilder = []
for (a, behalten, fenster) in [(range(2.8, 4.0, length = 2401), 200, (0, 1)),
                               (range(3.8538, 3.8541, length = 1501), 6000, (0.494, 0.506))]
    y = fill(0.9, length(a))             # alle Parameterwerte gleichzeitig (Vektor)
    for k in 1:10000                     # Einschwingen
        y = a .* y .* (1 .- y)
    end
    A = Float64[]; Y = Float64[]
    for k in 1:behalten                  # Langzeitverhalten sammeln
        y = a .* y .* (1 .- y)
        m = (y .> fenster[1]) .& (y .< fenster[2])
        append!(A, a[m]); append!(Y, y[m])
    end
    push!(bilder, scatter(A, Y, ms = 0.5, msw = 0, color = gruen, legend = false, xlabel = "a", ylabel = "y_n für n > 10000"))
end
display(plot(bilder..., layout = (2, 1), size = (800, 700)))

a = 3.2; y = 0.9                         # Beispiel a = 3.2: zwei Werte wechseln sich ab (2-Zyklus)
for k in 1:10000
    global y = a * y * (1 - y)
end
@printf("a = 3.2:  2-Zyklus %.4f <-> %.4f\n", y, a * y * (1 - y))
