import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:vm_service/vm_service.dart';

import '../../eval_on_dart_library.dart';
import '../../globals.dart';
import '../models/bloc_object.dart';

part 'bloc_list_event.dart';
part 'bloc_list_state.dart';

class BlocListBloc extends Bloc<BlocListEvent, BlocListState> {
  BlocListBloc() : super(const BlocListInitial()) {
    _evalOnDartLibrary = EvalOnDartLibrary(
      ['package:bloc/src/bloc_observer.dart'],
      serviceManager.service,
    );
    _postEventSubscription =
        serviceManager.service.onExtensionEvent.where((event) {
      return event.extensionKind == 'bloc:bloc_map_changed';
    }).listen((_) => add(const BlocListRequested()));
  }

  final _isAlive = Disposable();
  EvalOnDartLibrary _evalOnDartLibrary;
  StreamSubscription<void> _postEventSubscription;

  @override
  Future<void> close() {
    _postEventSubscription.cancel();
    _isAlive.dispose();
    return super.close();
  }

  @override
  Stream<BlocListState> mapEventToState(
    BlocListEvent event,
  ) async* {
    if (event is BlocListRequested) {
      yield* _mapBlocListRequestedToState(event);
    } else if (event is BlocSelected) {
      yield* _mapBlocSelectedToState(event);
    }
  }

  Stream<BlocListState> _mapBlocListRequestedToState(
    BlocListRequested event,
  ) async* {
    yield const BlocListLoadInProgress();
    try {
      final blocList = await _getBlocList();
      yield BlocListLoadSuccess(blocList);
    } catch (_) {
      yield const BlocListLoadFailure();
    }
  }

  Stream<BlocListState> _mapBlocSelectedToState(BlocSelected event) async* {
    try {
      final blocList = await _getBlocList();
      yield BlocListLoadSuccess(blocList, event.selectedBlocId);
    } catch (_) {
      yield const BlocListLoadFailure();
    }
  }

  Future<List<BlocObject>> _getBlocList() async {
    final observerRef = await _evalOnDartLibrary.safeEval(
      'Bloc.observer.blocMap',
      isAlive: _isAlive,
    );
    final observers = await _evalOnDartLibrary.getInstance(
      observerRef,
      _isAlive,
    );
    return observers.associations
        .where((e) => e.key is! Sentinel && e.value is! Sentinel)
        .map((e) => BlocObject(e.key.valueAsString, e.value.classRef.name))
        .toList();
  }
}
