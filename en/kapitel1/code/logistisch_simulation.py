# Fig. 1.20: Simulation of the logistic growth model (book, Section 1.3, Eq. 1.26)
# x_{n+1} = x_n + r (1 - x_n/K) x_n with K = 5, x_0 = 0.1, and three growth rates r; 20 (left) and 50 (right) steps
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

K, x0 = 5.0, 0.1
raten = [0.5, 0.25, 0.1]
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]

fig, axs = plt.subplots(1, 2, figsize=(10, 4.5))
for ax, N in zip(axs, (20, 50)):
    n = np.arange(N + 1)
    for r, c, m in zip(raten, rot, "osD"):
        x = np.zeros(N + 1)
        x[0] = x0
        for k in range(N):
            x[k + 1] = x[k] + r * (1 - x[k] / K) * x[k]
        ax.plot(n, x, "--", marker=m, ms=4, color=c, label=f"r = {r}")
        print(f"N = {N}, r = {r}:  x_N = {x[N]:.4f}")
    ax.axhline(K, color="k", lw=0.8)
    ax.set_xlabel("n"); ax.set_ylabel("x_n"); ax.legend()
plt.tight_layout()
plt.show()
