# Fig. 1.26: Staircase diagrams for x_{n+1} = sqrt(x_n) (book, Section 1.4, Eq. 1.31)
# x_0 = 0.5 (left) and x_0 = 1.4 (right); the staircase runs toward the intersection of f(x) = sqrt(x) with y = x
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

def treppe(ax, f, x0, N):
    x = [x0]
    for _ in range(N):
        x.append(f(x[-1]))
    px, py = [x[0]], [0]
    for k in range(N):
        px += [x[k], x[k + 1]]; py += [x[k + 1], x[k + 1]]
    ax.plot(px, py, color=(0.64, 0.08, 0.18))
    return x

xx = np.linspace(0, 1.5, 300)
fig, axs = plt.subplots(1, 2, figsize=(10, 5))
for ax, x0 in zip(axs, (0.5, 1.4)):
    ax.plot(xx, np.sqrt(xx), color=(0, 0.447, 0.741), label="f(x) = sqrt(x)")
    ax.plot([0, 1.5], [0, 1.5], "k", lw=0.8, label="y = x")
    x = treppe(ax, np.sqrt, x0, 4)
    print(f"x_0 = {x0}:", "  ".join(f"{v:.4f}" for v in x))
    ax.set_xlim(0, 1.5); ax.set_ylim(0, 1.5); ax.set_aspect("equal")
    ax.set_xlabel("x"); ax.set_ylabel("f(x)")
axs[0].legend(loc="lower right")
plt.show()
