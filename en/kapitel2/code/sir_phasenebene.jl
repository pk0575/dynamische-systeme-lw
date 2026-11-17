# Fig. 2.16: Scenario B of the SIR model in the phase plane (book, Section 2.4, Eq. 2.21)
# states (S_n, I_n), light: early, dark: late; cross: steady state x_b* = (N/R_0, alpha (N - S*)/(gamma + alpha))
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
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
@printf("R_0 = %.1f,  steady state x_b*: S* = %.0f, I* = %.0f\n", R0, Ss, Is)
@printf("(S_80, I_80) = (%.0f, %.0f)\n", S[end], I[end])

p = plot(S, I, color = :gray, legend = false, xlabel = "S_n", ylabel = "I_n")
scatter!(p, S, I, zcolor = 0:M, color = cgrad([RGB(1, 0.85, 0.85), RGB(0.43, 0.04, 0.12)]), colorbar = false)   # light: early, dark: late
scatter!(p, [Ss], [Is], marker = :x, ms = 8, color = :black)
scatter!(p, [N], [0], color = :white, msc = :black)     # x_a* = (N, 0): disease-free
display(p)
