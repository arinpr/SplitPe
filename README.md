# ⚡ SplitPee - Smart UPI Split

<div align="center">
  <h3><strong>Smart UPI Bill Tranching & Group Expense Organizer</strong></h3>
  <p>A modern, light liquid-glass Flutter application designed for effortless bill splitting and UPI payment organization.</p>

  <p>
    <strong>Owner & Creator:</strong> Anupam Pradhan &nbsp;|&nbsp;
    <strong>Support:</strong> anupampradhan161@gmail.com &nbsp;|&nbsp;
    <strong>Application ID:</strong> <code>com.anupampradhan.splitpee</code>
  </p>
</div>

---

## 💡 The Concept: Smart UPI Tranching

Under Indian digital payment rules, transactions strictly under ₹2,000 (capped at **₹1,999**) have distinct interchange fee structures and bank processing tiers compared to large single lump-sum transactions.

**SplitPee** programmatically organizes high-ticket bills and dining tabs into optimal, compliant micro-splits capped at **₹1,999.00**:

$$\text{Total Bill} = \sum_{i=1}^{n} \text{Split}_i \quad \text{where} \quad \forall i, \; \text{Split}_i \le ₹1,999.00$$

### ⚙️ Tranching Strategies
1. **₹1,999 Slices (Max Cap)**: Slices the bill into full ₹1,999 chunks, with the remainder in the final split (e.g. ₹5,000 $\rightarrow$ ₹1,999 + ₹1,999 + ₹1,002; ₹2,000 $\rightarrow$ ₹1,999 + ₹1).
2. **Equal Shares**: Balances the bill into equal parts where every part is strictly $\le ₹1,999$ (e.g. ₹5,000 $\rightarrow$ ₹1,666.67 + ₹1,666.67 + ₹1,666.66; ₹2,000 $\rightarrow$ ₹1,000 + ₹1,000).

---

## ✨ Features

- 💎 **Modern Light Liquid-Glass UI**: High-end light aesthetic inspired by [Kyant0/AndroidLiquidGlass](https://github.com/Kyant0/AndroidLiquidGlass) featuring optical refraction, specular bevel rim highlights, dynamic caustic lighting mesh, and fluid spring physics.
- ⚡ **Strict ₹1,999 Cap**: Guarantees that every generated split is $\le ₹1,999.00$, perfectly avoiding the ₹2,000 threshold.
- 👥 **Group Bill Splitter**: Splits dining and shared bills with friends down to the exact paisa, generating instant share links for WhatsApp, Telegram, and SMS.
- 📷 **On-Device QR Scanner**: Reads BharatQR and merchant UPI QR codes using Google ML Kit on-device without capturing or uploading images.
- 🔒 **100% Private & Offline-First**: Zero databases, zero servers, zero cookies, and zero trackers. All calculations run strictly in volatile device memory.
- 📊 **Provider Fee Estimator**: Visualizes percentage provider rates to evaluate charges before paying.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.11.3`)
- **Design System**: Liquid Glass Architecture with BackdropFilter and physics-based spring animations
- **Target Platforms**: Android (Target SDK 35, Android 15), Web, iOS
- **Camera & Scanner**: [`mobile_scanner`](https://pub.dev/packages/mobile_scanner)
- **QR Generation**: [`qr_flutter`](https://pub.dev/packages/qr_flutter)
- **Sharing & Intents**: [`url_launcher`](https://pub.dev/packages/url_launcher), [`share_plus`](https://pub.dev/packages/share_plus)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.24.0`
- Android Studio / Android SDK 35 (API 35)

### Installation & Run

```bash
# 1. Install dependencies
flutter pub get

# 2. Run in Chrome or connected Android device
flutter run -d chrome
# or
flutter run -d android
```

---

## 🧪 Testing

```bash
# Run unit & widget test suites
flutter test

# Run code analyzer
flutter analyze
```

---

## 📦 Building for Google Play Store

See [PLAYSTORE_DEPLOYMENT_GUIDE.md](PLAYSTORE_DEPLOYMENT_GUIDE.md) for full release instructions, store copy, and Data Safety form answers.

```bash
# Build production App Bundle (AAB)
flutter build appbundle --release
```

The output bundle will be generated at:
`build/app/outputs/bundle/release/app-release.aab`

---

## 📄 License & Ownership

Created by **Anupam Pradhan**.  
© 2026 Anupam Pradhan. All rights reserved.  
Support: `anupampradhan161@gmail.com`
