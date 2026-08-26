import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../constants/app_strings.dart';
import '../../services/auth_service.dart';
import '../../services/location_service.dart';

class CommunityMapScreen extends StatefulWidget {
  const CommunityMapScreen({super.key});

  @override
  State<CommunityMapScreen> createState() => _CommunityMapScreenState();
}

class _CommunityMapScreenState extends State<CommunityMapScreen> {
  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final MapController _mapController = MapController();

  List<Marker> _markers = [];

  bool _isLoading = true;
  String? _errorMessage;

  // Chennai is used only as a fallback location.
  LatLng _mapCenter = const LatLng(13.0827, 80.2707);

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Position? position;

    // ---------------------------------------------------------
    // STEP 1: Try to get the user's location.
    // If it fails, DON'T stop the map from loading.
    // ---------------------------------------------------------
    try {
      final serviceEnabled =
          await _locationService.isLocationServiceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          position = await _locationService.getCurrentPosition();
        }
      }
    } catch (_) {
      // Location is optional for displaying the map.
      position = null;
    }

    // ---------------------------------------------------------
    // STEP 2: If location is available, use it.
    // Otherwise keep Chennai as fallback.
    // ---------------------------------------------------------
    if (position != null) {
      _mapCenter = LatLng(
        position.latitude,
        position.longitude,
      );

      // Update user's location in Firebase.
      try {
        await _authService.updateCurrentUserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } catch (_) {
        // Don't stop the map if Firebase location update fails.
      }
    }

    // ---------------------------------------------------------
    // STEP 3: Load other TraceNet users.
    // ---------------------------------------------------------
    try {
      final userMarkers = await _buildUserMarkers();

      if (!mounted) return;

      setState(() {
        _markers = userMarkers;

        // Add current user's marker if location is available.
        if (position != null) {
          _markers.insert(
            0,
            Marker(
              point: LatLng(
                position.latitude,
                position.longitude,
              ),
              width: 50,
              height: 50,
              child: const Icon(
                Icons.location_pin,
                color: Colors.blue,
                size: 44,
              ),
            ),
          );
        }

        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load community users.';
      });
    }

    // ---------------------------------------------------------
    // STEP 4: Move map to current location/fallback.
    // ---------------------------------------------------------
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        _mapController.move(_mapCenter, 14);
      } catch (_) {
        // Map controller may not be ready yet.
      }
    });
  }

  Future<List<Marker>> _buildUserMarkers() async {
    final markers = <Marker>[];

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final snapshot = await _firestore.collection('Users').get();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final lastKnown = data['lastKnownLocation'];

      if (lastKnown is! Map) {
        continue;
      }

      final latitude = _asDouble(lastKnown['latitude']);
      final longitude = _asDouble(lastKnown['longitude']);

      if (latitude == null || longitude == null) {
        continue;
      }

      // Don't show the current user twice.
      if (doc.id == currentUserId) {
        continue;
      }

      final userName =
          data['name']?.toString() ?? 'TraceNet user';

      markers.add(
        Marker(
          point: LatLng(latitude, longitude),
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$userName - Community member',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Icon(
              Icons.location_pin,
              color: Colors.orange,
              size: 44,
            ),
          ),
        ),
      );
    }

    return markers;
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

  void _recenterMap() {
    try {
      _mapController.move(_mapCenter, 15);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.communityMapTitle,
        ),
        actions: [
          IconButton(
            onPressed: _loadMapData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _mapCenter,
                    initialZoom: 14,
                    minZoom: 3,
                    maxZoom: 19,
                    onMapReady: () {
                      try {
                        _mapController.move(
                          _mapCenter,
                          14,
                        );
                      } catch (_) {}
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.tracenet',
                      maxZoom: 19,
                    ),

                    MarkerLayer(
                      markers: _markers,
                    ),

                    RichAttributionWidget(
                      alignment:
                          AttributionAlignment.bottomRight,
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                        ),
                      ],
                    ),
                  ],
                ),

                // Recenter button
                Positioned(
                  right: 16,
                  bottom: 70,
                  child: FloatingActionButton(
                    heroTag: 'recenter-map',
                    onPressed: _recenterMap,
                    child: const Icon(
                      Icons.my_location,
                    ),
                  ),
                ),

                // Small location warning if location failed.
                if (_errorMessage != null)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}