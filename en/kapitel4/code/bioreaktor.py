# Fig. 4.20: Biomass and nutrient in the bioreactor (book, Section 4.4, Eq. 4.17)
# db/dt = K(n) b - D b,  dn/dt = -nu K(n) b - D n + D n_in  with K(n) = kmax n/(k50 + n), D = 0.2, n_in = 10, nu = 2, kmax = 1, k50 = 0.5
# start with b(0) = 0.1 g/l and n(0) = n_in; dashed the steady state n* = D k50/(kmax - D), b* = (n_in - n*)/nu
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
D, nin, nu, kmax, k50 = 0.2, 10, 2, 1.0, 0.5    # D in 1/h, concentrations in g/l
K = lambda n: kmax * n / (k50 + n)                  # Monod growth rate

f = lambda t, z: [K(z[1]) * z[0] - D * z[0], -nu * K(z[1]) * z[0] - D * z[1] + D * nin]
t = np.linspace(0, 20, 2001)
s = solve_ivp(f, [0, 20], [0.1, nin], t_eval=t, rtol=1e-9, atol=1e-11)
b, n = s.y
ns = D * k50 / (kmax - D); bs = (nin - ns) / nu
print(f"steady state: n* = {ns:.4f} g/l,  b* = {bs:.4f} g/l")
print(f"b(20) = {b[-1]:.4f},  n(20) = {n[-1]:.4f};  largest biomass {b.max():.4f} at t = {t[b.argmax()]:.2f} h")
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
axs[0].axhline(bs, color="k", ls="--", lw=1); axs[0].plot(t, b, color=(0.64, 0.08, 0.18), lw=2)
axs[0].set_xlabel("t (hours)"); axs[0].set_ylabel("Biomass b (g/l)")
axs[1].axhline(ns, color="k", ls="--", lw=1); axs[1].plot(t, n, color=(0.64, 0.08, 0.18), lw=2)
axs[1].set_xlabel("t (hours)"); axs[1].set_ylabel("Nutrient n (g/l)")
plt.tight_layout()
plt.show()
