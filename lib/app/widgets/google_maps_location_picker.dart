import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../data/service/location_service.dart';
import '../data/models/location_coordinate.dart';
import '../../../../l10n/app_localizations.dart';

class GoogleMapsLocationPicker extends StatefulWidget {
  final Function(LocationCoordinate) onLocationSelected;
  final LocationCoordinate? initialLocation;
  const GoogleMapsLocationPicker({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
  });
  @override
  State<GoogleMapsLocationPicker> createState() => _GoogleMapsLocationPickerState();
}

class _GoogleMapsLocationPickerState extends State<GoogleMapsLocationPicker> {
  final LocationService _locationService = Get.find<LocationService>();
  GoogleMapController? _mapController;
  LocationCoordinate? _selectedLocation;
  String? _selectedAddress;
  bool _isLoadingAddress = false;
  bool _isLoadingLocation = false;
  Set<Marker> _markers = {};
  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (_selectedLocation != null) {
      _updateMarker(_selectedLocation!);
      _loadAddress(_selectedLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectLocation),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  widget.onLocationSelected(_selectedLocation!);
                }
              },
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _selectedLocation != null
                  ? LatLng(_selectedLocation!.latitude, _selectedLocation!.longitude)
                  : const LatLng(-6.2088, 106.8456),
              zoom: _selectedLocation != null ? 15.0 : 10.0,
            ),
            onTap: (LatLng position) {
              _onMapTapped(position);
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              heroTag: "currentLocation",
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.selectedLocation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
                      'Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    if (_isLoadingAddress)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Loading address...'),
                          ],
                        ),
                      )
                    else if (_selectedAddress != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _selectedAddress!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(l10n.cancel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onLocationSelected(_selectedLocation!);
                            },
                            child: Text(l10n.selectLocation),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    final location = LocationCoordinate(position.latitude, position.longitude);
    setState(() {
      _selectedLocation = location;
      _selectedAddress = null;
    });
    _updateMarker(location);
    _loadAddress(location);
  }

  void _updateMarker(LocationCoordinate location) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: AppLocalizations.of(context)!.selectedLocation,
            snippet: 'Lat: ${location.latitude.toStringAsFixed(6)}, '
                'Lng: ${location.longitude.toStringAsFixed(6)}',
          ),
        ),
      };
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        final location = LocationCoordinate(position.latitude, position.longitude);
        setState(() {
          _selectedLocation = location;
          _selectedAddress = null;
        });
        _updateMarker(location);
        _loadAddress(location);
        if (_mapController != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 15.0,
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Handle location permission or service errors silently
      // The UI will remain in the previous state if location cannot be retrieved
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _loadAddress(LocationCoordinate location) async {
    setState(() {
      _isLoadingAddress = true;
    });
    try {
      final address = await _locationService.getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );
      setState(() {
        _selectedAddress = address ?? AppLocalizations.of(context)!.addressNotFound;
      });
    } catch (e) {
      setState(() {
        _selectedAddress = AppLocalizations.of(context)!.addressNotFound;
      });
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
  }
}
