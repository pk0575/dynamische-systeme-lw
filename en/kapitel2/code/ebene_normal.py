# Fig. 2.23: Propagation in the plane, regular wave (book, Section 2.5, Eq. 2.35)
# 100 x 100 cells, parameters as for the ring; the left edge is stimulated, the wave travels to the right and leaves the domain
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt

a, b, c, k, d = 0.89, 0.6, 0.28, 0.02, 0.4
f1 = lambda y1, y2: y1**2 * np.exp(y2 - y1) + k
y1r, y2r = 0.2, c / (1 - a)
for _ in range(180):                                   # resting state of a single cell
    y1r, y2r = f1(y1r, y2r), a * y2r - b * y1r + c

def ebene(blockade, schritte, Z=100):
    """Z x Z cells, no-flux boundary; left edge (i = 1) starts excited. List of the states y1 for n = 0, 1, 2, ..."""
    Y1 = np.full((Z, Z), y1r); Y2 = np.full((Z, Z), y2r); Y1[0, :] = 0.3
    vor, zur = np.r_[1:Z, Z - 1], np.r_[0, 0:Z - 1]     # neighbor indices, at the boundary the cell itself
    zustaende = [Y1.copy()]
    for n in range(1, schritte + 1):
        D = np.full((Z, Z), d)
        if blockade and 50 <= n <= 52:
            D[27:30, 0:50] = 0                            # block in the region [28, 30] x [1, 50]
        F = f1(Y1, Y2)
        Y1neu = (1 - D) * F + D / 4 * (F[vor, :] + F[zur, :] + F[:, vor] + F[:, zur])
        Y2 = a * Y2 - b * Y1 + c
        Y1 = Y1neu
        zustaende.append(Y1.copy())
    return zustaende

Y = ebene(False, 201)
fig, axs = plt.subplots(2, 3, figsize=(11, 7), sharex=True, sharey=True)
for ax, n in zip(axs.flat, [3, 36, 69, 102, 135, 168]):
    ax.imshow(Y[n].T, origin="lower", cmap="Reds", extent=(0.5, 100.5, 0.5, 100.5), vmin=0, vmax=4)
    ax.set_title(f"n = {n}")
    spalte = np.argmax(Y[n].max(axis=1))
    print(f"n = {n:3d}: wave front at i = {spalte + 1}")
plt.tight_layout()
plt.show()
