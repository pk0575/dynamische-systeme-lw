# Fig. 4.4: Classical Lotka-Volterra model (book, Section 4.1, Eq. 4.3)
# dx/dt = r x - c x y,  dy/dt = d x y - e y  with r = 1, c = 0.5, d = 0.2, e = 1
# left periodic time courses for x(0) = 3, y(0) = 2, right closed orbits for different initial values
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp
r, c, d, e = 1, 0.5, 0.2, 1
f = lambda t, z: [r * z[0] - c * z[0] * z[1], d * z[0] * z[1] - e * z[1]]
H = lambda x, y: d * x - e * np.log(x) + c * y - r * np.log(y)    # remains constant along every solution
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
t = np.linspace(0, 25, 2501)
s = solve_ivp(f, [0, 25], [3, 2], t_eval=t, rtol=1e-9, atol=1e-11)
axs[0].plot(t, s.y[0], color=(0.43, 0.04, 0.12), lw=2, label="Prey")
axs[0].plot(t, s.y[1], color=(0.89, 0.44, 0.49), lw=2, label="Predators")
axs[0].set_xlabel("t"); axs[0].legend()
rot = [(0.43, 0.04, 0.12), (0.64, 0.08, 0.18), (0.89, 0.44, 0.49)]
for i, x0 in enumerate([4, 3, 1.5]):
    s = solve_ivp(f, [0, 12], [x0, 2], t_eval=np.linspace(0, 12, 1201), rtol=1e-9, atol=1e-11)
    axs[1].plot(s.y[0], s.y[1], color=rot[i], lw=2)
    print(f"x(0) = {x0}: H at the start {H(x0, 2):.6f}, at the end {H(s.y[0][-1], s.y[1][-1]):.6f}")
axs[1].plot(e / d, r / c, "ko"); axs[1].set_xlabel("Prey x"); axs[1].set_ylabel("Predators y")
plt.tight_layout()
plt.show()
