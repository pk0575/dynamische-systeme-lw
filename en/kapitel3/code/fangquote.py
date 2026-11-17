# Fig. 3.17: Harvesting with a fixed catch quota (book, Section 3.3)
# dx/dt = r (1 - x/K) x - q with r = 0.5, K = 100;  steady at x* = K/2 (1 ± sqrt(1 - 4q/(rK))) as long as q <= rK/4 = 12.5
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.5, 100
gruen = (0, 0.39, 0)
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
x = np.linspace(0, 100, 300)
axs[0].plot(x, r * x * (1 - x / K), color=(0, 0.447, 0.741), lw=2.5, label="Growth")
for q, ls in zip([8, 12.5, 16], ["-", "--", ":"]):
    axs[0].axhline(q, color=(0.64, 0.08, 0.18), lw=2, ls=ls, label=f"q = {q}")
axs[0].set_xlabel("x (1000 t)"); axs[0].set_title("Growth r x (1 - x/K) and catch q"); axs[0].legend()
q = np.linspace(0, 12.5, 300)
w = np.sqrt(1 - 4 * q / (r * K))
axs[1].plot(q, K / 2 * (1 + w), color=gruen, lw=3, label="x₊* stable")
axs[1].plot(q, K / 2 * (1 - w), "--", color=gruen, lw=2, label="x₋* unstable")
axs[1].plot(12.5, 50, "ko"); axs[1].set_xlim(0, 21)
axs[1].set_xlabel("Catch quota q (1000 t/year)"); axs[1].set_title("bifurcation diagram"); axs[1].legend(loc="lower right")
for qq in [8, 12.5]:
    ww = np.sqrt(1 - 4 * qq / (r * K))
    print(f"q = {qq}: x_- = {K / 2 * (1 - ww):.2f},  x_+ = {K / 2 * (1 + ww):.2f}")
print(f"largest catch quota (MSY): q = rK/4 = {r * K / 4}")
plt.tight_layout()
plt.show()
