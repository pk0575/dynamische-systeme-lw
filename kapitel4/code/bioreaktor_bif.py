# Abb. 4.21: Auswaschen im Bioreaktor (Buch, Abschnitt 4.4, Gl. 4.17)
# stationäre Biomasse b* = (n_in - D k50/(kmax - D))/nu in Abhängigkeit von D; oberhalb von D_c = K(n_in) wird die Biomasse ausgewaschen
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
D, nin, nu, kmax, k50 = 0.2, 10, 2, 1.0, 0.5    # D in 1/h, Konzentrationen in g/l
K = lambda n: kmax * n / (k50 + n)                  # Wachstumsrate nach Monod

Dc = K(nin)
bst = lambda D: (nin - D * k50 / (kmax - D)) / nu
gruen = (0, 0.39, 0)
Dg = np.linspace(0.001, 1.2, 600)
D1 = Dg[Dg <= Dc]; D2 = Dg[(Dg >= Dc) & (Dg <= 0.985)]
plt.plot(D1, bst(D1), color=gruen, lw=3, label="stabil")
plt.plot(D2, bst(D2), "--", color=gruen, lw=2)
plt.plot([0, Dc], [0, 0], "--", color=gruen, lw=2, label="instabil")
plt.plot([Dc, 1.2], [0, 0], color=gruen, lw=3)
plt.axvline(Dc, color="0.5", ls=":"); plt.plot(D, bst(D), "ko")
print(f"D_c = K(n_in) = {Dc:.4f} pro Stunde")
for DD in [0.2, 0.5, 0.9]:
    print(f"D = {DD}: b* = {bst(DD):.4f} g/l,  Ertrag D b* = {DD * bst(DD):.4f} g/(l h)")
plt.xlim(0, 1.2); plt.ylim(-1.5, 5.5); plt.xlabel("Verdünnungsrate D (pro Stunde)"); plt.ylabel("b* (g/l)"); plt.legend(loc="lower left")
plt.show()
