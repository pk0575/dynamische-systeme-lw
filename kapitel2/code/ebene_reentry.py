# Abb. 2.24: Spiralwelle nach einer kurzen Blockade (Buch, Abschnitt 2.5, Gl. 2.35)
# wie Abb. 2.23, aber in den Schritten 50 bis 52 ist die Kopplung d im Gebiet [28, 30] x [1, 50] null: die Welle bricht und rotiert
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

a, b, c, k, d = 0.89, 0.6, 0.28, 0.02, 0.4
f1 = lambda y1, y2: y1**2 * np.exp(y2 - y1) + k
y1r, y2r = 0.2, c / (1 - a)
for _ in range(180):                                   # Ruhezustand der einzelnen Zelle
    y1r, y2r = f1(y1r, y2r), a * y2r - b * y1r + c

def ebene(blockade, schritte, Z=100):
    """Z x Z Zellen, Rand ohne Fluss; linker Rand (i = 1) startet erregt. Liste der Zustände y1 für n = 0, 1, 2, ..."""
    Y1 = np.full((Z, Z), y1r); Y2 = np.full((Z, Z), y2r); Y1[0, :] = 0.3
    vor, zur = np.r_[1:Z, Z - 1], np.r_[0, 0:Z - 1]     # Nachbarindizes, am Rand die Zelle selbst
    zustaende = [Y1.copy()]
    for n in range(1, schritte + 1):
        D = np.full((Z, Z), d)
        if blockade and 50 <= n <= 52:
            D[27:30, 0:50] = 0                            # Blockade im Gebiet [28, 30] x [1, 50]
        F = f1(Y1, Y2)
        Y1neu = (1 - D) * F + D / 4 * (F[vor, :] + F[zur, :] + F[:, vor] + F[:, zur])
        Y2 = a * Y2 - b * Y1 + c
        Y1 = Y1neu
        zustaende.append(Y1.copy())
    return zustaende

Y = ebene(True, 301)
fig, axs = plt.subplots(3, 3, figsize=(10, 10), sharex=True, sharey=True)
for ax, n in zip(axs.flat, range(54, 215, 20)):
    ax.imshow(Y[n].T, origin="lower", cmap="Reds", extent=(0.5, 100.5, 0.5, 100.5), vmin=0, vmax=4)
    ax.set_title(f"n = {n}")
erregt = [int((Y[n] > 1).sum()) for n in (100, 200, 300)]
print("Zahl der erregten Zellen bei n = 100, 200, 300:", erregt, " -> die Erregung hört nicht auf")
plt.tight_layout()
plt.show()
