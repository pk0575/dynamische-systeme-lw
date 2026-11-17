# Fig. 1.37: Parameter study and bifurcation diagram of the AV node model (book, Section 1.6, Eq. 1.47)
# V_{n+1} = f(V_n) with V_0 = 1.1, u = 1, V_g = 1, and different values of c
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

Vg, u, V0, N = 1.0, 1.0, 1.1, 40
f = lambda V, c: np.where(c * V > Vg, c * V, c * V + u)

def folge(c):
    V = np.zeros(N + 1)
    V[0] = V0
    for n in range(N):
        V[n + 1] = f(V[n], c)
    return V

n = np.arange(N + 1)
fig, axs = plt.subplots(2, 2, figsize=(10, 7))
for ax, cs in zip(axs.flat, [(1 / 3, 2 / 3), (0.5001, 0.6), (0.71, 0.9)]):
    for c, farbe, m in zip(cs, [(0.43, 0.04, 0.12), (0.89, 0.44, 0.49)], "os"):
        V = folge(c)
        ax.plot(n, V, "--", marker=m, ms=4, color=farbe, lw=0.8, label=f"c = {c:.4g}")
        print(f"c = {c:.4g}:  V_35 ... V_40 =", "  ".join(f"{v:.3f}" for v in V[35:]))
    ax.set_ylim(0.6, 2.1); ax.set_xlabel("n"); ax.set_ylabel("V_n"); ax.legend(loc="lower right", ncol=2)

ax = axs[1, 1]                                   # bifurcation diagram
c = np.linspace(0.33, 0.999, 3000)
V = np.full_like(c, V0)
for _ in range(10000):
    V = f(V, c)
for _ in range(150):
    V = f(V, c)
    ax.plot(c, V, ",", color=(0, 0.39, 0))
ax.set_xlim(0.3, 1); ax.set_xlabel("c"); ax.set_ylabel("V_n for n > 10000")
plt.tight_layout()
plt.show()
