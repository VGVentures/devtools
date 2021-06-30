import 'package:devtools_app/src/bloc/models/bloc_object.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlocObject', () {
    test('supports value comparison', () {
      expect(const BlocObject('1', 'Bloc'), const BlocObject('1', 'Bloc'));
      expect(const BlocObject('2', 'Mason'), const BlocObject('2', 'Mason'));
      expect(
          const BlocObject('1', 'Bloc'), isNot(const BlocObject('2', 'Mason')));
    });

    test('asserts not null', () {
      expect(() => BlocObject('1', null), throwsAssertionError);
      expect(() => BlocObject(null, 'Bloc'), throwsAssertionError);
      expect(() => BlocObject(null, null), throwsAssertionError);
    });
  });
}
