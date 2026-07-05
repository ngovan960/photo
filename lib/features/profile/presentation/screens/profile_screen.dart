import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            _buildProfileHeader(profileState),
            const SizedBox(height: AppSpacing.xl),

            // Stats
            _buildStats(profileState),
            const SizedBox(height: AppSpacing.xl),

            // Quick actions
            _buildQuickActions(),
            const SizedBox(height: AppSpacing.xl),

            // Subscription info
            _buildSubscriptionInfo(profileState),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileState state) {
    return Center(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySurface,
              border: Border.all(
                color: state.isPro ? AppColors.primary : AppColors.gray200,
                width: state.isPro ? 3 : 1,
              ),
            ),
            child: Center(
              child: Text(
                state.displayName.isNotEmpty
                    ? state.displayName[0].toUpperCase()
                    : 'U',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          // Name
          Text(
            state.displayName,
            style: AppTypography.h2,
          ),
          const SizedBox(height: AppSpacing.xs),
          // Email
          if (state.email.isNotEmpty)
            Text(
              state.email,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray500,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          // Subscription badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: state.isPro ? AppColors.primary : AppColors.gray100,
              borderRadius: BorderRadius.circular(AppBorderRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  state.isPro ? Icons.star : Icons.star_border,
                  size: 16,
                  color: state.isPro ? AppColors.white : AppColors.gray600,
                ),
                const SizedBox(width: 4),
                Text(
                  state.isPro ? 'Pro' : 'Free',
                  style: AppTypography.labelMedium.copyWith(
                    color: state.isPro ? AppColors.white : AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ProfileState state) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.photo_library_outlined,
            label: 'Tổng ảnh',
            value: state.totalPhotos.toString(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.public,
            label: 'Quốc gia',
            value: state.totalCountries.toString(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.star_outline,
            label: 'Gói',
            value: state.subscriptionTier,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thao tác nhanh', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.camera_alt,
                label: 'Chụp ảnh',
                onTap: () => context.push('/countries'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionButton(
                icon: Icons.photo_library,
                label: 'Thư viện',
                onTap: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionButton(
                icon: Icons.history,
                label: 'Lịch sử',
                onTap: () => context.push('/history'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionInfo(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subscription', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: Column(
            children: [
              _InfoRow(
                label: 'Gói hiện tại',
                value: state.subscriptionTier,
                valueColor: state.isPro ? AppColors.primary : AppColors.gray600,
              ),
              const Divider(),
              _InfoRow(
                label: 'Ảnh đã tạo',
                value: '${state.totalPhotos}',
              ),
              _InfoRow(
                label: 'Quốc gia đã dùng',
                value: '${state.totalCountries}',
              ),
              if (!state.isPro) ...[
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/paywall'),
                    child: const Text('Nâng cấp Pro'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTypography.h2),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: valueColor ?? AppColors.gray700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
