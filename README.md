# Multivariate Multiscale Multi-Frequency Entropy (M3FrEn)

This repository contains MATLAB code for _Multivariate Multiscale Multi-Frequency Entropy (M3FrEn)_. M3FrEn is a novel entropy-based metric for EEG signal analysis that simultaneously incorporates multiscale dynamics, multichannel dependencies, and multi-frequency structure into a unified framework. This metric is introduced in the work:

> _"A Novel Entropy Metric for Unified Analysis of Temporal, Spatial, and Spectral EEG Properties"_  

In this work, we propose **M3FrEn** as a robust and interpretable measure of EEG signal complexity, capturing:
- **Temporal variability** via multiscale coarse-graining and embedding.
- **Spectral diversity** via symbolic permutation analysis across δ, θ, α, β bands.
- **Spatial structure** via multichannel embedding.
  
This work extends previous approaches like **mFrEn** [[Niu et al., 2024](https://doi.org/10.3390/e26090728)] by including the **delta band**, and introduces **M2FrEn** and **M3FrEn** as the **univariate and multivariate multiscale** generalizations, respectively.

---
## 🧠 About the Metrics

| Metric     | Type         | Dimensions       | Notes |
|------------|--------------|------------------|-------|
| `mFrEn`    | Univariate   | Single-scale     | Based on [Niu et al., 2024]. Modified here to include delta (δ) band. |
| `M2FrEn`   | Univariate   | **Multiscale**   | Our proposed extension of mFrEn with multiscale approach. |
| `M3FrEn`   | **Multivariate** | **Multiscale**   | Our main contribution — generalization of mFrEn across channels, frequencies, and time scales. |
---
**EEG bands considered**:
- δ (0.5–4 Hz)
- θ (4–8 Hz)
- α (8–13 Hz)
- β (13–30 Hz)
---
## 📂 Repository Structure

- `MAIN.m` – Main script to simulate EEG data and compute mFrEn, M2FrEn, and M3FrEn.
- `mFrEn.m` – Modified implementation of multi-frequency entropy for a single-channel signals (with delta band).
- `M2FrEn.m` – Multiscale generalization of `mFrEn` (univariate).
- `M3FrEn.m` – Main proposed metric: multiscale, multivariate, multi-frequency entropy.
- `Multi.m` – Coarse-graining function for univariate signals.
- `Multivariate_Multi.m` – Coarse-graining function for multivariate signals.
- `embd.m` – Time-delay embedding for univariate signals.
- `embd_multivariate.m` – Time-delay embedding for multivariate signals.

---

## ⚙️ How to Use

1. Open MATLAB and navigate to the project folder.
2. Run `MAIN.m`.

The script generates synthetic EEG signals with controlled noise and structure using a **Mix Model**, and evaluates the three entropy metrics across channels and scales. Results are plotted automatically.

---

## 📈 Outputs

- `mFrEn`: Single entropy value per channel.
- `M2FrEn`: Scale-dependent entropy trend per channel.
- `M3FrEn`: Unified entropy trend combining all channels and frequencies.

---

## 📚 Reference

If you use this code, please cite:

