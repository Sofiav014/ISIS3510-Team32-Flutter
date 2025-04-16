abstract class ConnectivityEvent {}

class ConnectivityChangedEvent extends ConnectivityEvent {
  final bool online;
  ConnectivityChangedEvent(this.online);
}
