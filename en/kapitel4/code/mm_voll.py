# Fig. 4.13: Michaelis-Menten system with all four concentrations (book, Section 4.3, Eq. 4.12)
# k1 = 1, k2 = 1e-4, k3 = 0.1, [S]0 = 0.5 µM, [E]0 = 0.2 µM, [SE]0 = [P]0 = 0
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
k1, k2, k3 = 1.0, 1e-4, 0.1                # rates in 1/(µM s) and 1/s
S0 = 0.5                                   # µM
k50 = (k2 + k3) / k1
def mm(t, z):
    S, E, C, P = z                         # substrate, enzyme, complex SE, product
    r1, r2, r3 = k1 * S * E, k2 * C, k3 * C
    return [-r1 + r2, -r1 + r2 + r3, r1 - r2 - r3, r3]

E0 = 0.2
t = np.linspace(0, 60, 3001)
s = solve_ivp(mm, [0, 60], [S0, E0, 0, 0], t_eval=t, method="LSODA", rtol=1e-10, atol=1e-13)
S, E, C, P = s.y
print("conservation [E] + [SE] = E0 up to rounding errors (< 1e-12):", "yes" if np.max(abs(E + C - E0)) < 1e-12 else "no")
for tt in [5, 20, 60]:
    i = np.searchsorted(t, tt)
    print(f"t = {tt:2d} s: [S] = {S[i]:.4f}, [E] = {E[i]:.4f}, [SE] = {C[i]:.4f}, [P] = {P[i]:.4f}")
farben = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49), (0.95, 0.70, 0.73)]
for y, name, fa, m in zip([S, E, C, P], ["Substrate [S]", "Enzyme [E]", "Complex [SE]", "Product [P]"], farben, "osD^"):
    plt.plot(t, y, "-" + m, color=fa, lw=2, markevery=250, label=name)
plt.xlabel("t (s)"); plt.ylabel("Concentration (µM)"); plt.legend(ncol=2)
plt.show()
