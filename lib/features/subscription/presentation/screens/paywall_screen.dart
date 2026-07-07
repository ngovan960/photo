import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/features/subscription/presentation/providers/subscription_provider.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101415),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Upgrade to Pro',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE9C349).withOpacity(0.08),
              ),
              child: const SizedBox(),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFBEC6E0).withOpacity(0.08),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // Hero Section
                const SizedBox(height: 24),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE9C349).withOpacity(0.15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE9C349).withOpacity(0.2),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: const Color(0xFFE9C349).withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: Color(0xFFE9C349),
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Unlock Your Full Potential',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Join our exclusive community of high-performers and gain access to advanced professional instruments.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),

                // Bento Features Grid
                _buildBentoFeature(
                  icon: Icons.check_circle,
                  title: 'Advanced Analytics',
                  description: 'Deep dive into your performance metrics with AI-driven insights.',
                ),
                const SizedBox(height: 16),
                _buildBentoFeature(
                  icon: Icons.check_circle,
                  title: 'Cloud Sync',
                  description: 'Synchronize your workspace across all your professional devices instantly.',
                ),
                const SizedBox(height: 16),
                _buildBentoFeature(
                  icon: Icons.check_circle,
                  title: 'Priority Support',
                  description: '24/7 dedicated concierge service for all your technical inquiries.',
                ),
                const SizedBox(height: 16),
                _buildBentoFeature(
                  icon: Icons.check_circle,
                  title: 'Exclusive Themes',
                  description: 'Custom crafted nocturnal and light-refracting interface aesthetics.',
                ),
                const SizedBox(height: 48),

                // Pricing Cards
                _buildPricingCard(
                  context: context,
                  ref: ref,
                  planName: 'MONTHLY',
                  price: '\$9.99',
                  period: '/mo',
                  features: ['All core features', 'Standard support'],
                  tier: SubscriptionTier.proMonthly,
                  isPopular: false,
                ),
                const SizedBox(height: 24),
                _buildPricingCard(
                  context: context,
                  ref: ref,
                  planName: 'ANNUAL PLAN',
                  price: '\$59.99',
                  period: '/yr',
                  badge: 'BEST VALUE',
                  features: [
                    'Everything in Monthly',
                    '2 months free',
                    'VIP early access',
                  ],
                  tier: SubscriptionTier.proYearly,
                  isPopular: true,
                ),
                const SizedBox(height: 24),
                _buildPricingCard(
                  context: context,
                  ref: ref,
                  planName: 'LIFETIME',
                  price: '\$149.99',
                  period: '',
                  features: ['Permanent access', 'Future updates included'],
                  tier: SubscriptionTier.lifetime,
                  isPopular: false,
                ),
                const SizedBox(height: 48),

                // Footer Actions
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Restore Purchase',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: Color(0xFFE9C349),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(fontSize: 11, color: Colors.white38),
                      ),
                    ),
                    const Text('•', style: TextStyle(color: Colors.white24)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(fontSize: 11, color: Colors.white38),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recurring billing. Cancel anytime in your account settings. Subscriptions automatically renew unless disabled at least 24 hours before the end of the current period.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    color: Colors.white30,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFE9C349), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required BuildContext context,
    required WidgetRef ref,
    required String planName,
    required String price,
    required String period,
    String? badge,
    required List<String> features,
    required SubscriptionTier tier,
    required bool isPopular,
  }) {
    final borderColor = isPopular ? const Color(0xFFE9C349) : Colors.white.withOpacity(0.1);
    final cardBg = isPopular
        ? Colors.white.withOpacity(0.06)
        : Colors.white.withOpacity(0.03);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isPopular ? 1.5 : 1),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: const Color(0xFFE9C349).withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (badge != null)
            Positioned(
              top: -12,
              left: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9C349),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? const Color(0xFFE9C349) : Colors.white60,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: 'Bodoni Moda',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      period,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
                if (isPopular) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Save 50% yearly',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE9C349),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(color: Colors.white10),
                const SizedBox(height: 16),
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          isPopular ? Icons.star : Icons.done,
                          size: 14,
                          color: isPopular ? const Color(0xFFE9C349) : Colors.white60,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          feature,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _purchase(context, ref, tier),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular ? const Color(0xFFE9C349) : Colors.transparent,
                      foregroundColor: isPopular ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: isPopular ? BorderSide.none : BorderSide(color: Colors.white.withOpacity(0.2)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      isPopular ? 'Upgrade Now' : 'Select',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _purchase(BuildContext context, WidgetRef ref, SubscriptionTier tier) async {
    final success = await ref.read(subscriptionProvider.notifier).purchase(tier);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pro upgrades succeeded!')),
      );
      context.go('/home');
    }
  }
}
