# Fig. 2.4: Predator-prey model, predators and prey survive (book, Section 2.1, Eq. 2.3)
# u_{n+1} = (1 + r) u_n - r u_n^2 - gamma u_n v_n,  v_{n+1} = gamma u_n v_n  with r = 3.1, gamma = 2.1, u_0 = 0.5, v_0 = 0.2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra
r = 3.1; gamma = 2.1
N = 40
u = zeros(N + 1); v = zeros(N + 1)
u[1] = 0.5; v[1] = 0.2                   # Julia counts from 1: u[1] is u_0
for k in 1:N
    u[k + 1] = (1 + r) * u[k] - r * u[k]^2 - gamma * u[k] * v[k]
    v[k + 1] = gamma * u[k] * v[k]
end
@printf("steady state (1/gamma, r(1 - 1/gamma)/gamma) = (%.4f, %.4f)\n", 1/gamma, r * (1 - 1/gamma) / gamma)
println("u_36 ... u_40 = ", join([@sprintf("%.3f", x) for x in u[37:41]], "  "))

n = 0:N
p1 = plot(n, u, ls = :dash, marker = :circle, color = RGB(0.43, 0.04, 0.12), label = "Prey u_n", xlabel = "n")
plot!(p1, n, v, ls = :dash, marker = :rect, color = RGB(0.89, 0.44, 0.49), label = "Predators v_n")
p2 = scatter(u, v, zcolor = n, color = cgrad([RGB(1, 0.85, 0.85), RGB(0.43, 0.04, 0.12)]), legend = false, colorbar = false,
             xlabel = "Prey u_n", ylabel = "Predators v_n")       # light: early, dark: late
scatter!(p2, [u[1]], [v[1]], color = :black, ms = 6)
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
