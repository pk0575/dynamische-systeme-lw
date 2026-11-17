# Fig. 1.15: Newton's law of cooling (book, Section 1.2, Eq. 1.21)
# T_{n+1} = T_n + alpha (T^u - T_n) with T_0 = 35 and T^u = 23
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

T0, Tu, N = 35.0, 23.0, 20
n = np.arange(N + 1)

def abkuehlung(alpha):
    T = np.zeros(N + 1)
    T[0] = T0
    for k in range(N):
        T[k + 1] = T[k] + alpha * (Tu - T[k])
    return T

fig, axs = plt.subplots(2, 2, figsize=(10, 7))
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for alpha, c, m in zip([0.1, 0.2, 0.5], rot, "osD"):        # 0 < alpha < 1: monotone approach to T^u
    axs[0, 0].plot(n, abkuehlung(alpha), "--", marker=m, color=c, label=f"α = {alpha}")
for ax, alpha in zip([axs[0, 1], axs[1, 0], axs[1, 1]], [1.9, 2.0, 2.1]):   # 1 < alpha: oscillations
    T = abkuehlung(alpha)
    ax.plot(n, T, "o--", color=rot[1], label=f"α = {alpha}")
    print(f"α = {alpha}:  T_19 = {T[19]:.3f},  T_20 = {T[20]:.3f}")
for ax in axs.flat:
    ax.axhline(Tu, color="k", lw=0.8)
    ax.set_xlabel("n"); ax.set_ylabel("T_n"); ax.legend(loc="upper right")
plt.tight_layout()
plt.show()
