# Fig. 1.22: Parameter study of the logistic growth model (book, Section 1.3, Eq. 1.28)
# y_{n+1} = a y_n (1 - y_n) with y_0 = 0.008 and a = 0.75, 3.3, 3.55, 4
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

y0, N = 0.008, 24
n = np.arange(N + 1)

fig, axs = plt.subplots(2, 2, figsize=(10, 7))
for ax, a in zip(axs.flat, [0.75, 3.3, 3.55, 4]):
    y = np.zeros(N + 1)
    y[0] = y0
    for k in range(N):
        y[k + 1] = a * y[k] * (1 - y[k])
    ax.plot(n, y, "o--", color=(0.64, 0.08, 0.18), label=f"a = {a}")
    if a > 1:
        ax.axhline(1 - 1 / a, color="k", ls="--", lw=0.8)   # steady state 1 - 1/a
    ax.set_xlabel("n"); ax.set_ylabel("y_n"); ax.legend(loc="upper left")
    print(f"a = {a}:  y_21 ... y_24 =", "  ".join(f"{v:.4g}" for v in y[21:]))
plt.tight_layout()
plt.show()
