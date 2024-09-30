import 'package:flutter_test/flutter_test.dart';
import 'package:gym_bro/utils/general_util.dart';

void main() {
  group('roundTo', () {
    test('Rounding to 0 decimal places', () {
      expect(roundTo(12.3456, 0), '12');
      expect(roundTo(12.9999, 0), '13');
      expect(roundTo(0.4999, 0), '0');
    });

    test('Rounding to 1 decimal place', () {
      expect(roundTo(12.3456, 1), '12.3');
      expect(roundTo(12.9999, 1), '13.0');
      expect(roundTo(0.4999, 1), '0.5');
    });

    test('Rounding to 2 decimal places', () {
      expect(roundTo(12.3456, 2), '12.35');
      expect(roundTo(12.9999, 2), '13.00');
      expect(roundTo(0.4999, 2), '0.50');
    });

    test('Rounding to 3 decimal places', () {
      expect(roundTo(12.34567, 3), '12.346');
      expect(roundTo(12.99991, 3), '13.000');
      expect(roundTo(0.49999, 3), '0.500');
    });

    test('Handling negative numbers', () {
      expect(roundTo(-12.3456, 2), '-12.35');
      expect(roundTo(-0.4999, 2), '-0.50');
    });

    test('Handling large numbers', () {
      expect(roundTo(123456789.987654321, 2), '123456789.99');
      expect(roundTo(987654321.123456789, 4), '987654321.1235');
    });

    test('Handling rounding edge cases', () {
      expect(roundTo(0.9999, 2), '1.00'); // Boundary rounding to 1
      expect(roundTo(1.005, 2), '1.00');  // Edge case rounding up
    });
  });
}
