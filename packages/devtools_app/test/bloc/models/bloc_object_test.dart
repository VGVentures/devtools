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

    test('handles null', () {
      expect(const BlocObject('1', null), const BlocObject('1', null));
      expect(const BlocObject(null, 'Bloc'), const BlocObject(null, 'Bloc'));
      expect(const BlocObject(null, null), const BlocObject(null, null));
    });
  });
}
