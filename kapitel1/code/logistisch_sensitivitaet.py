# Abb. 1.24: Sensitivität bezüglich des Startwerts (Buch, Abschnitt 1.3, Gl. 1.28)
# y_{n+1} = a y_n (1 - y_n) mit y_0 = 0.05 und ~y_0 = 0.06 für a = 2, 3.1, 3.55, 4
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N = 30
n = np.arange(N + 1)

def folge(a, y0):
    y = np.zeros(N + 1)
    y[0] = y0
    for k in range(N):
        y[k + 1] = a * y[k] * (1 - y[k])
    return y

fig, axs = plt.subplots(2, 2, figsize=(10, 7))
for ax, a in zip(axs.flat, [2, 3.1, 3.55, 4]):
    y, yt = folge(a, 0.05), folge(a, 0.06)
    ax.plot(n, y, "o--", color=(0.43, 0.04, 0.12), label=f"y_n, a = {a}")
    ax.plot(n, yt, "s--", color=(0.89, 0.44, 0.49), label=f"~y_n, a = {a}")
    ax.axhline(1 - 1 / a, color="k", lw=0.8)
    ax.set_xlabel("n"); ax.legend(loc="lower right")
    print(f"a = {a}:  |y_30 - ~y_30| = {abs(y[N] - yt[N]):.4f}")
plt.tight_layout()
plt.show()
