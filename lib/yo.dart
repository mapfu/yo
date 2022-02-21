library yo;

import 'dart:collection';

class Yo {
  static final Yo _singleton = Yo._internal();

  factory Yo() => _singleton;

  Yo._internal();

  //------------------------------------------------------------

  final _mStorage = _DataStore();

  void send(dynamic key, var value) {
    _mStorage.setValue(key.toString(), value);
  }

  // Subscribes to the given stream [stream].
  // If stream already has data set, it will be delivered to the [callback] function.
  void receive(dynamic key, void Function(Object) callback) {
    _mStorage.setCallback(key.toString(), callback);
  }

  // Returns the current value of a given data [stream].
  Object getValue(String key) {
    return _mStorage.getValue(key);
  }

  void clear() {
    _mStorage.clear();
  }
}

class _DataStore {
  // Map instance to store data values with data stream.
  HashMap<String, _DataItem> _mDataItemsMap = HashMap();

  void clear() {
    _mDataItemsMap.clear();
  }

  // Sets/Adds the new value to the given key.
  void setValue(String key, var value) {
    // Retrieve existing data item from map.
    _DataItem item = _mDataItemsMap[key] ?? _DataItem();

    // Set new value to new/existing item.
    item.value = value;

    // Reset item to the map.
    _mDataItemsMap[key] = item;

    // Dispatch new value to all callbacks.
    item.callbacks.forEach((callback) {
      callback(value);
    });
  }

  // Sets/Adds the new callback to the given data stream.
  void setCallback(String key, Function(Object) callback) {
    _DataItem item = _mDataItemsMap[key] ?? _DataItem();

    // Retrieve callback functions from data item.
    List<Function(Object)> callbacks = item.callbacks;

    // Set callback functions list to data item.
    //item.callbacks = callbacks;

    // Set the data item to the map.
    _mDataItemsMap[key] = item;

    // Add the given callback into List of callback functions.
    callbacks.add(callback);

    // Dispatch value to the callback function if value already exists.
    if (item.value != null) {
      callback(item.value);
    }
  }

  // Returns current value of the data stream.
  dynamic getValue(String key) {
    return _mDataItemsMap[key]!.value;
  }
}

// Data class to hold value and callback functions of a data stream.
class _DataItem {
  dynamic value;

  List<Function(Object)> callbacks = [];
}
