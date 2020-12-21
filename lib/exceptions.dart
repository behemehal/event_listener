///This exception occurs when you try to remove a non existent listener
class ListenerNotFound implements Exception {
  String mesage() =>
      'Failed to remove event listener, targeted listener does not exist';
}

///This exception occurs when you try to emit or remove a event does not exist
class EventNotFound implements Exception {
  String mesage() =>
      'Failed to get event listener, targeted event does not exist';
}

///This exception occurs when you emit a event that does not have any listeners
class NoListener implements Exception {
  String mesage() => 'Failed to emit event listener, no listener on event';
}

///This exception occurs when you exceeded listener amount of event
class MaximumListenerOverflow implements Exception {
  String message() =>
      'Failed to add listener, \'maxListeners\' exceeded, change maxListeners to 0 for infinite listeners';
}

///This exception occurs when you try to set 'maxListeners' to negative value
class EventRangeError implements Exception {
  String message() =>
      'Failed to change \'maxListeners\', given number is not in range';
}
