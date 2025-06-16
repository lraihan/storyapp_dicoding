import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/models/location_coordinate.dart';
import '../../../../l10n/app_localizations.dart';

class FullScreenMapView extends StatefulWidget {
  final LocationCoordinate location;
  final String? title;
  final String? description;
  final String? address;

  const FullScreenMapView({
    super.key,
    required this.location,
    this.title,
    this.description,
    this.address,
  });

  @override
  State<FullScreenMapView> createState() => _FullScreenMapViewState();
}

class _FullScreenMapViewState extends State<FullScreenMapView> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
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
            snippet: widget.address ??
                'Lat: ${widget.location.latitude.toStringAsFixed(6)}, '
                    'Lng: ${widget.location.longitude.toStringAsFixed(6)}',
          ),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? AppLocalizations.of(context)!.storyLocation),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 15.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }
}
