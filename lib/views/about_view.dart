import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_info.dart';
import '../services/app_update_service.dart';
import '../services/split_engine.dart';
import '../services/user_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/splitpe_logo.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  final _settings = UserSettings.instance;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _settings.defaultPayerName);
    _settings.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle(
            'Settings & About',
            subtitle: 'Tranching preferences, how it works, and privacy policy.',
          ),
          const SizedBox(height: 20),

          // 1. App Profile Card
          LiquidGlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SplitPeeLogo(),
                const SizedBox(height: 18),
                const Text(
                  AppInfo.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Created by ${AppInfo.owner}\nVersion ${AppInfo.version} (Build 1) · Android 15 Ready',
                  style: const TextStyle(
                    color: AppColors.muted,
                    height: 1.6,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Text(
                    AppInfo.copyright,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SelectableText(
                  AppInfo.supportEmail,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LiquidSpringButton(
                        backgroundColor: AppColors.primarySoft,
                        foregroundColor: AppColors.primary,
                        elevation: 2,
                        borderRadius: 14,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        onPressed: () async {
                          try {
                            final opened = await launchUrl(
                              Uri(scheme: 'mailto', path: AppInfo.supportEmail),
                              mode: LaunchMode.externalApplication,
                            );
                            if (!opened && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email us at ${AppInfo.supportEmail}'),
                                ),
                              );
                            }
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email us at ${AppInfo.supportEmail}'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mail_outline_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Contact Support'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.ink,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          SharePlus.instance.share(
                            ShareParams(
                              text:
                                  'Try SplitPee - Smart UPI Split! A clean, modern light liquid-glass app for smart ₹1,999 bill tranching and group splits:\n${AppUpdateService.playStoreWebUrl}',
                              title: 'SplitPee - Smart UPI Split',
                            ),
                          );
                        },
                        icon: const Icon(Icons.share_rounded, size: 17),
                        label: const Text('Share App'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Play Store Review & Updates (Official In-App Review & Update)
          LiquidGlassCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(
                  'Google Play & Updates',
                  subtitle: 'Official In-App Review & Play Core Update checks.',
                ),
                const SizedBox(height: 18),
                _SettingsTile(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Rate on Google Play',
                  subtitle: 'Leave an official review to support SplitPee',
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                  onTap: () => AppUpdateService.requestOfficialInAppReview(context),
                ),
                const Divider(height: 24),
                _SettingsTile(
                  icon: Icons.system_update_rounded,
                  iconColor: AppColors.primary,
                  title: 'Check for Updates',
                  subtitle: 'Official Google Play Core In-App Update check',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Check',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  onTap: () => AppUpdateService.checkForUpdates(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. How It Works Guide
          LiquidGlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  'How SplitPee Works',
                  subtitle: 'The math and mechanics behind smart bill tranching.',
                ),
                const SizedBox(height: 18),
                _GuideStep(
                  step: '1',
                  title: 'Why Capped at ₹1,999?',
                  description:
                      'In Indian digital payments, single merchant transactions under ₹2,000 (strictly up to ₹1,999) enjoy zero interchange surcharge rules and distinct banking limits. SplitPee programmatically organizes high-value payments into compliant micro-splits so every part stays under ₹2,000.',
                ),
                _GuideStep(
                  step: '2',
                  title: 'Two Smart Tranching Modes',
                  description:
                      '• ₹1,999 Slices: Slices the bill into full ₹1,999 chunks with remainder in the last part (e.g. ₹5,000 → ₹1,999, ₹1,999, ₹1,002).\n• Equal Shares: Divides the bill into equal balanced parts, each guaranteed under ₹1,999 (e.g. ₹5,000 → 3 parts of ₹1,666.67).',
                ),
                _GuideStep(
                  step: '3',
                  title: 'Seamless UPI App Launch',
                  description:
                      'Tap "Pay with a UPI App" to trigger your chosen payment app (Google Pay, PhonePe, Paytm, BHIM, CRED, Navi) with pre-filled amount, recipient VPA, and reference note. You authenticate the transaction securely inside your UPI app.',
                ),
                _GuideStep(
                  step: '4',
                  title: 'Group Splitting with Friends',
                  description:
                      'Dining out with friends? Enter the bill and select the number of people. SplitPee generates individual payment links and QR codes you can share via WhatsApp with one tap so everyone pays their own share directly.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Split Configuration & Preferences
          LiquidGlassCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(
                  'Tranching Preferences',
                  subtitle: 'Configure default per-split caps and tranching behavior.',
                ),
                const SizedBox(height: 18),
                const Text(
                  'Default Tranche Cap',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Strictly capped at ₹1,999 to guarantee compliant micro-splits.',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [1999.0, 1499.0, 999.0, 499.0].map((cap) {
                    final isSelected = _settings.defaultCap == cap;
                    return GestureDetector(
                      onTap: () {
                        if (_settings.hapticsEnabled) HapticFeedback.selectionClick();
                        _settings.setDefaultCap(cap);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primarySoft : Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 1.4 : 1.0,
                          ),
                        ),
                        child: Text(
                          '₹${cap.toInt()}${cap == 1999.0 ? ' (Default)' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.muted,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Default Tranching Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F2F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_settings.hapticsEnabled) HapticFeedback.selectionClick();
                            _settings.setDefaultStrategy(TrancheStrategy.maxCap);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _settings.defaultStrategy == TrancheStrategy.maxCap
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(11),
                              boxShadow: _settings.defaultStrategy == TrancheStrategy.maxCap
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF0C2B38).withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '₹1,999 Slices',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _settings.defaultStrategy == TrancheStrategy.maxCap
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: _settings.defaultStrategy == TrancheStrategy.maxCap
                                      ? AppColors.primary
                                      : AppColors.muted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (_settings.hapticsEnabled) HapticFeedback.selectionClick();
                            _settings.setDefaultStrategy(TrancheStrategy.equal);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _settings.defaultStrategy == TrancheStrategy.equal
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(11),
                              boxShadow: _settings.defaultStrategy == TrancheStrategy.equal
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF0C2B38).withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Equal Shares',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _settings.defaultStrategy == TrancheStrategy.equal
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: _settings.defaultStrategy == TrancheStrategy.equal
                                      ? AppColors.primary
                                      : AppColors.muted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: AppColors.primary,
                  title: const Text(
                    'Haptic Feedback',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Subtle vibrations when tapping buttons and tabs',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  value: _settings.hapticsEnabled,
                  onChanged: (val) {
                    _settings.setHapticsEnabled(val);
                    if (val) HapticFeedback.lightImpact();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 5. Privacy Policy & Data Safety
          LiquidGlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  'Privacy & Security',
                  subtitle: '100% offline-first · Zero tracking or data collection',
                ),
                const SizedBox(height: 18),
                const _PrivacySection(
                  'Your information stays strictly in your session',
                  'SplitPee, operated by Anupam Pradhan, processes bill amounts, recipient names, UPI IDs and notes strictly on your device. There is no account, developer backend, tracking, advertising or analytics. Split details are kept in volatile memory and are cleared when the app closes or reloads.',
                ),
                const _PrivacySection(
                  'Camera access',
                  'Camera permission is requested only when you open the QR scanner. QR frames are processed locally on your device via Google ML Kit to read payment details. SplitPee does not record, store or upload camera images. You can enter a UPI ID manually without camera access.',
                ),
                const _PrivacySection(
                  'Payments, copying and sharing',
                  'When you choose to pay, the recipient UPI ID, name, amount and note are passed directly to the UPI app you select. When you share or copy a link, these details are included. Your selected payment, messaging or clipboard service handles that information under its own policies.',
                ),
                const _PrivacySection(
                  'Payment status disclaimer',
                  'SplitPee does not access your bank account, UPI PIN, contacts, SMS or payment history. It cannot verify a transaction. "Marked paid by you" is a personal checklist, not a bank receipt. Check your UPI app and confirm with the recipient.',
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await launchUrl(
                        Uri.parse(AppInfo.privacyPolicyUrl),
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (_) {}
                  },
                  icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                  label: const Text('Open Web Privacy Policy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 6. Legal & Disclaimer
          LiquidGlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Before You Pay'),
                const SizedBox(height: 12),
                const Text(
                  'Review the recipient in your UPI app. SplitPee is an independent bill organisation tool and is not affiliated with NPCI, a bank or a UPI provider. It does not hold or transfer money. Provider fees and transaction limits still apply.',
                  style: TextStyle(color: AppColors.muted, height: 1.6, fontSize: 13),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => showLicensePage(
                    context: context,
                    applicationName: AppInfo.name,
                    applicationVersion: AppInfo.version,
                    applicationLegalese: AppInfo.copyright,
                  ),
                  icon: const Icon(Icons.policy_outlined, size: 18),
                  label: const Text('Open-source Licences'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 7. Footer - Made with ❤️ in India & Copyright
          Center(
            child: Column(
              children: [
                const Text(
                  AppInfo.madeInIndia,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppInfo.copyright,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.muted.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({
    required this.step,
    required this.title,
    required this.description,
  });

  final String step;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection(this.title, this.body);
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: const TextStyle(color: AppColors.muted, height: 1.6, fontSize: 12.5),
        ),
      ],
    ),
  );
}
