import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../eval_on_dart_library.dart';
import '../../globals.dart';
import '../../screen.dart';
import '../bloc/bloc_list_bloc.dart';
import '../bloc/bloc_list_event.dart';
import '../bloc/bloc_list_state.dart';
import '../bloc/bloc_node_bloc.dart';
import '../widgets/bloc_error_view.dart';
import '../widgets/bloc_initial_view.dart';
import '../widgets/bloc_list_view.dart';
import '../widgets/bloc_loading_view.dart';

// Entrypoint for the Bloc Screen in the DevTools UI
class BlocScreen extends Screen {
  const BlocScreen()
      : super.conditional(
          id: id,
          requiresLibrary: 'package:flutter_bloc/',
          title: 'Bloc',
          icon: Icons.palette,
        );

  static const id = 'bloc';

  @override
  Widget build(BuildContext context) {
    final evalOnDartLibrary = EvalOnDartLibrary(
        ['package:bloc/src/bloc_observer.dart'], serviceManager.service);
    return MultiBlocProvider(
        providers: [
          BlocProvider<BlocListBloc>(
            create: (context) =>
                BlocListBloc(evalOnDartLibrary, serviceManager.service)
                  ..add(BlocListRequested()),
          ),
          BlocProvider<BlocNodeBloc>(
            create: (context) =>
                BlocNodeBloc(evalOnDartLibrary, serviceManager.service),
          )
        ],
        child:
            BlocBuilder<BlocListBloc, BlocListState>(builder: (context, state) {
          if (state.status == BlocListStatus.initial) {
            return const BlocInitialView();
          } else if (state.status == BlocListStatus.loading) {
            return const BlocLoadingView();
          } else if (state.status == BlocListStatus.success) {
            return BlocListView(state.blocs);
          } else {
            return const BlocErrorView();
          }
        }));
  }
}
