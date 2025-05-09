import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gpr_coffee_shop/constants/theme.dart';
import 'package:gpr_coffee_shop/utils/api_keys.dart';

// Conditionally import Google Maps package
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Widget that shows a map that's compatible with the current platform
class PlatformMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final bool isMapReady;

  const PlatformMapWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.isMapReady,
  }) : super(key: key);

  @override
  State<PlatformMapWidget> createState() => _PlatformMapWidgetState();
}

class _PlatformMapWidgetState extends State<PlatformMapWidget> {
  // Set of markers for the map
  final Set<Marker> _markers = {};

  // Check if the current platform supports Google Maps
  bool get _isMapSupported {
    if (kIsWeb) {
      // Google Maps is supported on web
      return true;
    }

    // Google Maps is supported on Android, iOS, but not on Windows, Linux, or macOS yet
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  void initState() {
    super.initState();

    if (_isMapSupported) {
      // Add marker for cafe location
      _markers.add(
        Marker(
          markerId: const MarkerId('cafeLocation'),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: const InfoWindow(
            title: 'مقهى JBR',
            snippet: 'الرفاع الشرقي، البحرين',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show appropriate map widget based on platform support
    if (_isMapSupported && ApiKeys.googleMapsApiKey.isNotEmpty) {
      return _buildGoogleMap();
    } else {
      return _buildFallbackMap();
    }
  }

  /// Builds Google Map when supported
  Widget _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 15,
      ),
      markers: _markers,
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        // Map is created
      },
    );
  }

  /// Builds a fallback UI when Google Maps is not supported
  Widget _buildFallbackMap() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7D6E83), // لون الغلاف العلوي
            Color(0xFFD0B8A8), // لون الوسط
            Color(0xFFF8EDE3), // لون الغلاف السفلي
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار المقهى
            Container(
              width: 90,
              height: 90,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            // معلومات الموقع
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on,
                      color: AppTheme.primaryColor, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'الرفاع الشرقي، البحرين',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // رسالة توضيحية
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'خرائط Google غير مدعومة على هذه المنصة.\nيمكنك استخدام زر "فتح في الخرائط" لعرض الموقع.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[100],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
