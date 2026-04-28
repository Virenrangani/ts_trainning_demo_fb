import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapController controller;

  MapCubit(this.controller) : super(MapInitial());

  List<GeoPoint> selectedPoints = [];
  List<GeoPoint> roadPoints = [];
  GeoPoint? movingMarker;
  Timer? trackingTimer;

  void addPoint(GeoPoint point) async {
    selectedPoints.add(point);

    await controller.addMarker(
      point,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_on, color: Colors.red, size: 40),
      ),
    );
  }

  Future<void> connectRoads() async {
    if (selectedPoints.length < 2) return;

    emit(MapLoading());

    await controller.clearAllRoads();

    for (int i = 0; i < selectedPoints.length - 1; i++) {
      await controller.drawRoad(
        selectedPoints[i],
        selectedPoints[i + 1],
      );
    }

    await controller.drawRoad(
      selectedPoints.last,
      selectedPoints.first,
    );

    emit(MapRoadConnected());
  }

  Future<void> startTracking() async {
    emit(MapLoading());

    final start = GeoPoint(latitude: 23.0225, longitude: 72.5714);
    final end = GeoPoint(latitude: 23.2156, longitude: 72.6369);

    final roadInfo = await controller.drawRoad(start, end);
    roadPoints = roadInfo.route;

    if (roadPoints.isEmpty) return;

    movingMarker = roadPoints.first;

    await controller.setMarkerOfStaticPoint(
      id: "moving_driver",
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.directions_car,
          color: Colors.blue,
          size: 40,
        ),

      ),
    );

    startMoving();

    emit(MapTrackingStarted());
  }

  void startMoving() {
    trackingTimer?.cancel();
    int index = 0;

    trackingTimer = Timer.periodic(
      const Duration(milliseconds: 6000),
      (timer) async {
        if (index >= roadPoints.length - 1) {
          timer.cancel();
          return;
        }

        await animateMarker(
          roadPoints[index],
          roadPoints[index + 1],
        );

        index++;
      },
    );
  }

  Future<void> animateMarker(
    GeoPoint start,
    GeoPoint end,
  ) async {
    const int steps = 120;
    const duration = Duration(milliseconds: 3000);

    final latStep = (end.latitude - start.latitude) / steps;
    final lngStep = (end.longitude - start.longitude) / steps;

    for (int i = 1; i <= steps; i++) {
      final newPosition = GeoPoint(
        latitude: start.latitude + (latStep * i),
        longitude: start.longitude + (lngStep * i),
      );

      final angle = calculateBearing(start, end);

      await controller.setStaticPosition(
        [
          GeoPointWithOrientation(
            latitude: newPosition.latitude,
            longitude: newPosition.longitude,
            angle: angle,
          )
        ],
        "moving_driver",
      );

      movingMarker = newPosition;

      await Future.delayed(duration ~/ steps);
    }
  }

  Future<void> zoomIn() async {
    double zoom = await controller.getZoom();
    await controller.setZoom(zoomLevel: zoom + 1);
  }

  Future<void> zoomOut() async {
    double zoom = await controller.getZoom();
    await controller.setZoom(zoomLevel: zoom - 1);
  }

  Future<void> clearAll() async {
    await controller.clearAllRoads();
    await controller.removeMarkers(selectedPoints);
    selectedPoints.clear();
  }

  @override
  Future<void> close() {
    trackingTimer?.cancel();
    controller.dispose();
    return super.close();
  }
}

double calculateBearing(GeoPoint start, GeoPoint end) {
  final startLat = start.latitude * math.pi / 180;
  final startLng = start.longitude * math.pi / 180;
  final endLat = end.latitude * math.pi / 180;
  final endLng = end.longitude * math.pi / 180;

  final dLng = endLng - startLng;

  final y = math.sin(dLng) * math.cos(endLat);
  final x = math.cos(startLat) * math.sin(endLat) -
      math.sin(startLat) * math.cos(endLat) * math.cos(dLng);

  final bearing = (math.atan2(y, x) * 180 / math.pi + 360) % 360;

  return bearing;
}
