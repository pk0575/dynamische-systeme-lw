# Abb. 2.21: zweite Anregung der Zelle 36 im Ringmodell (Buch, Abschnitt 2.5, Gl. 2.34)
# Szenario a) n* = 37: Signal erlischt;  b) n* = 45: breitet sich in beide Richtungen aus;  c) n* = 41: kreist dauerhaft
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

winkel = np.linspace(0, 2 * np.pi, 51)[:50]; cx, cy = np.cos(winkel), np.sin(winkel)
szenarien = [("a", 37, [37, 39, 41, 43]), ("b", 45, [45, 52, 72, 81]), ("c", 41, [41, 52, 75, 100])]
fig = plt.figure(figsize=(10, 12))
for spalte, (name, n_stoer, zeiten) in enumerate(szenarien):
    Y1 = ring(n_stoer)
    print(f"Szenario {name}) n* = {n_stoer}: erregte Zellen nach 200 Schritten:", (np.where(Y1[200] > 1)[0] + 1).tolist())
    for zeile, n in enumerate(zeiten):
        ax = fig.add_subplot(4, 3, 3 * zeile + spalte + 1, projection="3d")
        ax.stem(cx, cy, Y1[n], linefmt="C3-", markerfmt="C3o", basefmt=" ")
        ax.set_zlim(0, 4.5); ax.set_xticks([]); ax.set_yticks([]); ax.set_title(f"{name}) n = {n}")
plt.tight_layout()
plt.show()
