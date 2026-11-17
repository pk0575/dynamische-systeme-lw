# Fig. 3.8: Exponential growth and decay (book, Section 3.2, Eq. 3.15 and 3.16)
# x(t) = e^(0.5 t) and x(t) = e^(-0.5 t); left linear, right logarithmic axis (where both become straight lines)
# (c) 2026 Philipp Kügler · Program for the book "Dynamical Systems in the Life Sciences" · MIT License (see LICENSE)
import numpy as np
import matplotlib.pyplot as plt
t = np.linspace(0, 6, 300)
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
for ax in axs:
    ax.plot(t, np.exp(0.5 * t), color=(0.43, 0.04, 0.12), lw=2, label="e^(0.5t) (growth)")
    ax.plot(t, np.exp(-0.5 * t), "--", color=(0.89, 0.44, 0.49), lw=2, label="e^(-0.5t) (decay)")
    ax.set_xlabel("t")
axs[0].set_title("linear axis"); axs[0].legend()
axs[1].set_yscale("log"); axs[1].set_title("logarithmic axis: straight lines")
print(f"doubling time ln(2)/0.5 = {np.log(2) / 0.5:.4f},  half-life = {np.log(2) / 0.5:.4f}")
plt.tight_layout()
plt.show()
