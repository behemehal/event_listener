import 'package:event_listener/event_listener.dart';
import 'package:event_listener/exceptions.dart';

import 'package:test/test.dart';

void main() {
  EventListener eventListener;
  var deleteableEvent = (e) {};

  setUp(() {
    eventListener = EventListener();
    eventListener.on('anEvent', deleteableEvent);
  });

  group('Exception tests', () {
    test('Removing non existent listener will throw ListenerNotFound', () {
      expect(() => eventListener.removeEventListener('anEvent', (argument) {}),
          throwsA(isA<ListenerNotFound>()));
    });

    test(
        'Removing listener from a event that not exist will throw EventNotFound',
        () {
      expect(
          () => eventListener.removeEventListener(
              'nonExistEventName', (argument) {}),
          throwsA(isA<EventNotFound>()));
    });

    test('Setting \'maxListeners\' to negative gives EventRangeError', () {
      expect(() {
        eventListener.maxListeners = -1;
      }, throwsA(isA<EventRangeError>()));
    });

    test(
        'Listening more than 3 events which we set with \'maxListeners\' settter, will give MaximumListenerOverflow',
        () {
      expect(() {
        var secondEventListener = EventListener();
        secondEventListener.maxListeners = 2;
        secondEventListener.on('anEvent', (e) {});
        secondEventListener.on('anEvent', (e) {});
        secondEventListener.on('anEvent', (e) {});
      }, throwsA(isA<MaximumListenerOverflow>()));
    });

    test('Setting \'maxListeners\' to 0 prevents MaximumListenerOverflow', () {
      expect(() {
        eventListener.maxListeners = 0;
        eventListener.on('anEvent', (e) {});
        eventListener.on('anEvent', (e) {});
        eventListener.on('anEvent', (e) {});
      }, returnsNormally);
    });

    test(
        'Removing event listener and trying to call again will throw NoListener',
        () {
      var willBeDeleted = (e) {};
      eventListener.on('deleteCheck', willBeDeleted);
      expect(() {
        eventListener.removeEventListener('deleteCheck', willBeDeleted);
        eventListener.emit('deleteCheck', test);
      }, throwsA(isA<NoListener>()));
    });
  });
}
