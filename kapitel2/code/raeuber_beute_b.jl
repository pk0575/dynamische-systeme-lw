# Abb. 2.5: Räuber-Beute-Modell, die Räuber sterben aus (Buch, Abschnitt 2.1, Gl. 2.3)
# u_{n+1} = (1 + r) u_n - r u_n^2 - gamma u_n v_n,  v_{n+1} = gamma u_n v_n  mit r = 2.5, gamma = 1.1, u_0 = 0.5, v_0 = 0.2
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra
r = 2.5; gamma = 1.1
N = 40
u = zeros(N + 1); v = zeros(N + 1)
u[1] = 0.5; v[1] = 0.2                   # Julia zählt ab 1: u[1] ist u_0
for k in 1:N
    u[k + 1] = (1 + r) * u[k] - r * u[k]^2 - gamma * u[k] * v[k]
    v[k + 1] = gamma * u[k] * v[k]
end
println("v_0, v_10, v_20, v_40 = ", join([@sprintf("%.4f", v[i]) for i in (1, 11, 21, 41)], "  "), "  -> die Räuber sterben aus")
println("u_36 ... u_40 = ", join([@sprintf("%.3f", x) for x in u[37:41]], "  "))

n = 0:N
p1 = plot(n, u, ls = :dash, marker = :circle, color = RGB(0.43, 0.04, 0.12), label = "Beute u_n", xlabel = "n")
plot!(p1, n, v, ls = :dash, marker = :rect, color = RGB(0.89, 0.44, 0.49), label = "Räuber v_n")
p2 = scatter(u, v, zcolor = n, color = cgrad([RGB(1, 0.85, 0.85), RGB(0.43, 0.04, 0.12)]), legend = false, colorbar = false,
             xlabel = "Beute u_n", ylabel = "Räuber v_n")       # hell: früh, dunkel: spät
scatter!(p2, [u[1]], [v[1]], color = :black, ms = 6)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
