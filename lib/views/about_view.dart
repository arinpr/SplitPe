import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_info.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/splitpe_logo.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(
          'Simple by design.',
          subtitle: 'A little clarity for the bills you share.',
        ),
        const SizedBox(height: 20),
        LiquidGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SplitPeeLogo(),
              const SizedBox(height: 20),
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
              const Text(
                'Created by ${AppInfo.owner}\nVersion ${AppInfo.version}',
                style: TextStyle(
                  color: AppColors.muted,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 18),
              const SelectableText(
                AppInfo.supportEmail,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              LiquidSpringButton(
                backgroundColor: AppColors.primarySoft,
                foregroundColor: AppColors.primary,
                elevation: 2,
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Contact Support'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const LiquidGlassCard(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle('Privacy Policy', subtitle: 'Last updated: 18 September 2026'),
              SizedBox(height: 18),
              _PrivacySection(
                'Your information stays in your session',
                'SplitPee, operated by Anupam Pradhan, processes bill amounts, recipient names, UPI IDs and notes strictly on your device. There is no account, developer backend, tracking, advertising or analytics. Split details are kept in memory and are cleared when the app closes or reloads.',
              ),
              _PrivacySection(
                'Camera access',
                'Camera permission is requested only when you open the QR scanner. QR frames are processed on your device to read payment details. SplitPee does not record, store or upload camera images. You can enter a UPI ID manually without camera access.',
              ),
              _PrivacySection(
                'Payments, copying and sharing',
                'When you choose to pay, the recipient UPI ID, name, amount and note are passed directly to the UPI app you select. When you share or copy a link, these details are included. Your selected payment, messaging or clipboard service handles that information under its own policies. Only share with people you intend to receive it.',
              ),
              _PrivacySection(
                'Payment status',
                'SplitPee does not access your bank account, UPI PIN, contacts, SMS or payment history. It cannot verify a transaction. "Marked paid by you" is a personal checklist, not a bank receipt. Check your UPI app and confirm with the recipient.',
              ),
              _PrivacySection(
                'Retention and your choices',
                'There is no saved account or server record to delete. Closing the app clears the session. Copies or messages you choose to send remain with their recipients or services. Revoke camera permission in device settings at any time.',
              ),
              _PrivacySection(
                'Support and policy changes',
                'If you email support, Anupam Pradhan receives your email address and the information you provide to respond to your request. Avoid sending PINs, bank credentials or unnecessary payment details. Contact anupampradhan161@gmail.com for privacy requests. Any changes to this policy will be reflected in the date above.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        LiquidGlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle('Before You Pay'),
              const SizedBox(height: 12),
              const Text(
                'Review the recipient in your UPI app. SplitPee is an independent bill organisation tool and is not affiliated with NPCI, a bank or a UPI provider. It does not hold or transfer money. Provider fees and transaction limits still apply.',
                style: TextStyle(color: AppColors.muted, height: 1.6),
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
      ],
    ),
  );
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection(this.title, this.body);
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 7),
      Text(body, style: const TextStyle(color: AppColors.muted, height: 1.6, fontSize: 13)),
    ]),
  );
}
