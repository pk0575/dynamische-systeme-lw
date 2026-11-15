# Abb. 3.8: exponentielles Wachstum und Abklingen (Buch, Abschnitt 3.2, Gl. 3.15 und 3.16)
# x(t) = e^(0.5 t) und x(t) = e^(-0.5 t); links lineare, rechts logarithmische Achse (dort werden beide zu Geraden)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots

t = range(0, 6, length = 300)
bilder = []
for (achse, titel) in [(:identity, "lineare Achse"), (:log10, "logarithmische Achse: Geraden")]
    p = plot(t, exp.(0.5 .* t), yscale = achse, color = RGB(0.43, 0.04, 0.12), lw = 2, label = "e^(0.5t) (Wachstum)", title = titel, xlabel = "t")
    plot!(p, t, exp.(-0.5 .* t), ls = :dash, color = RGB(0.89, 0.44, 0.49), lw = 2, label = "e^(-0.5t) (Abklingen)")
    push!(bilder, p)
end
@printf("Verdopplungszeit ln(2)/0.5 = %.4f,  Halbwertszeit = %.4f\n", log(2) / 0.5, log(2) / 0.5)
display(plot(bilder..., layout = (1, 2), size = (900, 420)))
