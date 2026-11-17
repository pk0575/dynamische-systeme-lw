# Fig. 1.33: The first steps of Newton's method (book, Section 1.5, Eq. 1.44)
# x_{n+1} = x_n - g(x_n)/g'(x_n) for g(x) = exp(-5x) - x with x_0 = 0.05
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

g = lambda x: np.exp(-5 * x) - x
dg = lambda x: -5 * np.exp(-5 * x) - 1

x = [0.05]
for n in range(6):
    x.append(x[-1] - g(x[-1]) / dg(x[-1]))
for n, v in enumerate(x):
    print(f"x_{n} = {v:.12f}")           # the number of correct digits roughly doubles per step

xx = np.linspace(0, 0.35, 300)
fig, axs = plt.subplots(1, 2, figsize=(10, 4.8))
for ax, k in zip(axs, (1, 2)):
    ax.plot(xx, g(xx), color=(0, 0.447, 0.741), label="g(x)")
    ax.axhline(0, color="k", lw=0.8)
    for j in range(k):                   # tangent at x_j, its root is x_{j+1}
        ax.plot(xx, g(x[j]) + dg(x[j]) * (xx - x[j]), "k--" if j < k - 1 else "k-", lw=1)
        ax.plot([x[j], x[j]], [0, g(x[j])], "k:")
    ax.plot(x[:k + 1], np.zeros(k + 1), "o", color=(0.64, 0.08, 0.18))
    ax.set_xlim(0, 0.35); ax.set_ylim(-0.35, 1); ax.set_xlabel("x"); ax.legend()
plt.show()
