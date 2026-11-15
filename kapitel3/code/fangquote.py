# Abb. 3.17: Ernte mit fester Fangquote (Buch, Abschnitt 3.3)
# dx/dt = r (1 - x/K) x - q mit r = 0.5, K = 100;  stationär bei x* = K/2 (1 ± sqrt(1 - 4q/(rK))), solange q <= rK/4 = 12.5
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt
r, K = 0.5, 100
gruen = (0, 0.39, 0)
fig, axs = plt.subplots(1, 2, figsize=(11, 4.5))
x = np.linspace(0, 100, 300)
axs[0].plot(x, r * x * (1 - x / K), color=(0, 0.447, 0.741), lw=2.5, label="Zuwachs")
for q, ls in zip([8, 12.5, 16], ["-", "--", ":"]):
    axs[0].axhline(q, color=(0.64, 0.08, 0.18), lw=2, ls=ls, label=f"q = {q}")
axs[0].set_xlabel("x (1000 t)"); axs[0].set_title("Zuwachs r x (1 - x/K) und Fang q"); axs[0].legend()
q = np.linspace(0, 12.5, 300)
w = np.sqrt(1 - 4 * q / (r * K))
axs[1].plot(q, K / 2 * (1 + w), color=gruen, lw=3, label="x₊* stabil")
axs[1].plot(q, K / 2 * (1 - w), "--", color=gruen, lw=2, label="x₋* instabil")
axs[1].plot(12.5, 50, "ko"); axs[1].set_xlim(0, 21)
axs[1].set_xlabel("Fangquote q (1000 t/Jahr)"); axs[1].set_title("Bifurkationsdiagramm"); axs[1].legend(loc="lower right")
for qq in [8, 12.5]:
    ww = np.sqrt(1 - 4 * qq / (r * K))
    print(f"q = {qq}: x_- = {K / 2 * (1 - ww):.2f},  x_+ = {K / 2 * (1 + ww):.2f}")
print(f"größte Fangquote (MSY): q = rK/4 = {r * K / 4}")
plt.tight_layout()
plt.show()
