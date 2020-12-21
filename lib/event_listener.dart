library event_listener;

import 'listener.dart';
import 'exceptions.dart';

/// EventListener class
class EventListener {
  final Map<String, List<Listener>> _events = {
    'newListener': [],
    'removeListener': []
  };
  int _maxListeners = 10;

  ///Set maximum listeners limit, set 0 for unlimited 
  set maxListeners(int n) {
    if (n >= 0) {
      _maxListeners = n;
    } else {
      throw EventRangeError();
    }
  }

  int get maxListeners => _maxListeners;

  //Calls function when event occurs
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

  //Calls function once when event occurs
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

  ///Get all existent events
  Map<String, List<Listener>> get events => _events;

  ///Get all existent event names
  List<String> get eventNames => _events.keys as List<String>;


  ///Get all existent listeners of event
  List<void Function(dynamic argument)> listeners(String eventName) {
    if (_events[eventName] != null) {
      return _events[eventName]!.map((e) => e.caller)
          as List<void Function(dynamic)>;
    } else {
      throw EventNotFound();
    }
  }

  ///Remove all existent listeners of event
  void removeAllListeners(String eventName) {
    _events.entries.forEach((element) {
      try {
        emit('removeListener', element);
      } catch (_) {}
    });
    _events[eventName] = [];
  }

  ///Removes a listener from event
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

  ///Emits to every listener of event
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
