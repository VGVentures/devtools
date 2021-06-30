import 'package:devtools_app/src/bloc/bloc/bloc_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlocListEvent', () {
    group('BlocSelected', () {
      test('throws AssertionError when selectedBlocId is null', () {
        expect(() => BlocSelected(null), throwsAssertionError);
      });
    });
  });
}
