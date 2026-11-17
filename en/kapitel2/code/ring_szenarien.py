# Fig. 2.21: Second stimulation of cell 36 in the ring model (book, Section 2.5, Eq. 2.34)
# scenario a) n* = 37: signal dies out;  b) n* = 45: spreads in both directions;  c) n* = 41: circulates permanently
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

a, b, c, k, d = 0.89, 0.6, 0.28, 0.02, 0.4
f1 = lambda y1, y2: y1**2 * np.exp(y2 - y1) + k

# resting state: compute a single cell for 180 steps starting from (0.2, c/(1 - a))
y1r, y2r = 0.2, c / (1 - a)
for _ in range(180):
    y1r, y2r = f1(y1r, y2r), a * y2r - b * y1r + c

def ring(n_stoer=None, Z=50, schritte=201):
    """Ring of Z cells; cell 1 starts excited (0.3), optionally a second stimulation of cell 36 after n_stoer steps."""
    Y1 = np.full((schritte + 1, Z), y1r); Y2 = np.full((schritte + 1, Z), y2r)
    Y1[0, 0] = 0.3
    rechts, links = np.roll(np.arange(Z), -1), np.roll(np.arange(Z), 1)    # neighbors on the ring
    for n in range(schritte):
        F = f1(Y1[n], Y2[n])
        Y1[n + 1] = (1 - d) * F + d / 2 * (F[rechts] + F[links])
        Y2[n + 1] = a * Y2[n] - b * Y1[n] + c
        if n_stoer is not None and n + 1 == n_stoer:
            Y1[n + 1, 35] = 0.3                                            # Cell 36
    return Y1

winkel = np.linspace(0, 2 * np.pi, 51)[:50]; cx, cy = np.cos(winkel), np.sin(winkel)
szenarien = [("a", 37, [37, 39, 41, 43]), ("b", 45, [45, 52, 72, 81]), ("c", 41, [41, 52, 75, 100])]
fig = plt.figure(figsize=(10, 12))
for spalte, (name, n_stoer, zeiten) in enumerate(szenarien):
    Y1 = ring(n_stoer)
    print(f"Scenario {name}) n* = {n_stoer}: excited cells after 200 steps:", (np.where(Y1[200] > 1)[0] + 1).tolist())
    for zeile, n in enumerate(zeiten):
        ax = fig.add_subplot(4, 3, 3 * zeile + spalte + 1, projection="3d")
        ax.stem(cx, cy, Y1[n], linefmt="C3-", markerfmt="C3o", basefmt=" ")
        ax.set_zlim(0, 4.5); ax.set_xticks([]); ax.set_yticks([]); ax.set_title(f"{name}) n = {n}")
plt.tight_layout()
plt.show()
