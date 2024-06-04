// Defina os eventos para o BLoC
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MyEvent extends Equatable {
  const MyEvent();

  @override
  List<Object> get props => [];
}

class LoadData extends MyEvent {}

// Defina os estados para o BLoC
abstract class MyState extends Equatable {
  const MyState();

  @override
  List<Object> get props => [];
}

class InitialState extends MyState {}

class LoadingState extends MyState {}

class LoadedState extends MyState {
  final List<String> data;

  const LoadedState(this.data);

  @override
  List<Object> get props => [data];
}

// Implemente o BLoC
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(InitialState()) {
    on<LoadData>((event, emit) async {
      emit(LoadingState());
      await Future.delayed(Duration(seconds: 2)); // Simula uma operação assíncrona
      emit(LoadedState(["Item 1", "Item 2", "Item 3"])); // Dados simulados
    });
  }
}
