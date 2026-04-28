abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapRoadConnected extends MapState {}

class MapTrackingStarted extends MapState {}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}