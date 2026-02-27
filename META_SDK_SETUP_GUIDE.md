# Meta (Facebook) SDK Integration Guide — Grow First App

## What Was Done (Code Changes)

| File | Change |
|------|--------|
| `pubspec.yaml` | Added `facebook_app_events: ^0.24.0` |
| `lib/core/analytics/meta_analytics_service.dart` | **New** — singleton service wrapping the SDK |
| `lib/main.dart` | `initialize()` + `logFirstOpen()` called at startup |
| `android/app/src/main/res/values/strings.xml` | **New** — holds `facebook_app_id` + `facebook_client_token` |
| `android/app/src/main/AndroidManifest.xml` | Added 4 `<meta-data>` entries for the Facebook SDK |
| `ios/Runner/Info.plist` | Added `FacebookAppID`, `FacebookClientToken`, `fbYOUR_FACEBOOK_APP_ID` URL scheme |
| `lib/features/auth/presentation/signin_page.dart` | `logLogin(loginMethod: 'google')` + `logLogin(loginMethod: 'apple')` |
| `lib/features/auth/presentation/verify_otp_page.dart` | `logLogin(loginMethod: 'otp')` on OTP success |
| `lib/features/vendor_dashboard/presentation/vendor_registration_choose_plan.dart` | `logVendorSubscribe()` on free plan select + Razorpay success |
| `lib/features/payment/presentation/payment_mode_page.dart` | `logPurchase()` on Razorpay + Cash on Delivery success |

---

## Step 1 — Get Your App ID & Client Token from Meta Developer Console

You said you already have a developer account at https://developers.facebook.com. Here is what to do:

1. Go to **https://developers.facebook.com/apps**
2. Click your existing app (or create one if needed — choose **"Consumer"** type)
3. In the left sidebar click **Settings → Basic**
4. You will see two values you need:
   - **App ID** — a numeric string, e.g. `1234567890123456`
   - **Client Token** — click "Show" next to it, e.g. `abcdef1234567890abcdef1234567890`

> Keep these private. Never commit real values to git — use environment variables or a secrets manager for production CI/CD.

---

## Step 2 — Add Your Real Values to the Project

### Android — edit `strings.xml`

File: `android/app/src/main/res/values/strings.xml`

```xml
<string name="facebook_app_id">1234567890123456</string>
<string name="facebook_client_token">abcdef1234567890abcdef1234567890</string>
```

Replace `1234567890123456` and `abcdef1234567890abcdef1234567890` with your actual values.

---

### iOS — edit `Info.plist`

File: `ios/Runner/Info.plist`

Find and replace these three placeholders:

```xml
<!-- Replace YOUR_FACEBOOK_APP_ID in all 3 locations below -->
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>   <!-- → put your numeric App ID here -->

<key>FacebookClientToken</key>
<string>YOUR_FACEBOOK_CLIENT_TOKEN</string>  <!-- → put your client token here -->

<!-- URL Scheme must be "fb" + your App ID, e.g. fb1234567890123456 -->
<string>fbYOUR_FACEBOOK_APP_ID</string>  <!-- → e.g. fb1234567890123456 -->
```

After editing it should look like:
```xml
<key>FacebookAppID</key>
<string>1234567890123456</string>

<key>FacebookClientToken</key>
<string>abcdef1234567890abcdef1234567890</string>

<string>fb1234567890123456</string>
```

---

## Step 3 — Add Your App Platform to the Meta Developer Console

### Add Android Platform

1. Go to **Settings → Basic** in your Meta app dashboard
2. Scroll down and click **"+ Add Platform"**
3. Choose **Android**
4. Fill in:
   - **Google Play Package Name**: your app's package name (find it in `android/app/build.gradle` → `applicationId`, e.g. `com.growfirst.app`)
   - **Class Name**: `com.growfirst.app.MainActivity` (replace with your actual package)
   - **Key Hashes**: run this command on your machine and paste the output:
     ```bash
     # Debug keystore hash (for testing)
     keytool -exportcert -alias androiddebugkey \
       -keystore ~/.android/debug.keystore \
       -storepass android | openssl sha1 -binary | openssl base64
     
     # Release keystore hash (for production — use your release keystore)
     keytool -exportcert -alias YOUR_KEY_ALIAS \
       -keystore /path/to/your/release.keystore \
       -storepass YOUR_STORE_PASSWORD | openssl sha1 -binary | openssl base64
     ```
5. Click **Save Changes**

### Add iOS Platform

1. Click **"+ Add Platform"** again
2. Choose **iPhone**
3. Fill in:
   - **Bundle ID**: your iOS bundle ID (find it in Xcode → Runner target → General, e.g. `com.growfirst.app`)
4. Click **Save Changes**

---

## Step 4 — Configure Events Manager (Enable the 3 Main Events)

