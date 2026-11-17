# Fig. 3.16: Fish stock with harvesting, steady states as a function of the harvesting rate (book, Section 3.3)
# dx/dt = r (1 - x/K) x - h x with r = 0.5 per year, K = 100 (1000 t):  x_a* = 0 and x_b* = K (1 - h/r)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.5, 100
gruen = (0, 0.39, 0)
h = np.linspace(0, 1, 301)
li, re = h <= r, h >= r
plt.plot(h[li], 0 * h[li], "--", color=gruen, lw=2)                  # x_a* unstable for h < r
plt.plot(h[re], 0 * h[re], color=gruen, lw=3)                        # stable for h > r
plt.plot(h[li], K * (1 - h[li] / r), color=gruen, lw=3)              # x_b* stable for h < r
nah = (h >= r) & (h <= 0.62)
plt.plot(h[nah], K * (1 - h[nah] / r), "--", color=gruen, lw=2)
plt.axvline(r, color="k", ls=":", lw=1)
for hh in [0.1, 0.25, 0.4]:
    print(f"h = {hh}: x_b* = {K * (1 - hh / r):.0f},  yield h x_b* = {hh * K * (1 - hh / r):.2f}")
plt.xlabel("Harvesting rate h (per year)"); plt.ylabel("x* (1000 t)"); plt.ylim(-30, 105)
plt.show()
