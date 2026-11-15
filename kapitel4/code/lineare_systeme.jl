# Abb. 4.10: drei lineare Systeme dx/dt = A x mit x(0) = (1, 3) (Buch, Abschnitt 4.2, Gl. 4.8 und 4.10)
# oben stabiler Knoten A = (-2 1; 1 -2), Mitte stabile Spirale A = (-1 2; -2 -1), unten Zentrum A = (0 -2; 2 0)
# links Zeitverläufe (Lösungsformeln), rechts Phasenebene mit Richtungsfeld
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using LinearAlgebra
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

beispiele = [
    ("stabiler Knoten", [-2 1; 1 -2], t -> (2exp(-t) - exp(-3t), 2exp(-t) + exp(-3t))),
    ("stabile Spirale", [-1 2; -2 -1], t -> (exp(-t) * (cos(2t) + 3sin(2t)), exp(-t) * (3cos(2t) - sin(2t)))),
    ("Zentrum", [0 -2; 2 0], t -> (cos(2t) - 3sin(2t), 3cos(2t) + sin(2t))),
]
t = range(0, 6, length = 800)
G = range(-3.6, 3.6, length = 15)
bilder = []
for (name, A, loesung) in beispiele
    lam = sort(complex.(eigvals(A)), by = l -> (imag(l), real(l)))
    println(name, ": Eigenwerte ", join([@sprintf("%g%+gi", real(l), imag(l)) for l in lam], "  "))
    x1 = first.(loesung.(t)); x2 = last.(loesung.(t))
    p1 = hline([0], color = :black, label = "", title = name, legend = :topright)
    plot!(p1, t, x1, color = R1, lw = 2, label = "x1(t)"); plot!(p1, t, x2, color = R3, lw = 2, label = "x2(t)")
    X = [g for g in G, h in G][:]; Y = [h for g in G, h in G][:]
    U = A[1, 1] .* X .+ A[1, 2] .* Y; W = A[2, 1] .* X .+ A[2, 2] .* Y; L = hypot.(U, W) .+ 1e-12
    p2 = quiver(X, Y, quiver = (0.33 .* U ./ L, 0.33 .* W ./ L), color = GR, legend = false,
                xlims = (-3.6, 3.6), ylims = (-3.6, 3.6), aspect_ratio = :equal)
    plot!(p2, x1, x2, color = R2, lw = 2); scatter!(p2, [1], [3], color = R2); scatter!(p2, [0], [0], color = :black)
    push!(bilder, p1, p2)
end
xlabel!(bilder[5], "t"); xlabel!(bilder[6], "x1")
display(plot(bilder..., layout = (3, 2), size = (850, 1100)))
