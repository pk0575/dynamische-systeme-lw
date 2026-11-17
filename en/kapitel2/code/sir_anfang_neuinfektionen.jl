# Fig. 2.18: Initial phase of the epidemic and new infections (book, Section 2.4, Eq. 2.21 and 2.20)
# left: I_n in scenario B on a logarithmic scale with the growth factor lambda = 1 + (gamma + alpha)(R_0 - 1);
# right: new infections beta S_n I_n per time step for R_0 = 2, 3, 4 (I_0 = 1, alpha = gamma = 0.1)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra
N = 100000; alpha = 0.1; gamma = 0.1

function sir(beta, M)                    # S_n and I_n for I_0 = 1
    S = zeros(M + 1); I = zeros(M + 1); S[1] = N - 1; I[1] = 1
    for k in 1:M
        S[k + 1] = S[k] - beta * S[k] * I[k] + alpha * (N - S[k])
        I[k + 1] = I[k] + beta * S[k] * I[k] - (gamma + alpha) * I[k]
    end
    return S, I
end
beta = 7.6e-6
S, I = sir(beta, 40)
lam = 1 + (gamma + alpha) * (beta * N / (gamma + alpha) - 1)
@printf("initial growth factor: lambda = %.2f;  I_10 = %.1f,  lambda^10 = %.1f\n", lam, I[11], lam^10)
n = 0:40
p1 = plot(n, lam .^ n, yscale = :log10, color = RGB(0, 0.447, 0.741), lw = 2, label = @sprintf("λ^n, λ = %.2f", lam), xlabel = "n")
plot!(p1, n, I, ls = :dash, marker = :rect, color = RGB(0.89, 0.44, 0.49), label = "I_n")

rot = [RGB(0.43, 0.04, 0.12), RGB(0.64, 0.08, 0.18), RGB(0.89, 0.44, 0.49)]; zeichen = [:circle, :rect, :diamond]
p2 = plot(xlabel = "n", ylabel = "New infections")
for (i, R0) in enumerate(2:4)
    beta = R0 * (gamma + alpha) / N
    S, I = sir(beta, 100)
    neu = beta .* S .* I
    plot!(p2, 0:100, neu, ls = :dash, marker = zeichen[i], ms = 2, color = rot[i], label = "R_0 = $R0")
    @printf("R_0 = %d: at most %.0f new infections in step n = %d\n", R0, maximum(neu), argmax(neu) - 1)
end
display(plot(p1, p2, layout = (1, 2), size = (900, 420)))
