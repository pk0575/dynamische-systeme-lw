# Fig. 4.21: Washout in the bioreactor (book, Section 4.4, Eq. 4.17)
# steady-state biomass b* = (n_in - D k50/(kmax - D))/nu as a function of D; above D_c = K(n_in) the biomass is washed out
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
D, nin, nu, kmax, k50 = 0.2, 10, 2, 1.0, 0.5    # D in 1/h, concentrations in g/l
K = lambda n: kmax * n / (k50 + n)                  # Monod growth rate

Dc = K(nin)
bst = lambda D: (nin - D * k50 / (kmax - D)) / nu
gruen = (0, 0.39, 0)
Dg = np.linspace(0.001, 1.2, 600)
D1 = Dg[Dg <= Dc]; D2 = Dg[(Dg >= Dc) & (Dg <= 0.985)]
plt.plot(D1, bst(D1), color=gruen, lw=3, label="stable")
plt.plot(D2, bst(D2), "--", color=gruen, lw=2)
plt.plot([0, Dc], [0, 0], "--", color=gruen, lw=2, label="unstable")
plt.plot([Dc, 1.2], [0, 0], color=gruen, lw=3)
plt.axvline(Dc, color="0.5", ls=":"); plt.plot(D, bst(D), "ko")
print(f"D_c = K(n_in) = {Dc:.4f} per hour")
for DD in [0.2, 0.5, 0.9]:
    print(f"D = {DD}: b* = {bst(DD):.4f} g/l,  yield D b* = {DD * bst(DD):.4f} g/(l h)")
plt.xlim(0, 1.2); plt.ylim(-1.5, 5.5); plt.xlabel("Dilution rate D (per hour)"); plt.ylabel("b* (g/l)"); plt.legend(loc="lower left")
plt.show()
