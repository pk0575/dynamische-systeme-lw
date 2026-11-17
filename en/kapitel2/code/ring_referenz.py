# Fig. 2.20: Propagation of the action potential on a ring (book, Section 2.5, Eq. 2.34)
# N = 50 cells, a = 0.89, b = 0.6, c = 0.28, k = 0.02, d = 0.4; at the start cell 1 is stimulated
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

Y1 = ring()
winkel = np.linspace(0, 2 * np.pi, 51)[:50]; cx, cy = np.cos(winkel), np.sin(winkel)   # cells counterclockwise
print("excited cells (y1 > 1):")
fig = plt.figure(figsize=(11, 6.5))
for p, n in enumerate([0, 4, 10, 20, 31, 35]):
    ax = fig.add_subplot(2, 3, p + 1, projection="3d")
    ax.stem(cx, cy, Y1[n], linefmt="C3-", markerfmt="C3o", basefmt=" ")
    ax.set_zlim(0, 4.5); ax.set_xticks([]); ax.set_yticks([]); ax.set_title(f"n = {n}")
    print(f"  n = {n:2d}:", (np.where(Y1[n] > 1)[0] + 1).tolist())
plt.tight_layout()
plt.show()
