# Abb. 2.16: Szenario B des SIR-Modells in der Phasenebene (Buch, Abschnitt 2.4, Gl. 2.21)
# Zustände (S_n, I_n), hell: früh, dunkel: spät; Kreuz: stationärer Zustand x_b* = (N/R_0, alpha (N - S*)/(gamma + alpha))
# (c) 2026 Philipp Kügler · Programm zum Buch „Dynamische Systeme in den Lebenswissenschaften“ · MIT-Lizenz (siehe LICENSE)
import numpy as np
import matplotlib.pyplot as plt

N, alpha, gamma, beta = 100000, 0.1, 0.1, 7.6e-6
schritte = 80
S, I = np.zeros(schritte + 1), np.zeros(schritte + 1)
S[0], I[0] = 99999, 1
for n in range(schritte):
    S[n + 1] = S[n] - beta * S[n] * I[n] + alpha * (N - S[n])
    I[n + 1] = I[n] + beta * S[n] * I[n] - (gamma + alpha) * I[n]

R0 = beta * N / (gamma + alpha)
Ss = N / R0; Is = alpha * (N - Ss) / (gamma + alpha)
print(f"R_0 = {R0:.1f},  stationärer Zustand x_b*: S* = {Ss:.0f}, I* = {Is:.0f}")
print(f"(S_80, I_80) = ({S[-1]:.0f}, {I[-1]:.0f})")

plt.plot(S, I, color="0.75", lw=0.8)
plt.scatter(S, I, c=np.arange(schritte + 1), cmap="Reds", vmin=-25)
plt.plot(Ss, Is, "kx", ms=12, mew=2)
plt.plot(N, 0, "ko", mfc="w")                          # x_a* = (N, 0): krankheitsfrei
plt.xlabel("S_n"); plt.ylabel("I_n")
plt.show()
