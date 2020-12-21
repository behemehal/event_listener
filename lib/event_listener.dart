library event_listener;

import 'listener.dart';
import 'exceptions.dart';

class EventListener {
  final Map<String, List<Listener>> _events = {
    'newListener': [],
    'removeListener': []
  };
  int _maxListeners = 10;

  set maxListeners(int n) {
    if (n >= 0) {
      _maxListeners = n;
    } else {
      throw EventRangeError();
    }
  }

  int get maxListeners => _maxListeners;

  void on(String eventName, void Function(dynamic argument) listener) {
    if (_events[eventName] == null) _events[eventName] = [];
    if (_maxListeners == 0 || _events[eventName]!.length < _maxListeners) {
      _events[eventName]!.add(Listener(ListenerTypes.on, listener));
      try {
        emit('newListener', MapEntry(eventName, _events[eventName]));
      } catch (_) {}
    } else {
      throw MaximumListenerOverflow();
    }
  }

  void once(String eventName, void Function(dynamic argument) listener) {
    if (_events[eventName] == null) _events[eventName] = [];
    if (_maxListeners == 0 || _events[eventName]!.length < _maxListeners) {
      _events[eventName]!.add(Listener(ListenerTypes.once, listener));
      try {
        emit('newListener', MapEntry(eventName, _events[eventName]));
      } catch (_) {}
    } else {
      throw MaximumListenerOverflow();
    }
  }

  Map<String, List<Listener>> get events => _events;
  List<String> get eventNames => _events.keys as List<String>;

  List<void Function(dynamic argument)> listeners(String eventName) {
    if (_events[eventName] != null) {
      return _events[eventName]!.map((e) => e.caller)
          as List<void Function(dynamic)>;
    } else {
      throw EventNotFound();
    }
  }

  void removeAllListeners(String eventName) {
    _events.entries.forEach((element) {
      try {
        emit('removeListener', element);
      } catch (_) {}
    });
    _events[eventName] = [];
  }

  void removeEventListener(
      String eventName, void Function(dynamic argument) listener) {
    if (_events[eventName] != null) {
      if (_events[eventName]!.map((e) => e.caller).contains(listener)) {
        try {
          emit(
              'removeListener',
              _events[eventName]!
                  .where((element) => element.caller == listener));
          _events[eventName]!
              .removeWhere((element) => element.caller == listener);
        } catch (_) {}
      } else {
        throw ListenerNotFound();
      }
    } else {
      throw EventNotFound();
    }
  }

  void emit(String eventName, dynamic argument) {
    if (_events[eventName] != null) {
      if (_events[eventName]!.isNotEmpty) {
        _events[eventName]!.forEach((listener) {
          listener.caller(argument);
          if (listener.type == ListenerTypes.once) {
            removeEventListener(eventName, listener.caller);
            try {
              emit('removeListener', MapEntry(eventName, listener));
            } catch (_) {}
          }
        });
      } else {
        throw NoListener();
      }
    } else {
      throw EventNotFound();
    }
  }
}
