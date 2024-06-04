import 'package:equatable/equatable.dart';
import 'package:cep_hub/models/enderecos_model.dart';
import 'package:cep_hub/repositories/enderecos_salvos_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos
abstract class EnderecosEvent extends Equatable {
  const EnderecosEvent();

  @override
  List<Object> get props => [];
}

class CarregarEnderecos extends EnderecosEvent {}

class AtualizarEndereco extends EnderecosEvent {
  final EnderecoModel endereco;

  const AtualizarEndereco(this.endereco);

  @override
  List<Object> get props => [endereco];
}

class RemoverEndereco extends EnderecosEvent {
  final String id;

  const RemoverEndereco(this.id);

  @override
  List<Object> get props => [id];
}

// Estados
abstract class EnderecosState extends Equatable {
  const EnderecosState();

  @override
  List<Object> get props => [];
}

class EnderecosInitial extends EnderecosState {}

class EnderecosLoading extends EnderecosState {}

class EnderecosLoaded extends EnderecosState {
  final EnderecosModel enderecos;

  const EnderecosLoaded(this.enderecos);

  @override
  List<Object> get props => [enderecos];
}

class EnderecosError extends EnderecosState {
  final String message;

  const EnderecosError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class EnderecosBloc extends Bloc<EnderecosEvent, EnderecosState> {
  final EnderecosSalvosRepository enderecosRepository;

  EnderecosBloc(this.enderecosRepository) : super(EnderecosInitial()) {
    on<CarregarEnderecos>(_onCarregarEnderecos);
    on<AtualizarEndereco>(_onAtualizarEndereco);
    on<RemoverEndereco>(_onRemoverEndereco);
  }

  Future<void> _onCarregarEnderecos(CarregarEnderecos event, Emitter<EnderecosState> emit) async {
    emit(EnderecosLoading());
    try {
      final enderecos = await enderecosRepository.listarEnderecos();
      emit(EnderecosLoaded(enderecos));
    } catch (e) {
      emit(EnderecosError("Erro ao carregar endereços"));
    }
  }

  Future<void> _onAtualizarEndereco(AtualizarEndereco event, Emitter<EnderecosState> emit) async {
    emit(EnderecosLoading());
    try {
      await enderecosRepository.atualizar(event.endereco);
      final enderecos = await enderecosRepository.listarEnderecos();
      emit(EnderecosLoaded(enderecos));
    } catch (e) {
      emit(EnderecosError("Erro ao atualizar endereço"));
    }
  }

  Future<void> _onRemoverEndereco(RemoverEndereco event, Emitter<EnderecosState> emit) async {
    emit(EnderecosLoading());
    try {
      await enderecosRepository.remover(event.id);
      final enderecos = await enderecosRepository.listarEnderecos();
      emit(EnderecosLoaded(enderecos));
    } catch (e) {
      emit(EnderecosError("Erro ao remover endereço"));
    }
  }
}
