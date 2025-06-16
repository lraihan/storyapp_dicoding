import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../data/service/location_service.dart';
import '../data/models/location_coordinate.dart';
import '../../../../l10n/app_localizations.dart';

class GoogleMapsDisplay extends StatefulWidget {
  final LocationCoordinate location;
  final String? title;
  final String? description;
  final double height;
  final bool showFullScreen;

  const GoogleMapsDisplay({
    super.key,
    required this.location,
    this.title,
    this.description,
    this.height = 200,
    this.showFullScreen = true,
  });

  @override
  State<GoogleMapsDisplay> createState() => _GoogleMapsDisplayState();
}

class _GoogleMapsDisplayState extends State<GoogleMapsDisplay> {
  final LocationService _locationService = Get.find<LocationService>();
  String? _address;
  bool _isLoadingAddress = false;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadAddress();
    _createMarker();
  }

  void _createMarker() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('story_location'),
          position: LatLng(widget.location.latitude, widget.location.longitude),
          infoWindow: InfoWindow(
            title: widget.title ?? AppLocalizations.of(context)!.storyLocation,
            snippet: widget.description ??
                'Lat: ${widget.location.latitude.toStringAsFixed(6)}, '
                    'Lng: ${widget.location.longitude.toStringAsFixed(6)}',
          ),
          onTap: () {
            _showAddressBottomSheet();
          },
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                // Map controller setup if needed
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.location.latitude, widget.location.longitude),
                zoom: 15.0,
              ),
              markers: _markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: widget.showFullScreen,
              zoomGesturesEnabled: widget.showFullScreen,
              rotateGesturesEnabled: widget.showFullScreen,
              tiltGesturesEnabled: widget.showFullScreen,
            ),

            if (widget.showFullScreen)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen, size: 20),
                    onPressed: () {
                      _showFullScreenMap();
                    },
                  ),
                ),
              ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.title != null)
                      Text(
                        widget.title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    if (_isLoadingAddress)
                      const Row(
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Loading address...',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      )
                    else if (_address != null)
                      Text(
                        _address!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadAddress() async {
    setState(() {
      _isLoadingAddress = true;
    });

    try {
      final address = await _locationService.getAddressFromCoordinates(
        widget.location.latitude,
        widget.location.longitude,
      );
      setState(() {
        _address = address ?? AppLocalizations.of(context)!.addressNotFound;
      });
    } catch (e) {
      setState(() {
        _address = AppLocalizations.of(context)!.addressNotFound;
      });
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
  }

  void _showFullScreenMap() {
    final lat = widget.location.latitude;
    final lng = widget.location.longitude;
    final params = <String, String>{
      'lat': lat.toString(),
      'lng': lng.toString(),
    };
    if (widget.title != null) params['title'] = widget.title!;
    if (widget.description != null) params['description'] = widget.description!;
    if (_address != null) params['address'] = _address!;

    context.push(Uri(path: '/map-fullscreen', queryParameters: params).toString());
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? AppLocalizations.of(context)!.storyLocation,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Latitude: ${widget.location.latitude.toStringAsFixed(6)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Longitude: ${widget.location.longitude.toStringAsFixed(6)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (_address != null) ...[
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.address,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                _address!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (widget.description != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: Text(AppLocalizations.of(context)!.close),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showFullScreenMap,
                    child: Text(AppLocalizations.of(context)!.viewFullScreen),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
