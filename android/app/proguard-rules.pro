# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Mobile Scanner
-keep class dev.steenbakker.mobile_scanner.** { *; }
-keep class com.google.mlkit.vision.barcode.** { *; }

# Google Play Core In-App Update
-keep class com.google.android.play.core.** { *; }
-keep class de.ffuf.in_app_update.** { *; }

# In-App Review
-keep class dev.vinicios.in_app_review.** { *; }
-keep class io.flutter.plugins.inappreview.** { *; }

# Share Plus
-keep class dev.fluttercommunity.plus.share.** { *; }

# URL Launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Prevent obfuscation of Application and Activity classes
-keep public class com.anupampradhan.splitpee.MainActivity
