# Fig. 3.10: Growth of E. coli with a doubling time of 20 minutes (book, Section 3.2, Eq. 3.18)
# x(t) = 1000 · 2^(t/20) = 1000 e^(r t) with r = ln(2)/20 per minute
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
tV, x0 = 20, 1000
r = np.log(2) / tV
t = np.linspace(0, 120, 300)
plt.plot(t, x0 * np.exp(r * t), color=(0.64, 0.08, 0.18), lw=2.5)
for k in range(1, 7):
    plt.plot([tV * k, tV * k], [0, x0 * 2**k], ":", color="0.5"); plt.plot(tV * k, x0 * 2**k, "ko")
print(f"r = ln(2)/20 = {r:.5f} per minute;  x(120) = {x0 * np.exp(r * 120):.0f} cells")
plt.xlabel("t (min)"); plt.ylabel("cells"); plt.xticks(range(0, 121, 20))
plt.show()
