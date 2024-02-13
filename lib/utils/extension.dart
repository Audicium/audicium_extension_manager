import 'package:flutter/foundation.dart';

extension ListUpdate<T extends Object> on ValueNotifier<List<T>> {
  void updateList(List<T> newList) {
    value = [...value, ...newList];
  }

  void updateElement(T element) {
    value = [...value, element];
  }
}
