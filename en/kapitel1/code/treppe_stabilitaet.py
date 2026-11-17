# Fig. 1.28: Staircase diagrams with stable and unstable steady states (book, Section 1.4, Eq. 1.34)
# top: f(x) = x - 2x(0.5 - x)(1 - x) with fixed points 0 and 1 (stable) and 0.5 (unstable)
# bottom: f(x) = exp(-2x) (spiral approach) and f(x) = exp(-5x) (spiral divergence), each with x_0 = 0.2
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

def treppe(ax, f, x0, N, lo):
    x = [x0]
    for _ in range(N):
        x.append(f(x[-1]))
    px, py = [x[0]], [lo]
    for k in range(N):
        px += [x[k], x[k + 1]]; py += [x[k + 1], x[k + 1]]
    ax.plot(px, py, color=(0.64, 0.08, 0.18), lw=1)
    return x

g = lambda x: x - 2 * x * (0.5 - x) * (1 - x)
faelle = [(g, "f(x) = x - 2x(0.5-x)(1-x)", [0.6], 20, (0.5, 1)),
          (g, "f(x) = x - 2x(0.5-x)(1-x)", [0.4, 0.6], 20, (0, 1)),
          (lambda x: np.exp(-2 * x), "f(x) = exp(-2x)", [0.2], 20, (0, 1)),
          (lambda x: np.exp(-5 * x), "f(x) = exp(-5x)", [0.2], 7, (0, 1))]

fig, axs = plt.subplots(2, 2, figsize=(9, 9))
for ax, (f, name, starts, N, (lo, hi)) in zip(axs.flat, faelle):
    xx = np.linspace(lo, hi, 400)
    ax.plot(xx, f(xx), color=(0, 0.447, 0.741), label=name)
    ax.plot([lo, hi], [lo, hi], "k", lw=0.8)
    for x0 in starts:
        x = treppe(ax, f, x0, N, lo)
        print(f"{name}, x_0 = {x0}:  x_{N} = {x[-1]:.4f}")
    ax.set_xlim(lo, hi); ax.set_ylim(lo, hi); ax.set_aspect("equal")
    ax.set_xlabel("x_n"); ax.set_ylabel("f(x_n)"); ax.legend(loc="upper left", fontsize=8)

# stability criterion |f'(x*)| < 1 at the fixed points
for c in (2, 5):
    xs = 0.5
    for _ in range(100):                              # fixed point with Newton's method
        xs -= (np.exp(-c * xs) - xs) / (-c * np.exp(-c * xs) - 1)
    print(f"f(x) = exp(-{c}x):  x* = {xs:.4f},  f'(x*) = {-c * np.exp(-c * xs):.4f}")
plt.tight_layout()
plt.show()
