# Fig. 3.19: Michaelis-Menten kinetics, approximate solution with Euler's method (book, Section 3.4, Eq. 3.24 and 3.26)
# dS/dt = -kmax S/(k50 + S) with kmax = 0.5, k50 = 1, S(0) = 2; Euler's method S_{n+1} = S_n + h f(S_n) with h = 0.01
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots

kmax = 0.5; k50 = 1
f(S) = -kmax * S / (k50 + S)
h = 0.01; T = 10
N = round(Int, T / h)
t = h .* (0:N)
S = zeros(N + 1); S[1] = 2
for n in 1:N
    S[n + 1] = S[n] + h * f(S[n])        # one Euler step
end
for tt in (2, 5, 10)
    @printf("S(%2d) ≈ %.4f\n", tt, S[round(Int, tt / h) + 1])
end
display(plot(t, S, color = RGB(0.64, 0.08, 0.18), lw = 2.5, legend = false, ylims = (0, 2.1), xlabel = "t", ylabel = "S(t)"))
