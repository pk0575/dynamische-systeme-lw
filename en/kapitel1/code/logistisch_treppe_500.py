# Fig. 1.31: Staircase diagrams of the logistic model over 500 steps (book, Section 1.4)
# initial value 0.05; a = 2 (fixed point), 3.3 (2-cycle), 3.55 (8-cycle), 4 (aperiodic)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N = 500
fig, axs = plt.subplots(2, 2, figsize=(9, 9))
xx = np.linspace(0, 1, 400)
for ax, a in zip(axs.flat, [2, 3.3, 3.55, 4]):
    f = lambda y: a * y * (1 - y)
    y = [0.05]
    for _ in range(N):
        y.append(f(y[-1]))
    px, py = [y[0]], [0]
    for k in range(N):
        px += [y[k], y[k + 1]]; py += [y[k + 1], y[k + 1]]
    ax.plot(xx, f(xx), color=(0, 0.447, 0.741), label=f"a = {a}")
    ax.plot([0, 1], [0, 1], "k", lw=0.8)
    ax.plot(px, py, color=(0.64, 0.08, 0.18), lw=1.5 if a < 4 else 0.3)
    ax.set_xlim(0, 1); ax.set_ylim(0, 1); ax.set_aspect("equal")
    ax.set_xlabel("x_n"); ax.set_ylabel("f(x_n)"); ax.legend(loc="upper left")
    werte = sorted(set(round(float(v), 4) for v in y[-16:]))   # long-term behavior: distinct values at the end
    print(f"a = {a}:  {len(werte)} distinct values at the end:", "  ".join(f"{v:.4f}" for v in werte) if len(werte) <= 8 else "aperiodic")
plt.tight_layout()
plt.show()
