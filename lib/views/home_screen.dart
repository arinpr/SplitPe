import 'package:flutter/material.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/splitpe_logo.dart';
import 'pos_checkout_view.dart';
import 'about_view.dart';
import 'savings_calculator_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _splitKey = GlobalKey<PosCheckoutViewState>();

  late final _pages = <Widget>[
    PosCheckoutView(
      key: _splitKey,
      onGroupTap: () => setState(() => _index = 1),
    ),
    const PosCheckoutView(groupMode: true),
    const SavingsCalculatorView(),
    const AboutView(),
  ];

  static const _tabItems = [
    LiquidTabItem(
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
      label: 'Split',
    ),
    LiquidTabItem(
      icon: Icons.people_outline_rounded,
      selectedIcon: Icons.people_rounded,
      label: 'Friends',
    ),
    LiquidTabItem(
      icon: Icons.calculate_outlined,
      selectedIcon: Icons.calculate_rounded,
      label: 'Estimate',
    ),
    LiquidTabItem(
      icon: Icons.info_outline_rounded,
      selectedIcon: Icons.info_rounded,
      label: 'About',
    ),
  ];

  @override
  Widget build(BuildContext context) => LiquidMeshBackground(
    child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 82,
        titleSpacing: 22,
        title: const SplitPeeLogo(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0C2B38).withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton.filledTonal(
                tooltip: 'Scan a UPI QR code',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.88),
                  foregroundColor: const Color(0xFF087F75),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.95),
                      width: 1.2,
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() => _index = 0);
                  _splitKey.currentState?.scanMerchantQr();
                },
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 22),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: IndexedStack(index: _index, children: _pages),
          ),
        ),
      ),
      bottomNavigationBar: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: LiquidBottomTabs(
          currentIndex: _index,
          onTap: (val) => setState(() => _index = val),
          items: _tabItems,
        ),
      ),
    ),
  );
}
