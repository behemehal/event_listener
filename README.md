# EventListener
[![License](https://img.shields.io/badge/license-MIT-green.svg)](/LICENSE)
[![Pub](https://img.shields.io/pub/v/event_listener.svg)](https://pub.dartlang.org/packages/event_listener)

NodeJS like Event Listener library for dart! 

## Usage

### On event

```dart
import 'package:event_listener/event_listener.dart';

void main() {
  var eventListener = new EventListener();

  eventListener.on('log', (String message) {
    print("A log: " + message);
  });

  eventListener.emit('log', 'from me');
}
```

### Once event fires one time

```dart
import 'package:event_listener/event_listener.dart';

void main() {
  var eventListener = new EventListener();

  //This event created by package called every time when you assign new listener to event
  eventListener.on('newListener', (MapEntry<String, Event> deletedEvent) {
    print("New event name: " + deletedEvent.key);
    print("New event caller: " + deletedEvent.value.caller);
  });
  /*
    New event name: log
    new event caller: closure (String message) =>
  */

  eventListener.once('log', (String message) {
    print("A last log: " + message);
    //A last log: from me
  });
  eventListener.emit('log', 'from me');
}
```

### Remove listener

```dart
import 'package:event_listener/event_listener.dart';

void main() {
  var eventListener = new EventListener();

  //This event created by package called every time when you remove a listener from event
  eventListener.on('removeListener', (MapEntry<String, Event> deletedEvent) {
    print("Deleted event name: " + deletedEvent.key);
    print("Deleted event caller: " + deletedEvent.value.caller);
  });
  /*
    Deleted event name: log
    Deleted event caller: closure (String message) =>
  */

  var logMe = (message) {
    print("A last log: " + message);
  }
  //A last log: from me

  eventListener.once('log', logMe);
  eventListener.emit('log', 'from me');
  eventListener.removeEventListener('log', logMe);
}
```

### Remove all listeners

```dart
import 'package:event_listener/event_listener.dart';

void main() {
  var eventListener = new EventListener();

  var logMe = (String message) {
    print("A last log: " + message);
  }

  eventListener.once('log', logMe);
  eventListener.on('log', logMe);
  eventListener.emit('log', 'from me');
  eventListener.removeAllListeners('log');
}
```

## Contributing

This package made close as NodeJS's Event Listener module, feel free to modify package as long as it looks familiar to Node package
