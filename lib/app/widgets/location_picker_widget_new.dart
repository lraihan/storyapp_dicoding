import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../data/service/location_service.dart';
import '../data/models/location_coordinate.dart';
class LocationPickerWidget extends StatefulWidget {
  final Function(LocationCoordinate) onLocationSelected;
  final LocationCoordinate? initialLocation;
  const LocationPickerWidget({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
  });
  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}
class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  final LocationService _locationService = Get.find<LocationService>();
  LocationCoordinate? _selectedLocation;
  String? _selectedAddress;
  bool _isLoadingAddress = false;
  bool _isLoadingLocation = false;
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (_selectedLocation != null) {
      _latController.text = _selectedLocation!.latitude.toString();
      _lngController.text = _selectedLocation!.longitude.toString();
      _loadAddress(_selectedLocation!);
    }
  }
  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
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
      if (mounted) {
        setState(() {
          _selectedAddress = address ?? 'unknownLocation'.tr;
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedAddress = 'unknownLocation'.tr;
          _isLoadingAddress = false;
        });
      }
    }
  }
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('gettingCurrentLocation'.tr),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    final position = await _locationService.getCurrentLocation();
    setState(() {
      _isLoadingLocation = false;
    });
    if (position != null && mounted) {
      final location = LocationCoordinate(position.latitude, position.longitude);
      _selectedLocation = location;
      _latController.text = location.latitude.toString();
      _lngController.text = location.longitude.toString();
      _loadAddress(location);
      widget.onLocationSelected(location);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('locationObtained'.tr),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  void _onCoordinatesChanged() {
    final latText = _latController.text.trim();
    final lngText = _lngController.text.trim();
    if (latText.isNotEmpty && lngText.isNotEmpty) {
      final lat = double.tryParse(latText);
      final lng = double.tryParse(lngText);
      if (lat != null && lng != null && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
        final location = LocationCoordinate(lat, lng);
        _selectedLocation = location;
        _loadAddress(location);
        widget.onLocationSelected(location);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('selectLocation'.tr),
        actions: [
          if (!_isLoadingLocation)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _getCurrentLocation,
              tooltip: 'gettingCurrentLocation'.tr,
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.gps_fixed, color: Colors.blue),
                title: Text('useCurrentLocation'.tr),
                subtitle: Text('getCurrentLocationDesc'.tr),
                trailing: _isLoadingLocation
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward_ios),
                onTap: _isLoadingLocation ? null : _getCurrentLocation,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'manualCoordinates'.tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latController,
                    decoration: InputDecoration(
                      labelText: 'latitude'.tr,
                      hintText: '-6.200000',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    onChanged: (_) => _onCoordinatesChanged(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    decoration: InputDecoration(
                      labelText: 'longitude'.tr,
                      hintText: '106.816666',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    onChanged: (_) => _onCoordinatesChanged(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_selectedLocation != null) ...[
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'selectedLocation'.tr,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isLoadingAddress)
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 8),
                            Text('loadingAddress'.tr),
                          ],
                        )
                      else if (_selectedAddress != null)
                        Text(
                          _selectedAddress!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}\nLng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700], size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'locationHelp'.tr,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'locationHelpDesc'.tr,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedLocation != null
          ? FloatingActionButton.extended(
              onPressed: () => context.pop(_selectedLocation),
              icon: const Icon(Icons.check),
              label: Text('confirmLocation'.tr),
            )
          : null,
    );
  }
}
