enum ListenerTypes { on, once }

class Listener {
  Listener(this.type, this.caller);
  ListenerTypes type;
  void Function(dynamic argument) caller;
}
