import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants/app_strings.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/location_service.dart';

class NearbyUsersScreen extends StatefulWidget {
  const NearbyUsersScreen({super.key});

  @override
  State<NearbyUsersScreen> createState() => _NearbyUsersScreenState();
}

class _NearbyUsersScreenState extends State<NearbyUsersScreen> {
  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();

  bool _isLoading = true;
  bool _permissionDenied = false;
  String? _errorMessage;
  List<_NearbyUser> _nearbyUsers = const [];

  @override
  void initState() {
    super.initState();
    _loadNearbyUsers();
  }

  Future<void> _loadNearbyUsers() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _permissionDenied = false;
      _errorMessage = null;
    });

    try {
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable them to find nearby users.';
          _isLoading = false;
        });
        return;
      }

      final permission = await _locationService.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _permissionDenied = true;
          _errorMessage = 'Location permission is required to display nearby users.';
          _isLoading = false;
        });
        return;
      }

      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Unable to determine your current location.';
          _isLoading = false;
        });
        return;
      }

      try {
        await _authService.updateCurrentUserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } catch (_) {
        // Reading existing user locations remains useful if this write fails.
      }

      final users = await _authService.getUsers();
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      final nearby = users
          .where((user) => user.uid != currentUserId)
          .map((user) {
            final rawLocation = user.lastKnownLocation;
            final latitude = _asDouble(rawLocation?['latitude']);
            final longitude = _asDouble(rawLocation?['longitude']);
            if (latitude == null || longitude == null) {
              return null;
            }

            final distanceInMeters = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              latitude,
              longitude,
            );

            if (distanceInMeters > 5000) {
              return null;
            }

            return _NearbyUser(
              user: user,
              distanceInMeters: distanceInMeters,
            );
          })
          .whereType<_NearbyUser>()
          .toList()
        ..sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));

      if (!mounted) return;
      setState(() {
        _nearbyUsers = nearby;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'We could not load nearby users right now.';
        _isLoading = false;
      });
    }
  }

  double? _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.nearbyUsersTitle),
        actions: [
          IconButton(
            onPressed: _loadNearbyUsers,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _permissionDenied || _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people_alt_rounded, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage ?? 'Unable to get nearby users.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _loadNearbyUsers,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _nearbyUsers.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No nearby TraceNet users were found within 5 km.'),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _nearbyUsers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final nearbyUser = _nearbyUsers[index];
                        final distanceInKm = nearbyUser.distanceInMeters / 1000;
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(nearbyUser.user.name ?? 'TraceNet user'),
                            subtitle: Text(
                              nearbyUser.user.phone ?? nearbyUser.user.email ?? 'No contact details available',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              '${distanceInKm.toStringAsFixed(1)} km',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

class _NearbyUser {
  const _NearbyUser({
    required this.user,
    required this.distanceInMeters,
  });

  final UserProfile user;
  final double distanceInMeters;
}
