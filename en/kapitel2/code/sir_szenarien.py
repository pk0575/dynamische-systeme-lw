# Fig. 2.15: SIR model, scenarios A and B (book, Section 2.4, Eq. 2.21)
# S_{n+1} = S_n - beta S_n I_n + alpha N - alpha S_n,  I_{n+1} = I_n + beta S_n I_n - (gamma + alpha) I_n,  R_{n+1} = R_n + gamma I_n - alpha R_n
# N = 100000, alpha = gamma = 0.1;  A: beta = 1.2e-6, S_0 = 70000, I_0 = 30000;  B: beta = 7.6e-6, S_0 = 99999, I_0 = 1
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N, alpha, gamma = 100000, 0.1, 0.1

def sir(beta, S0, I0, schritte):
    S, I, R = np.zeros(schritte + 1), np.zeros(schritte + 1), np.zeros(schritte + 1)
    S[0], I[0], R[0] = S0, I0, N - S0 - I0
    for n in range(schritte):
        S[n + 1] = S[n] - beta * S[n] * I[n] + alpha * N - alpha * S[n]
        I[n + 1] = I[n] + beta * S[n] * I[n] - (gamma + alpha) * I[n]
        R[n + 1] = R[n] + gamma * I[n] - alpha * R[n]
    return S, I, R

fig, axs = plt.subplots(3, 2, figsize=(11, 7), sharex="col")
farben = [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49), (0.64, 0.08, 0.18)]
for spalte, (name, beta, S0, I0, schritte) in enumerate([("A", 1.2e-6, 70000, 30000, 60), ("B", 7.6e-6, 99999, 1, 80)]):
    S, I, R = sir(beta, S0, I0, schritte)
    R0 = beta * N / (gamma + alpha)                     # basic reproduction number
    print(f"Scenario {name}: R_0 = {R0:.1f},  (S, I, R) after {schritte} steps = ({S[-1]:.0f}, {I[-1]:.0f}, {R[-1]:.0f})")
    for zeile, (X, lab, m) in enumerate(zip([S, I, R], ["S_n", "I_n", "R_n"], "osD")):
        axs[zeile, spalte].plot(X, "--", marker=m, ms=3, lw=0.8, color=farben[zeile], label=lab)
        axs[zeile, spalte].legend(loc="center right")
    axs[0, spalte].set_title(f"Scenario {name}, β = {beta:g}")
    axs[2, spalte].set_xlabel("n")
plt.tight_layout()
plt.show()
