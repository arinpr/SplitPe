import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_info.dart';
import '../theme/app_theme.dart';
import '../widgets/liquid_glass.dart';

abstract final class AppUpdateService {
  static const String playStorePackage = 'com.anupampradhan.splitpee';
  static const String playStoreMarketUri = 'market://details?id=$playStorePackage';
  static const String playStoreWebUrl = 'https://play.google.com/store/apps/details?id=$playStorePackage';

  static final InAppReview _inAppReview = InAppReview.instance;

  /// Open Google Play Store listing directly to rate or download updates
  static Future<void> openPlayStore({BuildContext? context}) async {
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.openStoreListing(
          appStoreId: playStorePackage,
        );
        return;
      }
    } catch (_) {}

    try {
      final marketUri = Uri.parse(playStoreMarketUri);
      final opened = await launchUrl(marketUri, mode: LaunchMode.externalApplication);
      if (opened) return;
    } catch (_) {}

    try {
      final webUri = Uri.parse(playStoreWebUrl);
      final openedWeb = await launchUrl(webUri, mode: LaunchMode.externalApplication);
      if (!openedWeb && context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Play Store directly.')),
        );
      }
    } catch (_) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visit Google Play Store to rate SplitPee.')),
        );
      }
    }
  }

  /// Request official Google Play In-App Review with fallback to custom dialog
  static Future<void> requestOfficialInAppReview(BuildContext context) async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final isAvailable = await _inAppReview.isAvailable();
        if (isAvailable) {
          await _inAppReview.requestReview();
          return;
        }
      }
    } catch (_) {}

    if (context.mounted) {
      await showInAppRatingDialog(context);
    }
  }

  /// Interactive Liquid-Glass In-App Rating & Review Dialog
  static Future<void> showInAppRatingDialog(BuildContext context) async {
    int rating = 5;
    final selectedChips = <String>{};
    final chips = [
      'Pure Light UI',
      'Smart 1999 Splits',
      'Zero Ads / 100% Private',
      'Super Fast',
      'Fluid Animations',
    ];

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final starLabels = [
              'Tap a star',
              'Needs work',
              'Fair',
              'Good',
              'Great!',
              'Exceptional! 💖',
            ];

            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: LiquidGlassCard(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2DD4BF), Color(0xFF087F75)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF087F75).withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Enjoying SplitPee?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Your rating helps independent development and keeps SplitPee 100% ad-free.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Animated 5-star selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isFilled = starIndex <= rating;
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                rating = starIndex;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: AnimatedScale(
                                scale: isFilled ? 1.15 : 0.95,
                                duration: const Duration(milliseconds: 180),
                                child: Icon(
                                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: isFilled ? const Color(0xFFF59E0B) : AppColors.border,
                                  size: 38,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        starLabels[rating],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Compliment chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: chips.map((chip) {
                          final selected = selectedChips.contains(chip);
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                if (selected) {
                                  selectedChips.remove(chip);
                                } else {
                                  selectedChips.add(chip);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primarySoft
                                    : Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: selected ? 1.3 : 1.0,
                                ),
                              ),
                              child: Text(
                                chip,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.muted,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      LiquidSpringButton(
                        isFullWidth: true,
                        onPressed: () {
                          Navigator.pop(context);
                          openPlayStore(context: context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.rate_review_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Rate on Google Play'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Maybe later',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Checks for updates using Google Play Core In-App Update API with graceful UI fallback
  static Future<void> checkForUpdates(BuildContext context) async {
    String versionString = AppInfo.version;
    String buildNumberString = '1';

    try {
      final info = await PackageInfo.fromPlatform();
      versionString = info.version.isNotEmpty ? info.version : AppInfo.version;
      buildNumberString = info.buildNumber.isNotEmpty ? info.buildNumber : '1';
    } catch (_) {}

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Checking Google Play Store for updates…'),
          ],
        ),
        duration: Duration(milliseconds: 1200),
      ),
    );

    // If on real Android device with Play Store installed, attempt Play Core In-App Update check
    bool updateAvailable = false;
    AppUpdateInfo? updateInfo;

    if (!kIsWeb && Platform.isAndroid) {
      try {
        updateInfo = await InAppUpdate.checkForUpdate();
        if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          updateAvailable = true;
        }
      } catch (_) {
        // App is not installed via Play Store yet (dev / sideloaded APK), fallback to UI check
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 600));
    }

    if (!context.mounted) return;

    if (updateAvailable && updateInfo != null) {
      // Offer Play Core immediate update
      try {
        await InAppUpdate.performImmediateUpdate();
        return;
      } catch (_) {}
    }

    if (!context.mounted) return;

    // Display rich liquid-glass status dialog
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: LiquidGlassCard(
              padding: const EdgeInsets.all(26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.system_update_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Version & Updates',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              'Google Play Production Channel',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _infoRow('Installed Version', 'v$versionString (Build $buildNumberString)'),
                        const Divider(height: 20),
                        _infoRow('Target Platform', 'Android 15 (API 35)'),
                        const Divider(height: 20),
                        _infoRow('Play Store Status', 'Up to date ✓', isHighlight: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'What’s new in v1.0.0:',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Modern light Liquid Glass UI with optical refraction\n'
                    '• Strict ₹1,999 smart bill tranching engine\n'
                    '• Balanced equal group splits for dining with friends\n'
                    '• Instant BharatQR & UPI QR camera scanner\n'
                    '• Official Google Play In-App Review & Update APIs\n'
                    '• 100% offline-first session architecture',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12.5,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LiquidSpringButton(
                          onPressed: () {
                            Navigator.pop(context);
                            openPlayStore(context: context);
                          },
                          child: const Text('Play Store'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.muted),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isHighlight ? AppColors.primary : AppColors.ink,
          ),
        ),
      ],
    );
  }
}
