import 'package:devtools_app/src/bloc/models/bloc_object.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlocObject', () {
    test('throws AssertionError when blocId or blocType is null', () {
      expect(() => BlocObject('1', null), throwsAssertionError);
      expect(() => BlocObject(null, 'Bloc'), throwsAssertionError);
      expect(() => BlocObject(null, null), throwsAssertionError);
    });
  });
}
