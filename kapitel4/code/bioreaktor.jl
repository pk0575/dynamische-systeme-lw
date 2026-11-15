# Abb. 4.20: Biomasse und Nährstoff im Bioreaktor (Buch, Abschnitt 4.4, Gl. 4.17)
# db/dt = K(n) b - D b,  dn/dt = -nu K(n) b - D n + D n_in  mit K(n) = kmax n/(k50 + n), D = 0.2, n_in = 10, nu = 2, kmax = 1, k50 = 0.5
# Start mit b(0) = 0.1 g/l und n(0) = n_in; gestrichelt der stationäre Zustand n* = D k50/(kmax - D), b* = (n_in - n*)/nu
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots
using OrdinaryDiffEq                     # Paket OrdinaryDiffEq: using Pkg; Pkg.add("OrdinaryDiffEq")
# löst dz/dt = f(t, z) und gibt die Lösung zu den Zeitpunkten t zurück (Zeile i = Komponente i)
loese(f, z0, t; alg = Tsit5(), kw...) = Array(solve(ODEProblem((z, p, s) -> f(s, z), float.(z0), (t[1], t[end])), alg;
                                                    reltol = 1e-10, abstol = 1e-12, saveat = t, kw...))
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

D = 0.2; nin = 10; nu = 2; kmax = 1.0; k50 = 0.5    # D in 1/h, Konzentrationen in g/l
K(n) = kmax * n / (k50 + n)                         # Wachstumsrate nach Monod
f(t, z) = [K(z[2]) * z[1] - D * z[1], -nu * K(z[2]) * z[1] - D * z[2] + D * nin]
t = range(0, 20, length = 2001)
z = loese(f, [0.1, nin], t); b = z[1, :]; n = z[2, :]
ns = D * k50 / (kmax - D); bs = (nin - ns) / nu
@printf("stationär: n* = %.4f g/l,  b* = %.4f g/l\n", ns, bs)
@printf("b(20) = %.4f,  n(20) = %.4f;  größte Biomasse %.4f bei t = %.2f h\n", b[end], n[end], maximum(b), t[argmax(b)])
p1 = hline([bs], color = :black, ls = :dash, legend = false, xlabel = "t (Stunden)", ylabel = "Biomasse b (g/l)")
plot!(p1, t, b, color = R2, lw = 2)
p2 = hline([ns], color = :black, ls = :dash, legend = false, xlabel = "t (Stunden)", ylabel = "Nährstoff n (g/l)")
plot!(p2, t, n, color = R2, lw = 2)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
