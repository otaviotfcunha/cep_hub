import 'package:equatable/equatable.dart';
import 'package:cep_hub/models/viacep_model.dart';
import 'package:cep_hub/repositories/viacep_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos
abstract class CepEvent extends Equatable {
  const CepEvent();

  @override
  List<Object> get props => [];
}

class ConsultarCep extends CepEvent {
  final String cep;

  const ConsultarCep(this.cep);

  @override
  List<Object> get props => [cep];
}

// Estados
abstract class CepState extends Equatable {
  const CepState();

  @override
  List<Object> get props => [];
}

class CepInitial extends CepState {}

class CepLoading extends CepState {}

class CepLoaded extends CepState {
  final ViaCepModel cepModel;

  const CepLoaded(this.cepModel);

  @override
  List<Object> get props => [cepModel];
}

class CepError extends CepState {
  final String message;

  const CepError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CepBloc extends Bloc<CepEvent, CepState> {
  final ViaCepRepository viaCepRepository;

  CepBloc(this.viaCepRepository) : super(CepInitial()) {
    on<ConsultarCep>(_onConsultarCep);
  }

  Future<void> _onConsultarCep(ConsultarCep event, Emitter<CepState> emit) async {
    emit(CepLoading());
    try {
      final cepModel = await viaCepRepository.consultarCEP(event.cep);
      emit(CepLoaded(cepModel));
    } catch (e) {
      emit(CepError("Erro ao consultar o CEP"));
    }
  }
}
