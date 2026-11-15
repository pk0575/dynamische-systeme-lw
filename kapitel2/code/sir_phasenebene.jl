# Abb. 2.16: Szenario B des SIR-Modells in der Phasenebene (Buch, Abschnitt 2.4, Gl. 2.21)
# Zustände (S_n, I_n), hell: früh, dunkel: spät; Kreuz: stationärer Zustand x_b* = (N/R_0, alpha (N - S*)/(gamma + alpha))
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
using Printf, Plots, LinearAlgebra
N = 100000; alpha = 0.1; gamma = 0.1
beta = 7.6e-6
M = 80
S = zeros(M + 1); I = zeros(M + 1)
S[1] = 99999; I[1] = 1
for k in 1:M
    S[k + 1] = S[k] - beta * S[k] * I[k] + alpha * (N - S[k])
    I[k + 1] = I[k] + beta * S[k] * I[k] - (gamma + alpha) * I[k]
end
R0 = beta * N / (gamma + alpha)
Ss = N / R0; Is = alpha * (N - Ss) / (gamma + alpha)
@printf("R_0 = %.1f,  stationärer Zustand x_b*: S* = %.0f, I* = %.0f\n", R0, Ss, Is)
@printf("(S_80, I_80) = (%.0f, %.0f)\n", S[end], I[end])

p = plot(S, I, color = :gray, legend = false, xlabel = "S_n", ylabel = "I_n")
scatter!(p, S, I, zcolor = 0:M, color = cgrad([RGB(1, 0.85, 0.85), RGB(0.43, 0.04, 0.12)]), colorbar = false)   # hell: früh, dunkel: spät
scatter!(p, [Ss], [Is], marker = :x, ms = 8, color = :black)
scatter!(p, [N], [0], color = :white, msc = :black)     # x_a* = (N, 0): krankheitsfrei
display(p)
