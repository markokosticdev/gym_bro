import 'package:collection/collection.dart';

enum Exercise {
  BarbellRow,
  BenchPress,
  ShoulderPress,
  Deadlift,
  Squat,
}

extension AppEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension AppEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (Exercise):
      return Exercise.values.deserialize(value) as T?;
    default:
      return null;
  }
}
