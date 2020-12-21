class ListenerNotFound implements Exception {
  String mesage() =>
      'Failed to remove event listener, targeted listener does not exist';
}

class EventNotFound implements Exception {
  String mesage() =>
      'Failed to remove event listener, targeted event does not exist';
}

class NoListener implements Exception {
  String mesage() => 'Failed to emit event listener, no listener on event';
}

class MaximumListenerOverflow implements Exception {
  String message() =>
      'Failed to add listener, \'maxListeners\' exceeded, change maxListeners to 0 for infinite listeners';
}

class EventRangeError implements Exception {
  String message() =>
      'Failed to change \'maxListeners\', given number is not in range';
}
