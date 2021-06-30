import 'package:devtools_app/src/bloc/bloc/bloc_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlocListState', () {
    group('BlocListLoadSuccess', () {
      test('throws AssertionError when blocObject list is null', () {
        expect(() => BlocListLoadSuccess(null), throwsAssertionError);
        expect(() => BlocListLoadSuccess(null, 'Bloc'), throwsAssertionError);
      });
    });
  });
}
