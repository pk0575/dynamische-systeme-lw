# Abb. 2.20: Ausbreitung des Aktionspotentials auf einem Ring (Buch, Abschnitt 2.5, Gl. 2.34)
# N = 50 Zellen, a = 0.89, b = 0.6, c = 0.28, k = 0.02, d = 0.4; zu Beginn wird Zelle 1 angeregt
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

a, b, c, k, d = 0.89, 0.6, 0.28, 0.02, 0.4
f1 = lambda y1, y2: y1**2 * np.exp(y2 - y1) + k

# Ruhezustand: einzelne Zelle 180 Schritte lang ab (0.2, c/(1 - a)) rechnen
y1r, y2r = 0.2, c / (1 - a)
for _ in range(180):
    y1r, y2r = f1(y1r, y2r), a * y2r - b * y1r + c

def ring(n_stoer=None, Z=50, schritte=201):
    """Ring aus Z Zellen; Zelle 1 startet erregt (0.3), optional zweite Anregung der Zelle 36 nach n_stoer Schritten."""
    Y1 = np.full((schritte + 1, Z), y1r); Y2 = np.full((schritte + 1, Z), y2r)
    Y1[0, 0] = 0.3
    rechts, links = np.roll(np.arange(Z), -1), np.roll(np.arange(Z), 1)    # Nachbarn auf dem Ring
    for n in range(schritte):
        F = f1(Y1[n], Y2[n])
        Y1[n + 1] = (1 - d) * F + d / 2 * (F[rechts] + F[links])
        Y2[n + 1] = a * Y2[n] - b * Y1[n] + c
        if n_stoer is not None and n + 1 == n_stoer:
            Y1[n + 1, 35] = 0.3                                            # Zelle 36
    return Y1

Y1 = ring()
winkel = np.linspace(0, 2 * np.pi, 51)[:50]; cx, cy = np.cos(winkel), np.sin(winkel)   # Zellen gegen den Uhrzeigersinn
print("erregte Zellen (y1 > 1):")
fig = plt.figure(figsize=(11, 6.5))
for p, n in enumerate([0, 4, 10, 20, 31, 35]):
    ax = fig.add_subplot(2, 3, p + 1, projection="3d")
    ax.stem(cx, cy, Y1[n], linefmt="C3-", markerfmt="C3o", basefmt=" ")
    ax.set_zlim(0, 4.5); ax.set_xticks([]); ax.set_yticks([]); ax.set_title(f"n = {n}")
    print(f"  n = {n:2d}:", (np.where(Y1[n] > 1)[0] + 1).tolist())
plt.tight_layout()
plt.show()
