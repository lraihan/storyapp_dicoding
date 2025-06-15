import 'package:flutter/material.dart';
import 'google_maps_display.dart';
import '../data/models/location_coordinate.dart';
class StoryMapWidget extends StatefulWidget {
  final double lat;
  final double lng;
  final String? title;
  final double height;
  const StoryMapWidget({
    super.key,
    required this.lat,
    required this.lng,
    this.title,
    this.height = 200,
  });
  @override
  State<StoryMapWidget> createState() => _StoryMapWidgetState();
}
class _StoryMapWidgetState extends State<StoryMapWidget> {
  @override
  Widget build(BuildContext context) {
    return GoogleMapsDisplay(
      location: LocationCoordinate(widget.lat, widget.lng),
      title: widget.title,
      height: widget.height,
    );
  }
}
