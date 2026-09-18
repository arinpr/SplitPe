# SplitPee - Matching Web Application Implementation Prompt

Use the prompt below to generate or build the complete matching **SplitPee - Smart UPI Split** web application using Next.js (App Router), React, Vite, or vanilla web technologies.

---

```markdown
# Role & Objective
You are an expert full-stack web developer and UI/UX designer. Build the official web application for **SplitPee - Smart UPI Split** (short name: `SplitPee`), owned and created by **Anupam Pradhan** (`© 2026 Anupam Pradhan. All rights reserved.`, support email: `anupampradhan161@gmail.com`).

The web app is a 100% client-side, privacy-first UPI bill-tranching and group-expense organizer that allows users in India to enter a merchant bill, split it into equal or custom tranches (or split equally among friends), generate standard UPI payment QR codes, copy payment links, and trigger UPI apps directly via deep links.

---

## 🎨 Visual Design & Aesthetics (STRICT REQUIREMENT)
- **THEME**: Pure, modern, luminous LIGHT theme only. Do NOT use dark mode.
- **DESIGN SYSTEM**: High-end "Liquid Glass" inspired by [Kyant0/AndroidLiquidGlass](https://github.com/Kyant0/AndroidLiquidGlass):
  - **Background**: Ambient light mesh gradient (`#F3F8FB` to `#EBF5F6` to `#F6F7FD`) with smooth, slowly drifting caustic light orbs (mint `#6EE7B7`, sky blue `#38BDF8`, and soft lavender `#C084FC`) blurred with `filter: blur(80px)`.
  - **Liquid Glass Cards**:
    - `backdrop-filter: blur(24px) saturate(180%)`
    - Background: `linear-gradient(135deg, rgba(255,255,255,0.85) 0%, rgba(255,255,255,0.65) 100%)`
    - Specular rim bevel: `border: 1.5px solid rgba(255, 255, 255, 0.95)`
    - Drop shadow: `box-shadow: 0 20px 48px rgba(15, 62, 80, 0.08), 0 4px 12px rgba(15, 62, 80, 0.02)`
    - Corner radius: `24px` to `28px`
  - **Liquid Spring Buttons**:
    - Capsule radius (`999px` or `20px`)
    - Smooth cubic-bezier spring scale down (`transform: scale(0.96)`) on click/press with bouncy elastic recovery
    - Subtle top specular gloss pill reflection
    - Gradient: Emerald/Teal `linear-gradient(135deg, #087F75, #0D9488)`
  - **Interactive Touch / Mouse Sheen**:
    - Track cursor pointer coordinates on cards to project a subtle radial lens flare (`radial-gradient(circle at X Y, rgba(255,255,255,0.35) 0%, transparent 60%)`).
  - **Floating Capsule Navigation Dock**:
    - Fixed or floating bottom capsule dock (`backdrop-filter: blur(28px)`) with sliding indicator pill that transitions between tabs with spring bounce and slight horizontal stretch during movement.

---

## 📱 Core Features & Application Views

### 1. Header & Navigation
- **Brand Logo**: Rounded badge featuring split arrows in mint-teal gradient + "SplitPee" title (bold 800) + "Smart UPI Split" subtitle.
- **Navigation Tabs**:
  1. `Split` (Bill tranching for single payer)
  2. `Friends` (Group bill split among 2 to 20 people)
  3. `Estimate` (Provider percentage fee calculator)
  4. `About & Privacy` (Ownership, copyright, privacy policy, and support)
- **Top QR Scan Button**: Opens camera scanner modal to read merchant UPI QR code.

### 2. Tab 1: Smart Bill Tranching (`Split`)
- Bill amount input in INR with auto paise conversion (no float rounding errors).
- Maximum per-split limit input (defaults to ₹1,999).
- Recipient UPI ID input (validates `[user]@[bank]`).
- Optional recipient name and bill note ("Dinner", "Electronics", etc.).
- Calculates required number of parts:
  - Total divided into clean integer paise across parts.
  - Generates standard UPI URI: `upi://pay?pa={vpa}&pn={name}&am={amount}&cu=INR&tn={note}&tr={ref}`.
- Clicking "Preview My Split" opens the interactive modal.

### 3. Tab 2: Split with Friends (`Friends`)
- Shared bill amount input.
- Stepper for number of people (2 to 20 people).
- Exact down-to-the-paisa equal distribution (e.g. ₹100.00 / 3 = ₹33.34, ₹33.33, ₹33.33).
- Generates individual share links with pre-filled payer notes ("Dinner share for Friend 1").
- One-click native Web Share API or Clipboard copy to send links to WhatsApp / Telegram.

### 4. Interactive Split Review Modal
- Progress bar showing paid checklist completion.
- Horizontal tab selector between Part 1, Part 2, ..., Part N.
- High-resolution SVG/Canvas QR Code generated using `qrcode.react` or `qr-code-styling`.
- Big bold amount display (e.g., `₹1,999.00`).
- Recipient VPA and Merchant Name display.
- Action Buttons:
  - **"Pay with a UPI App"**: Deep links directly to `upi://pay?...`.
  - **"Copy Link"**: Copies raw UPI URI or payment request.
  - **"Share"**: Triggers `navigator.share()` with custom formatted message.
  - **"Mark as Paid"**: Toggles local checkbox (with confirmation dialog reminding the user that SplitPee does not access bank APIs).

### 5. Tab 3: Provider Fee Estimator (`Estimate`)
- Calculate what payment providers charge on percentage fee models.
- Inputs: Bill Amount + Fee Rate (%).
- Returns clean, large estimated fee display.

### 6. Tab 4: About & Privacy Policy
- Developer & Owner: **Anupam Pradhan**
- Copyright: **© 2026 Anupam Pradhan. All rights reserved.**
- Support Email: **anupampradhan161@gmail.com** with `mailto:` button.
- Comprehensive privacy policy text:
  - Zero data collection, zero servers, zero cookies, zero analytics.
  - 100% client-side memory processing.
  - Independent utility disclaimer (not affiliated with NPCI or banks).

### 7. QR Scanner Modal
- Uses `html5-qrcode` or `@zxing/library` to access user camera securely via `navigator.mediaDevices.getUserMedia`.
- Fallback manual input dialog if camera is unavailable or denied.
- Automatically parses scanned `upi://pay?pa=...` parameters.

---

## 🛠 Tech Stack Recommendations
- **Framework**: Next.js 14/15 (App Router) or Vite + React 18/19
- **Language**: TypeScript
- **Styling**: Vanilla CSS Modules or Tailwind CSS with custom frosted glass utilities
- **Icons**: Lucide React (`lucide-react`)
- **QR Code**: `qrcode.react`
- **QR Scanner**: `html5-qrcode`
- **Animations**: `framer-motion` (for spring physics and sliding pill dock)
- **Haptics**: `navigator.vibrate?.([15])` on touch actions (where supported)

Ensure the web application is fully responsive (mobile-first layout max-width 640px centered on desktop) and optimized for PWA installation (`manifest.json` included).
```
