import 'package:equatable/equatable.dart';

import 'logger.dart';

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) predicate) {
    try {
      return firstWhere(
        predicate,
        orElse: () => throw Exception('Not Found'),
      );
    } catch (e) {
      return null;
    }
  }
}

extension CustomListExtension<E extends Equatable> on List<E> {
  int indexOfObject(E object) {
    for (int i = 0; i < length; i++) {
      logger.d(this[i]);
      if (this[i] == object) {
        return i;
      }
    }
    return 0; // Return -1 if no match is found
  }

  bool containsObject(E find) {
    if (isEmpty) return false;
    bool hasObj = false;
    for (var element in this) {
      hasObj = find == element;
      if (hasObj) return hasObj;
    }
    return hasObj;
  }
}

extension InheritedListExtension<E> on List<E> {
  List<T> convertTo<T extends E>(T Function(E) from) {
    return map(
      (E e) => from(e),
    ).toList();
  }
}
