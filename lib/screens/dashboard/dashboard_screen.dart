import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/message_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _logout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.logout();
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Unable to log out right now.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider?>();
    final dashboardProvider = context.watch<DashboardProvider>();
    final messageProvider = context.watch<MessageProvider>();
    final userName = authProvider?.currentUserDisplayName ?? 'TraceNet user';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboardTitle),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logout,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await dashboardProvider.initialize();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(context, userName),
                const SizedBox(height: AppSizes.paddingLarge),
                GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSizes.paddingMedium,
                  mainAxisSpacing: AppSizes.paddingMedium,
                  childAspectRatio: 1.4,
                  children: [
                    _InternetStatusCard(provider: dashboardProvider),
                    _BatteryStatusCard(provider: dashboardProvider),
                  ],
                ),
                const SizedBox(height: AppSizes.paddingLarge),
                const _SosCard(),
                const SizedBox(height: AppSizes.paddingLarge),
                _MessagesCard(unreadCount: messageProvider.unreadCount),
                const SizedBox(height: AppSizes.paddingLarge),
                const _CommunityMapCard(),
                const SizedBox(height: AppSizes.paddingLarge),
                const _NearbyUsersCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primaryDarkBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        Text(
          'Welcome, $userName',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _InternetStatusCard extends StatelessWidget {
  const _InternetStatusCard({required this.provider});

  final DashboardProvider provider;

  @override
  Widget build(BuildContext context) {
    final isConnected = provider.isInternetConnected;
    final label = isConnected ? 'Connected' : 'No Internet';
    final color = isConnected ? AppColors.statusSuccess : AppColors.statusError;

    return CustomCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 150;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.wifi, color: AppColors.primaryDarkBlue),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Internet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (provider.errorMessage != null) ...[
                const SizedBox(height: 4),
                Flexible(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      provider.errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
              if (provider.errorMessage == null && compact) ...[
                const SizedBox(height: 2),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _BatteryStatusCard extends StatelessWidget {
  const _BatteryStatusCard({required this.provider});

  final DashboardProvider provider;

  @override
  Widget build(BuildContext context) {
    final batteryText = provider.isBatteryLoading ? 'Loading...' : '${provider.batteryLevel}%';
    final statusText = provider.isBatteryLoading ? 'Checking...' : provider.batteryStatus;

    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 150;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.battery_full, color: AppColors.primaryDarkBlue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Battery',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  batteryText,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 18 : 20,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  statusText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: compact ? 11 : 13,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SosCard extends StatelessWidget {
  const _SosCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Emergency SOS'),
              content: const Text('This will trigger the emergency action flow. Continue?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.sosRed,
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );

          if (confirmed == true && context.mounted) {
            await Navigator.of(context).pushNamed(AppRoutes.sos);
          }
        },
        icon: const Icon(Icons.emergency, size: 28),
        label: const Text('SOS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sosRed,
          foregroundColor: AppColors.secondaryWhite,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingLarge),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
        ),
      ),
    );
  }
}

class _MessagesCard extends StatelessWidget {
  const _MessagesCard({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final unreadLabel = unreadCount == 1 ? '1 unread message' : '$unreadCount unread messages';

    return CustomCard(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.messages),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.primaryDarkBlueLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: const Icon(Icons.message_rounded, color: AppColors.primaryDarkBlue),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  unreadLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spacingSmall),
                Text(
                  unreadCount > 0 ? 'New message activity available' : 'No recent messages yet',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}

class _CommunityMapCard extends StatelessWidget {
  const _CommunityMapCard();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.communityMap),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.statusInfo.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: const Icon(Icons.map_rounded, color: AppColors.statusInfo),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Map',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spacingXSmall),
                Consumer<DashboardProvider>(
                  builder: (context, provider, _) {
                    final locationText = provider.locationMessage ?? 'Location unavailable';
                    return Text(
                      locationText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}

class _NearbyUsersCard extends StatelessWidget {
  const _NearbyUsersCard();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.nearbyUsers),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.statusWarning.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: const Icon(Icons.people_alt_rounded, color: AppColors.statusWarning),
          ),
          const SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nearby Users',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  'No nearby users available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}

