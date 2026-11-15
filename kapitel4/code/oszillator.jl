# Abb. 4.6: gedämpfter Oszillator (Buch, Abschnitt 4.1, Gl. 4.5 und 4.6)
# m x'' + mu x' + k x = 0 als System dx1/dt = x2, dx2/dt = -(k x1 + mu x2)/m  mit m = 1, mu = 0.4, k = 4, x1(0) = 1, x2(0) = 0
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # Paket OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# löst dz/dt = f(t, z) und gibt die Lösung zu den Zeitpunkten t zurück (Zeile i = Komponente i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)
idx(t, tt) = findfirst(t .>= tt - 1e-9)    # erster Index mit t >= tt

m = 1; mu = 0.4; k = 4
f(t, z) = [z[2], -(k * z[1] + mu * z[2]) / m]
t = range(0, 20, length = 2001)
z = loese(f, [1, 0], t); x1 = z[1, :]; x2 = z[2, :]
for tt in (5, 10, 20)
    i = idx(t, tt)
    @printf("t = %2d: x1 = %7.4f,  x2 = %7.4f\n", tt, x1[i], x2[i])
end
p1 = hline([0], color = :black, label = "", xlabel = "t")
plot!(p1, t, x1, color = R1, lw = 2, label = "Ort x1")
plot!(p1, t, x2, color = R3, lw = 2, label = "Geschwindigkeit x2")
p2 = plot(x1, x2, color = R2, lw = 2, legend = false, xlabel = "Ort x1", ylabel = "Geschwindigkeit x2")
scatter!(p2, [1, 0], [0, 0], color = :black)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
