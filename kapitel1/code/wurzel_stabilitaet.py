# Abb. 1.27: stationäre Zustände von x_{n+1} = sqrt(x_n) (Buch, Abschnitt 1.4, Gl. 1.31)
# links: Start bei 0.01 nahe dem instabilen Zustand 0;  rechts: Start bei 1.01 nahe dem stabilen Zustand 1
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

def treppe(ax, f, x0, N):
    x = [x0]
    for _ in range(N):
        x.append(f(x[-1]))
    px, py = [x[0]], [0 if x0 < 0.5 else 0.99]
    for k in range(N):
        px += [x[k], x[k + 1]]; py += [x[k + 1], x[k + 1]]
    ax.plot(px, py, color=(0.64, 0.08, 0.18))
    return x

fig, axs = plt.subplots(1, 2, figsize=(10, 5))
for ax, x0, (lo, hi) in zip(axs, (0.01, 1.01), ((0, 1.5), (0.99, 1.01))):
    xx = np.linspace(lo, hi, 300)
    ax.plot(xx, np.sqrt(xx), color=(0, 0.447, 0.741), label="f(x) = sqrt(x)")
    ax.plot([lo, hi], [lo, hi], "k", lw=0.8, label="y = x")
    x = treppe(ax, np.sqrt, x0, 4)
    print(f"x_0 = {x0}:", "  ".join(f"{v:.5f}" for v in x))
    ax.set_xlim(lo, hi); ax.set_ylim(lo, hi); ax.set_aspect("equal")
    ax.set_xlabel("x"); ax.set_ylabel("f(x)")
axs[0].legend(loc="lower right")
print("f'(x) = 1/(2 sqrt(x)):  f'(1) = 0.5 < 1 (stabil), f'(x) -> unendlich für x -> 0 (instabil)")
plt.show()
