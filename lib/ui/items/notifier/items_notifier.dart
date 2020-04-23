import 'package:cardstacksample/models/app_item.dart';
import 'package:flutter/foundation.dart';
import 'item_notifier.dart';

class ItemsNotifier extends ChangeNotifier {
  List<ItemNotifier> _items;

  int _startItemIndex;
  int _currentItemIndex;
  int _lastItemIndex;

  bool isReady = false;
  bool _isCompleted = false;
  Function(Status status) swipeCallback;

  ItemsNotifier({List<AppItem> items, int position}) {
    _items = items.map((item) {
      return ItemNotifier(item: item);
    }).toList();
    isReady = true;
    _isCompleted = totalItems == 0;
    _currentItemIndex = 0;
    if (position != null && position > 0) {
      _currentItemIndex = position;
    }
    _startItemIndex = position ?? 0;
  }

  void setSwipeListener(Function(Status status) callback) {
    this.swipeCallback = callback;
  }

  bool get isListCompleted => _isCompleted;

  int get currentPosition => _currentItemIndex % totalItems;

  int get nextPosition => (_currentItemIndex + 1) % totalItems;

  int get prevPosition {
    int temp = (_currentItemIndex - 1) % totalItems;
    if (temp < 0) {
      temp = temp + totalItems;
    }
    return temp;
  }

  int get totalItems => _items.length;

  void markDirty() {
    if (hasListeners) {
      notifyListeners();
    }
  }

  ItemNotifier get currentItem {
    if ((currentPosition) < _items.length) {
      return _items[currentPosition];
    } else {
      return null;
    }
  }

  ItemNotifier get prevItem {
    if (prevPosition < _items.length) {
      return _items[prevPosition];
    } else {
      return null;
    }
  }

  ItemNotifier get nextItem {
    if ((nextPosition) < _items.length) {
      return _items[nextPosition];
    } else {
      return null;
    }
  }

  List<int> undoPositions = [];

  void cycle() {
    {
      if (_startItemIndex == 0) {
        _isCompleted = (_currentItemIndex + 1 >= totalItems);
      } else {
        if (_lastItemIndex != null && nextPosition == _startItemIndex) {
          _isCompleted = true;
        }
      }
    }

    currentItem.updateStatus(Status.none);
    _lastItemIndex = _currentItemIndex;
    undoPositions.add(_currentItemIndex);
    _currentItemIndex = (_currentItemIndex + 1);
    markDirty();
  }

  void skip() {
    cycle();
  }

  bool undo() {
    if (undoPositions.isEmpty) {
      return false;
    }

    currentItem.updateStatus(Status.none);
    int undoPosition = undoPositions.removeLast();
    _currentItemIndex = undoPosition;
    markDirty();
    return true;
  }

  Future<bool> markUserItemAction(AppItem item, Status status) async {
    item.status = status;
    return true;
  }
}
