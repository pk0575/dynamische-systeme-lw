# Abb. 4.11: Spur-Determinanten-Ebene (Buch, Abschnitt 4.2)
# Die Spur T und die Determinante det A einer 2x2-Matrix entscheiden über Typ und Stabilität des Ursprungs; grau: stabil
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
matrizen = {"Bsp. 1": [[-2, 1], [1, -2]], "Bsp. 2": [[-1, 2], [-2, -1]], "Bsp. 3": [[0, -2], [2, 0]], "PK": [[-1, 0], [1, -0.2]]}
T = np.linspace(-5, 5, 400)
plt.fill_between([-5, 0], 0, 7.5, color="0.9", label="stabil")
plt.plot(T, T**2 / 4, color=(0, 0.447, 0.741), lw=2.5, label="det A = T²/4")
plt.axhline(0, color="k", lw=1); plt.axvline(0, color="k", lw=1)
for name, A in matrizen.items():
    A = np.array(A); Sp, De = np.trace(A), np.linalg.det(A)
    if De < 0: typ = "Sattel"
    elif Sp == 0: typ = "Zentrum"
    elif Sp**2 >= 4 * De: typ = "Knoten"
    else: typ = "Spirale"
    print(f"{name}: Spur = {Sp:4.1f},  det A = {De:4.1f}  -> {typ}" + (", stabil" if Sp < 0 and De > 0 else ""))
    plt.plot(Sp, De, "ko"); plt.text(Sp + 0.15, De + 0.2, name)
for x, y, txt in [(-3.3, 0.9, "Knoten stabil"), (-3.6, 6.2, "Spirale stabil"), (3.3, 0.9, "Knoten instabil"),
                  (2.2, 5.6, "Spirale instabil"), (2.2, -1.5, "Sattel")]:
    plt.text(x, y, txt, ha="center")
plt.xlim(-5, 5); plt.ylim(-2.5, 7.5); plt.xlabel("Spur T"); plt.ylabel("Determinante det A"); plt.legend(loc="lower left")
plt.show()
