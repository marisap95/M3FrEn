# M3FrEn

This repository consists of the MATLAB code of _Multivariate Multiscale Multi-Frequency Entropy (M3FrEn)_. M3FrEn is a novel complexity metric for signal analysis that simultaneously incorporates multiscale dynamics, multichannel dependencies, and multi-frequency structure into a unified entropy-based framework. This metric is introduced in the work:

> _"A Novel Entropy Metric for Unified Analysis of Temporal, Spatial, and Spectral EEG Properties"_  

Moreover, the 
This repository contains MATLAB implementations of three entropy-based metrics — mFrEn, M2FrEn, and M3FrEn — for analyzing EEG signals across multiple frequency bands. 


# 🧠 Multi-Frequency Entropy Metrics for EEG Analysis (M3FrEn, M2FrEn, mFrEn-Δ)

This repository contains MATLAB code for computing advanced entropy-based complexity metrics for EEG signal analysis. The core focus is on a novel entropy formulation called **M3FrEn** (Multivariate Multiscale Multi-Frequency Entropy), developed to unify temporal, spectral, and spatial analysis in a single framework.

This work extends previous approaches like **mFrEn** by including the **delta band**, and introduces **M2FrEn** and **M3FrEn** as the **univariate and multivariate multiscale** generalizations, respectively.

---

## 🧪 About the Metrics

| Metric     | Type         | Dimensions       | Notes |
|------------|--------------|------------------|-------|
| `mFrEn`    | Univariate   | Single-scale     | Based on [Niu et al., 2024]. Modified here to include delta (δ) band. |
| `M2FrEn`   | Univariate   | **Multiscale**   | Our proposed extension of mFrEn. |
| `M3FrEn`   | **Multivariate** | **Multiscale**   | Our main contribution — generalization of mFrEn across channels, frequencies, and time scales. |

**EEG bands considered**:
- Delta (0.5–4 Hz)
- Theta (4–8 Hz)
- Alpha (8–13 Hz)
- Beta (13–30 Hz)

---

## 📂 Repository Structure

- `MAIN.m` – Main script to simulate EEG data and compute mFrEn, M2FrEn, and M3FrEn.
- `mFrEn.m` – Modified implementation of multi-frequency entropy for a single-channel signal (with delta band).
- `M2FrEn.m` – Multiscale generalization of `mFrEn` (univariate).
- `M3FrEn.m` – Main proposed metric: multiscale, multivariate, multi-frequency entropy.
- `Multi.m` – Coarse-graining function (univariate).
- `Multivariate_Multi.m` – Coarse-graining function (multichannel).
- `embd.m` – Time-delay embedding for univariate signals.
- `embd_multivariate.m` – Multivariate embedding function.

---

## 🧰 How to Use

1. Clone this repository.
2. Open MATLAB and navigate to the project folder.
3. Run `MAIN.m`.

The script generates synthetic EEG signals with controlled noise and structure using a **Mix Model**, and evaluates the entropy metrics across channels and scales. Results are plotted automatically.

---

## 📈 Outputs

- `mFrEn`: Single entropy value per channel.
- `M2FrEn`: Scale-dependent entropy profile per channel.
- `M3FrEn`: Unified entropy profile combining all channels and frequencies.

---

## 🔬 Scientific Context

This repository supports the experimental validation of the work:

> **A Novel Entropy Metric for Unified Analysis of Temporal, Spatial, and Spectral EEG Properties**  


In this work, we propose **M3FrEn** as a robust and interpretable measure of EEG signal complexity, capturing:
- **Temporal variability** via multiscale coarse-graining and embedding.
- **Spectral diversity** via symbolic permutation analysis across δ, θ, α, β bands.
- **Spatial structure** via multichannel embedding.

M3FrEn was shown to outperform state-of-the-art metrics (e.g., MvMPE, MvMFE) in:
- Signal complexity discrimination
- Noise robustness
- Stability over short data lengths
- Real clinical use (e.g., distinguishing Alzheimer’s disease vs. healthy controls)

---

## 📚 Reference

If you use this code, please cite:

