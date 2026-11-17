# Fig. 2.22: The three scenarios of the ring model seen from above (book, Section 2.5, Eq. 2.34)
# horizontally the cells, vertically the time steps n, color = y1; each oblique track is a traveling wave
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

fig, axs = plt.subplots(1, 3, figsize=(12, 4.5), sharey=True)
for ax, (name, n_stoer) in zip(axs, [("a", 37), ("b", 45), ("c", 41)]):
    Y1 = ring(n_stoer)
    bild = ax.imshow(Y1, origin="lower", aspect="auto", cmap="Reds", extent=(0.5, 50.5, -0.5, 201.5), vmin=0, vmax=4.2)
    ax.set_title(f"Scenario {name})"); ax.set_xlabel("Cell")
    print(f"Scenario {name}): time steps with excited cell 1 from n = 100:", [n for n in range(100, 202) if Y1[n, 0] > 1][:6])
axs[0].set_ylabel("n")
fig.colorbar(bild, ax=axs, label="y_1")
plt.show()
