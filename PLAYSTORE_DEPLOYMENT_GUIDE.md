# SplitPee - Google Play Store Deployment Guide

**Application**: SplitPee - Smart UPI Split  
**Developer & Owner**: Anupam Pradhan  
**Support Email**: anupampradhan161@gmail.com  
**Application ID**: `com.anupampradhan.splitpee`  
**Version**: 1.0.0 (Version Code: 1)  
**Target SDK**: Android 15 (API 35)  
**Minimum SDK**: Android 7.0 (API 24+)  

---

## 1. Google Play Store Listing Details

### App Details
- **App Name** (max 30 chars): `SplitPee - Smart UPI Split`
- **Package Name**: `com.anupampradhan.splitpee`
- **Default Language**: English (United States / India)
- **App Icon (512x512 PNG)**: Ready in project root: [playstore_icon_512.png](file:///c:/Users/arind/Documents/SplitPe/playstore_icon_512.png) *(Upload this under Store presence > Main store listing > App icon)*

### Short Description (Max 80 chars)
> Organise bills, split group expenses & pay effortlessly with your favourite UPI app.

### Full Description (Max 4000 chars)
```
SplitPee makes large bills and shared group expenses effortless. Whether you're dividing dinner with friends, handling shared flat utilities, or organising payments into manageable parts, SplitPee gives you clarity and convenience with your favourite UPI apps.

✨ MODERN LIQUID GLASS DESIGN
Designed with an ultra-clean, elegant light liquid-glass interface. Fluid spring physics, optical lens reflections, and intuitive navigation provide a smooth, delightful experience.

⚡ SMART BILL TRANCHING
Organise large payments into clean, manageable splits that comply with your preferred bank or wallet limits. Generate instantaneous UPI payment intents for Google Pay, PhonePe, Paytm, BHIM, CRED, Navi, and more.

👥 SPLIT EQUALLY WITH FRIENDS
Dining out with friends or planning a group trip?
• Enter the bill total and select the number of people.
• SplitPee calculates exact mathematical shares down to the paisa.
• Share direct payment links via WhatsApp, SMS, or any messaging app with a single tap.
• Friends can pay their individual shares straight to the merchant.

📷 ON-DEVICE UPI QR SCANNER
Point your camera at any merchant BharatQR or standard UPI QR code. SplitPee reads the recipient and bill details instantly on your device. Never worry about mistyping a UPI ID again!

🔒 100% PRIVATE & OFFLINE-FIRST
• No account creation or login required.
• Zero servers, zero databases, zero cloud uploads.
• All bill splitting calculations run strictly in your phone's memory.
• When you close the app, your session data is automatically cleared.
• SplitPee never accesses your bank account, UPI PIN, or financial records.

📊 ESTIMATE FEE IMPACTS
Use the built-in savings and fee estimator to calculate percentage provider rates and evaluate your payments before authorising.

DISCLAIMER:
SplitPee is an independent utility application designed to organise payment details and generate standard UPI intent links. SplitPee is not affiliated with NPCI, any bank, or payment service provider. SplitPee does not hold funds, process transactions, or verify payment status. All payments are reviewed, authenticated, and completed securely by you inside your chosen UPI application.

Created by Anupam Pradhan.
© 2026 Anupam Pradhan. All rights reserved.
Support: anupampradhan161@gmail.com
```

### Store Categorization & Tags
- **Application Type**: App
- **Category**: Finance (or Productivity / Tools)
- **Tags**: Personal Finance, Bill Split, UPI Payments, Expense Tracker, Productivity

---

## 2. Official Website & Privacy Policy URLs (Google Play Console)

Enter these exact live URLs in Google Play Console under **Policy and programs > App content > Privacy policy** and **Store settings > Store listing contact details**:

- **Official Privacy Policy URL**:  
  `https://splitpee.vercel.app/privacy-policy`  
  *(Live, fully verified, includes developer contact, camera disclosure, zero-data storage policy)*
- **Official Website**:  
  `https://splitpee.vercel.app`  
  *(Live Next.js landing page with web bill splitter and direct Google Play link)*

---

## 3. Data Safety Declaration (Google Play Console)

When completing the Google Play **Data Safety Form**:

| Question | Answer |
| :--- | :--- |
| **Does your app collect or share user data?** | **No** (SplitPee collects 0 user data) |
| **Is all user data encrypted in transit?** | Yes (No data is transmitted over the network) |
| **Do you provide a way for users to request data deletion?** | Yes (No data is retained; closing the app purges memory) |
| **Financial Info (Bank account / Credit card)?** | **Not collected** |
| **Location / Personal Info / Health?** | **Not collected** |
| **Photos / Videos / Files?** | **Not collected** |
| **Camera usage?** | Optional on-device processing only (used exclusively to detect QR codes locally; no frames saved or uploaded). |

---

## 4. Generating Your Production Release Keystore

Run the following command in PowerShell / Terminal to generate your production upload keystore:

```powershell
keytool -genkey -v -keystore C:\Users\arind\Documents\SplitPe\upload-keystore.jks `
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
  -alias splitpee_upload_key `
  -dname "CN=Anupam Pradhan, OU=SplitPee, O=Anupam Pradhan, L=Bhubaneswar, ST=Odisha, C=IN"
```

> ⚠️ **CRITICAL**: Store `upload-keystore.jks` in a secure location and back it up. If lost, Google Play will not allow you to update the app without contacting Play Console support for key reset.

---

## 5. Setting Up `android/key.properties`

Create a file named `android/key.properties` (this file is already in `.gitignore`):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=splitpee_upload_key
storeFile=C:/Users/arind/Documents/SplitPe/upload-keystore.jks
```

---

## 6. Building the Release App Bundle (AAB)

To create the release Android App Bundle for Google Play Console submission:

```powershell
flutter clean
flutter pub get
flutter build appbundle --release
```

The output bundle will be generated at:
`build/app/outputs/bundle/release/app-release.aab`

---

## 7. Pre-Launch Checklist

- [x] App Name updated to `SplitPee - Smart UPI Split`
- [x] Application ID set to `com.anupampradhan.splitpee`
- [x] Compile SDK: 35 (Android 15) & Target SDK: 35
- [x] Pure light liquid-glass theme with spring physics and lens refraction
- [x] ProGuard / R8 rules configured in `android/app/proguard-rules.pro`
- [x] AndroidManifest configured with camera permission (`required=false`) and complete UPI `<queries>`
- [x] Privacy Policy generated with Anupam Pradhan ownership and `anupampradhan161@gmail.com`
- [x] All tests passing (`flutter analyze` & `flutter test`)
- [ ] Run `flutter build appbundle --release`
- [ ] Upload `app-release.aab` to Google Play Console Internal Testing or Production track
