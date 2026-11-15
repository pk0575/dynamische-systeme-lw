# Abb. 2.22: die drei Szenarien des Ringmodells in der Draufsicht (Buch, Abschnitt 2.5, Gl. 2.34)
# waagrecht die Zellen, senkrecht die Zeitschritte n, Farbe = y1; jede schräge Spur ist eine wandernde Welle
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

fig, axs = plt.subplots(1, 3, figsize=(12, 4.5), sharey=True)
for ax, (name, n_stoer) in zip(axs, [("a", 37), ("b", 45), ("c", 41)]):
    Y1 = ring(n_stoer)
    bild = ax.imshow(Y1, origin="lower", aspect="auto", cmap="Reds", extent=(0.5, 50.5, -0.5, 201.5), vmin=0, vmax=4.2)
    ax.set_title(f"Szenario {name})"); ax.set_xlabel("Zelle")
    print(f"Szenario {name}): Zeitschritte mit erregter Zelle 1 ab n = 100:", [n for n in range(100, 202) if Y1[n, 0] > 1][:6])
axs[0].set_ylabel("n")
fig.colorbar(bild, ax=axs, label="y_1")
plt.show()
