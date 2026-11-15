# Abb. 4.10: drei lineare Systeme dx/dt = A x mit x(0) = (1, 3) (Buch, Abschnitt 4.2, Gl. 4.8 und 4.10)
# oben stabiler Knoten A = (-2 1; 1 -2), Mitte stabile Spirale A = (-1 2; -2 -1), unten Zentrum A = (0 -2; 2 0)
# links Zeitverläufe (Lösungsformeln), rechts Phasenebene mit Richtungsfeld
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
beispiele = [
    ("stabiler Knoten", np.array([[-2, 1], [1, -2]]),
     lambda t: (2 * np.exp(-t) - np.exp(-3 * t), 2 * np.exp(-t) + np.exp(-3 * t))),
    ("stabile Spirale", np.array([[-1, 2], [-2, -1]]),
     lambda t: (np.exp(-t) * (np.cos(2 * t) + 3 * np.sin(2 * t)), np.exp(-t) * (3 * np.cos(2 * t) - np.sin(2 * t)))),
    ("Zentrum", np.array([[0, -2], [2, 0]]),
     lambda t: (np.cos(2 * t) - 3 * np.sin(2 * t), 3 * np.cos(2 * t) + np.sin(2 * t))),
]
t = np.linspace(0, 6, 800)
G = np.linspace(-3.6, 3.6, 15); X1, X2 = np.meshgrid(G, G)
fig, axs = plt.subplots(3, 2, figsize=(10, 12))
for z, (name, A, loesung) in enumerate(beispiele):
    lam = np.linalg.eigvals(A)
    print(f"{name}: Eigenwerte", "  ".join(f"{l.real:g}{l.imag:+g}i" for l in sorted(lam, key=lambda l: (l.imag, l.real))))
    x1, x2 = loesung(t)
    axs[z, 0].axhline(0, color="k", lw=1)
    axs[z, 0].plot(t, x1, color=(0.43, 0.04, 0.12), lw=2, label="x1(t)")
    axs[z, 0].plot(t, x2, color=(0.89, 0.44, 0.49), lw=2, label="x2(t)")
    axs[z, 0].set_title(name); axs[z, 0].legend(loc="upper right")
    U = A[0, 0] * X1 + A[0, 1] * X2; V = A[1, 0] * X1 + A[1, 1] * X2; L = np.hypot(U, V) + 1e-12
    axs[z, 1].quiver(X1, X2, U / L, V / L, color=(0.2, 0.6, 0.25), angles="xy", scale=22, width=0.004)
    axs[z, 1].plot(x1, x2, color=(0.64, 0.08, 0.18), lw=2); axs[z, 1].plot(1, 3, "o", color=(0.64, 0.08, 0.18)); axs[z, 1].plot(0, 0, "ko")
    axs[z, 1].set_xlim(-3.6, 3.6); axs[z, 1].set_ylim(-3.6, 3.6); axs[z, 1].set_aspect("equal")
axs[2, 0].set_xlabel("t"); axs[2, 1].set_xlabel("x1")
plt.tight_layout()
plt.show()
