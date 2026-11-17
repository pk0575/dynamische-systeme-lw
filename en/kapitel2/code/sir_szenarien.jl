# Fig. 2.15: SIR model, scenarios A and B (book, Section 2.4, Eq. 2.21)
# S_{n+1} = S_n - beta S_n I_n + alpha N - alpha S_n,  I_{n+1} = I_n + beta S_n I_n - (gamma + alpha) I_n,  R_{n+1} = R_n + gamma I_n - alpha R_n
# N = 100000, alpha = gamma = 0.1;  A: beta = 1.2e-6, S_0 = 70000, I_0 = 30000;  B: beta = 7.6e-6, S_0 = 99999, I_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
using Printf, Plots, LinearAlgebra
N = 100000; alpha = 0.1; gamma = 0.1

farben = [RGB(0.43, 0.04, 0.12), RGB(0.89, 0.44, 0.49), RGB(0.64, 0.08, 0.18)]; zeichen = [:circle, :rect, :diamond]
lab = ["S_n", "I_n", "R_n"]
bilder = []
for (name, beta, S0, I0, M) in [("A", 1.2e-6, 70000, 30000, 60), ("B", 7.6e-6, 99999, 1, 80)]
    X = zeros(3, M + 1)                  # rows: S, I, R
    X[:, 1] = [S0, I0, N - S0 - I0]
    for k in 1:M
        S, I, R = X[:, k]
        X[:, k + 1] = [S - beta * S * I + alpha * N - alpha * S,
                       I + beta * S * I - (gamma + alpha) * I,
                       R + gamma * I - alpha * R]
    end
    R0 = beta * N / (gamma + alpha)      # basic reproduction number
    @printf("Scenario %s: R_0 = %.1f,  (S, I, R) after %d steps = (%.0f, %.0f, %.0f)\n", name, R0, M, X[:, end]...)
    for z in 1:3
        push!(bilder, plot(0:M, X[z, :], ls = :dash, marker = zeichen[z], ms = 2, color = farben[z], label = lab[z],
                           title = z == 1 ? "Scenario $name, β = $beta" : ""))
    end
end
display(plot(bilder[[1, 4, 2, 5, 3, 6]]..., layout = (3, 2), size = (900, 650)))
