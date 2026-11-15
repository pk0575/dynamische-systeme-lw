# Abb. 4.9: Wirkstoff in Magen und Blut (Buch, Abschnitt 4.2, Gl. 4.9)
# dm/dt = -ka m,  db/dt = ka m - ke b  mit ka = 1, ke = 0.2 pro Stunde, m(0) = 4, b(0) = 0:  m(t) = 4 e^(-t), b(t) = 5 (e^(-0.2t) - e^(-t))
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using LinearAlgebra
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

t = range(0, 20, length = 600)
m = 4 .* exp.(-t)
b = 5 .* (exp.(-0.2 .* t) .- exp.(-t))
tmax = log(5) / 0.8                      # db/dt = 0: e^(-0.2t) = 5 e^(-t)
@printf("höchster Spiegel im Blut b = %.3f mg nach t = %.3f h\n", 5 * (exp(-0.2tmax) - exp(-tmax)), tmax)
A = [-1 0; 1 -0.2]
println("Eigenwerte von A: ", join([@sprintf("%g", l) for l in sort(real.(eigvals(A)))], "  "))
p = plot(t, m, color = R1, lw = 2, label = "Magen m(t)", xlabel = "t (Stunden)", ylabel = "Wirkstoff (mg)")
plot!(p, t, b, color = R3, lw = 2, label = "Blut b(t)")
display(p)
