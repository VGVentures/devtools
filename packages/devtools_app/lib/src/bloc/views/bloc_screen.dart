import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../eval_on_dart_library.dart';
import '../../globals.dart';
import '../../screen.dart';
import '../bloc/bloc_list_bloc.dart';
import '../widgets/bloc_error_view.dart';
import '../widgets/bloc_initial_view.dart';
import '../widgets/bloc_loading_view.dart';
import '../widgets/bloc_view.dart';

class BlocScreen extends Screen {
  const BlocScreen()
      : super.conditional(
            id: id,
            requiresLibrary: 'package:flutter_bloc/',
            title: 'Bloc',
            icon: Icons.palette);

  static const id = 'bloc';

  @override
  Widget build(BuildContext context) {
    return const BlocScreenBody();
  }
}

class BlocScreenBody extends StatelessWidget {
  const BlocScreenBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final evalOnDartLibrary = EvalOnDartLibrary(
        ['package:flutter_bloc/flutter_bloc.dart'], serviceManager.service);
    return RepositoryProvider.value(
        value: evalOnDartLibrary,
        child: BlocProvider(
            create: (context) =>
                BlocListBloc(context.read<EvalOnDartLibrary>()),
            child: BlocBuilder<BlocListBloc, BlocListState>(
                builder: (context, state) {
              if (state is BlocListInitial) {
                return const BlocInitialView();
              } else if (state is BlocListLoadInProgress) {
                return const BlocLoadingView();
              } else if (state is BlocListLoadSuccess) {
                return BlocView(state.blocs, state.selectedBlocId);
              } else if (state is BlocListLoadFailure) {
                return const BlocErrorView();
              } else {
                return const BlocErrorView();
              }
            })));
  }
}
