# Fig. 2.18: Initial phase of the epidemic and new infections (book, Section 2.4, Eq. 2.21 and 2.20)
# left: I_n in scenario B on a logarithmic scale with the growth factor lambda = 1 + (gamma + alpha)(R_0 - 1);
# right: new infections beta S_n I_n per time step for R_0 = 2, 3, 4 (I_0 = 1, alpha = gamma = 0.1)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N, alpha, gamma = 100000, 0.1, 0.1

def sir(beta, schritte):
    S, I = np.zeros(schritte + 1), np.zeros(schritte + 1)
    S[0], I[0] = N - 1, 1
    for n in range(schritte):
        S[n + 1] = S[n] - beta * S[n] * I[n] + alpha * (N - S[n])
        I[n + 1] = I[n] + beta * S[n] * I[n] - (gamma + alpha) * I[n]
    return S, I

fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
beta = 7.6e-6
S, I = sir(beta, 40)
lam = 1 + (gamma + alpha) * (beta * N / (gamma + alpha) - 1)
print(f"initial growth factor: lambda = {lam:.2f};  I_10 = {I[10]:.1f},  lambda^10 = {lam**10:.1f}")
n = np.arange(41)
axs[0].semilogy(n, lam**n, color=(0, 0.447, 0.741), label=f"λ^n, λ = {lam:.2f}")
axs[0].semilogy(n, I, "s--", color=(0.89, 0.44, 0.49), label="I_n")
axs[0].set_xlabel("n"); axs[0].legend()

rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for R0, c, m in zip([2, 3, 4], rot, "osD"):
    beta = R0 * (gamma + alpha) / N
    S, I = sir(beta, 100)
    neu = beta * S * I
    axs[1].plot(neu, "--", marker=m, ms=3, color=c, label=f"R_0 = {R0}")
    print(f"R_0 = {R0}: at most {neu.max():.0f} new infections in step n = {neu.argmax()}")
axs[1].set_xlabel("n"); axs[1].set_ylabel("New infections"); axs[1].legend()
plt.tight_layout()
plt.show()
