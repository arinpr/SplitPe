# SplitPee - Google Play Store Deployment Guide

**Application**: SplitPee - Smart UPI Split  
**Developer & Owner**: Anupam Pradhan  
**Support Email**: anupampradhan161@gmail.com  
**Application ID**: `com.anupampradhan.splitpee`  
**Version**: 1.0.0 (Version Code: 2)  
**Target SDK**: API 36  
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

## 4. Production Release Keystore (Generated & Verified)

Your production upload keystore has been generated and verified at:
`C:\Users\arind\Documents\SplitPe\upload-keystore.jks`

- **Keystore Path**: `C:\Users\arind\Documents\SplitPe\upload-keystore.jks`
- **Key Alias**: `splitpee_upload_key`
- **Store Password**: `SplitPee@Play2026!`
- **Key Password**: `SplitPee@Play2026!`
- **Certificate Validity**: Until **February 3, 2054** (10,000 days)
- **SHA-1 Fingerprint**: `5C:B8:51:23:BD:F1:07:79:73:19:28:D0:2E:43:87:F7:FE:7A:3C:2E`
- **SHA-256 Fingerprint**: `91:B5:42:04:55:31:DC:4F:2D:F1:DA:27:FC:C8:1D:EA:22:74:52:BE:65:D6:F2:CF:E8:4C:1C:76:53:E4:A3:B5`

> ⚠️ **IMPORTANT**: `upload-keystore.jks` and `key.properties` are listed in `.gitignore` to prevent accidental commits. Back up `upload-keystore.jks` in a secure location (such as Google Drive or a password manager).

---

## 5. Configured `android/key.properties`

Active configuration:

```properties
storePassword=SplitPee@Play2026!
keyPassword=SplitPee@Play2026!
keyAlias=splitpee_upload_key
storeFile=C:/Users/arind/Documents/SplitPe/upload-keystore.jks
```

---

## 6. Production Release App Bundle (AAB Built & Signed)

Your signed Android App Bundle is built, verified, and ready for Google Play Console upload:

📂 **Release Bundle Path**:  
`C:\Users\arind\Documents\SplitPe\build\app\outputs\bundle\release\app-release.aab`

To rebuild in the future:
```powershell
flutter build appbundle --release
```

---

## 7. Pre-Launch Checklist

- [x] App Name updated to `SplitPee - Smart UPI Split`
- [x] Application ID set to `com.anupampradhan.splitpee`
- [x] Compile SDK: 36 (Android 16 preview/back-compat) & Target SDK: 35 (Android 15)
- [x] Pure light liquid-glass theme with spring physics and lens refraction
- [x] ProGuard / R8 rules configured in `android/app/proguard-rules.pro`
- [x] AndroidManifest configured with camera permission (`required=false`) and complete UPI `<queries>`
- [x] Live Privacy Policy at `https://splitpee.vercel.app/privacy-policy` with Anupam Pradhan ownership and `anupampradhan161@gmail.com`
- [x] All tests passing (`flutter analyze` & `flutter test`)
- [x] Release App Bundle built and signed (`build/app/outputs/bundle/release/app-release.aab`)
- [ ] Upload `app-release.aab` to Google Play Console (Production or Closed Testing track)
