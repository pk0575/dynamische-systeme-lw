# Abb. 1.8: Treppendiagramm des Heron-Verfahrens (Buch, Abschnitt 1.1, Gl. 1.4)
# x_{n+1} = (x_n + 2/x_n)/2 mit x_0 = 0.5; die Treppe läuft in den Schnittpunkt mit y = x bei sqrt(2)
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

f = lambda x: 0.5 * (x + 2 / x)
x0, N = 0.5, 4

x = [x0]
for n in range(N):
    x.append(f(x[-1]))
for n, v in enumerate(x):
    print(f"x_{n} = {v:.6f}")
print(f"sqrt(2) = {np.sqrt(2):.6f}")

xx = np.linspace(0.3, 3, 400)
fig, axs = plt.subplots(1, 2, figsize=(10, 4.5))
for ax, schritte in zip(axs, (1, N)):
    ax.plot(xx, f(xx), color=(0, 0.447, 0.741), label="f(x)")
    ax.plot([0, 3], [0, 3], "k", lw=0.8, label="y = x")
    px, py = [x[0]], [0]                       # Treppe: senkrecht zum Graphen, waagrecht zur Winkelhalbierenden
    for k in range(schritte):
        px += [x[k], x[k + 1]]
        py += [x[k + 1], x[k + 1]]
    px.append(x[schritte]); py.append(0)       # Wert zurück auf die x-Achse
    ax.plot(px, py, color=(0.64, 0.08, 0.18))
    ax.set_xlim(0, 3); ax.set_ylim(0, 3)
    ax.set_xlabel("x"); ax.set_ylabel("f(x)")
    ax.set_title(f"{schritte} Schritt" + ("e" if schritte > 1 else ""))
axs[0].legend()
plt.show()