1. Go to **https://business.facebook.com**
2. In the left sidebar: **Events Manager**
3. Select your app from the data sources list
4. Click **"Add Events"** → **"From a new website or app"**

The 3 events are already tracked automatically by the code:

| Event Name in Meta | When it fires | Code Location |
|---|---|---|
| `fb_mobile_first_app_launch` | Every app open | `main.dart` |
| `fb_mobile_login` | OTP / Google / Apple login success | `verify_otp_page.dart`, `signin_page.dart` |
| `Purchase` | Service booking paid (Razorpay/COD) | `payment_mode_page.dart` |
| `Subscribe` | Vendor plan selected (free or paid) | `vendor_registration_choose_plan.dart` |

To verify events are arriving:
1. In Events Manager → click your app → **"Test Events"** tab
2. Run the app on a real device (events don't fire reliably on simulators)
3. Perform a login and purchase action
4. Events should appear within 1–2 minutes

---

## Step 5 — Create a Meta Ad Campaign (Run Ads)

1. Go to **https://www.facebook.com/adsmanager**
2. Click **"Create"**
3. Choose your **Campaign Objective**:
   - **"App Promotion"** → to get installs and track in-app events
   - **"Leads"** → if you want form fills
4. Under **Ad Set**:
   - Select your app
   - Set **Optimization Event** to `Purchase` or `Subscribe` (the events you are tracking)
5. Set your **Budget**, **Schedule**, and **Audience**
6. Under **Ad Creative**: upload your images/videos
7. Click **Publish**

---

## Step 6 — Track Subscriptions in the Ad Results

To see how many people who clicked your ad went on to subscribe:

1. Go to **Ads Manager → Columns → Customize Columns**
2. Add these columns:
   - **"Website Purchases"** (will show your `Purchase` events)
   - **"Subscribe"** (custom event column)
   - **"Cost per Purchase"**
   - **"ROAS (Return on Ad Spend)"**
3. You can also go to **Events Manager → your app → Event Activity** to see raw event counts

> It can take **24–48 hours** after launch for Meta to attribute conversions to specific ads.

---

## Step 7 — App Store & Play Store Setup for Meta Ads

### Google Play Store
- In Play Console → **Monetization → Ad network** — no special setup needed for Meta tracking
- Make sure your `google-services.json` is up to date
- Meta uses the **Advertising ID (GAID)** automatically — the `AD_ID` permission is already in your `AndroidManifest.xml`

### Apple App Store (iOS 14+ — Important)
Meta requires **ATT (App Tracking Transparency)** permission on iOS 14+:

1. You **must** show the ATT prompt before tracking works on iOS
2. Add to `Info.plist`:
   ```xml
   <key>NSUserTrackingUsageDescription</key>
   <string>We use this to deliver personalized ads and measure ad performance.</string>
   ```
3. Show the prompt in your app (add to `main.dart` or an onboarding screen):
   ```dart
   // Add to pubspec.yaml: app_tracking_transparency: ^3.0.5
   import 'package:app_tracking_transparency/app_tracking_transparency.dart';
   
   final status = await AppTrackingTransparency.requestTrackingAuthorization();
   if (status == TrackingStatus.authorized) {
     await MetaAnalyticsService.instance.initialize();
   }
   ```
4. In App Store Connect → your app → **App Privacy** → declare that you collect **Advertising Data** and **Identifiers**

> Without ATT permission, Meta events will still fire on iOS but without the IDFA — attribution accuracy is reduced.

---

## Step 8 — SKAdNetwork (iOS — Required for Meta Ads)

Meta requires their SKAdNetwork ID in `Info.plist`. It is **already there** in your file:

```xml
<key>SKAdNetworkItems</key>
<array>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>cstr6suwn9.skadnetwork</string>
    </dict>
</array>
```

This `cstr6suwn9.skadnetwork` is the official Meta SKAdNetwork ID. No changes needed.

---

## Quick Checklist Before Going Live

- [ ] Replace `YOUR_FACEBOOK_APP_ID` in `strings.xml` and `Info.plist`
- [ ] Replace `YOUR_FACEBOOK_CLIENT_TOKEN` in `strings.xml` and `Info.plist`
- [ ] Replace `fbYOUR_FACEBOOK_APP_ID` URL scheme in `Info.plist` with `fb` + your actual App ID
- [ ] Add Android key hash in Meta Developer Console → Settings → Basic → Android platform
- [ ] Add iOS Bundle ID in Meta Developer Console → Settings → Basic → iPhone platform
- [ ] Add `NSUserTrackingUsageDescription` to `Info.plist` for iOS ATT prompt
- [ ] Test events in Events Manager → Test Events tab
- [ ] Verify `Purchase` and `Subscribe` events appear after testing on a real device
- [ ] Set up your Ad Campaign in Ads Manager targeting the `Purchase` / `Subscribe` events
