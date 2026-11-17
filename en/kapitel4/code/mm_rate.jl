# Fig. 4.14: Michaelis-Menten rate (book, Section 4.3, Eq. 4.14)
# K([S]) = kmax [S]/(k50 + [S]) with kmax = k3 [E]tot = 0.02 µM/s and k50 = (k2 + k3)/k1 ≈ 0.1 µM
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots
R1 = RGB(0.43, 0.04, 0.12); R2 = RGB(0.64, 0.08, 0.18); R3 = RGB(0.89, 0.44, 0.49)
BL = RGB(0, 0.447, 0.741); HB = RGB(0.45, 0.70, 0.90); GR = RGB(0.2, 0.6, 0.25)

k1 = 1.0; k2 = 1e-4; k3 = 0.1; Etot = 0.2
kmax = k3 * Etot; k50 = (k2 + k3) / k1
@printf("kmax = %g µM/s,  k50 = %.4f µM\n", kmax, k50)
S = range(0, 1, length = 400)
p = plot(S, kmax .* S ./ (k50 .+ S), color = BL, lw = 2.5, label = "K([S]) = kmax [S]/(k50 + [S])", ylims = (0, 0.024),
         legend = :bottomright, xlabel = "Substrate [S] (µM)", ylabel = "Rate (µM/s)")
hline!(p, [kmax], color = :black, ls = :dash, label = "")
plot!(p, [k50, k50, 0], [0, kmax / 2, kmax / 2], color = :black, ls = :dot, label = "")
display(p)
