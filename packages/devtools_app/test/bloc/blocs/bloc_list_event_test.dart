import 'package:devtools_app/src/bloc/bloc/bloc_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlocListEvent', () {
    group('BlocListRequested', () {
      test('supports value comparison', () {
        expect(const BlocListRequested(), const BlocListRequested());
      });
    });
    group('BlocSelected', () {
      test('supports value comparison', () {
        expect(const BlocSelected('Bloc'), const BlocSelected('Bloc'));
        expect(const BlocSelected('Bloc'), isNot(const BlocSelected('Mason')));
      });
      test('handles null', () {
        expect(() => BlocSelected(null), throwsAssertionError);
      });
    });
  });
}
