import 'package:cep_hub/models/enderecos_model.dart';
import 'package:cep_hub/repositories/custom_dio.dart';


class EnderecosSalvosRepository {
  final _customDio = CustomDio();

  EnderecosSalvosRepository();

  Future<EnderecosModel> listarEnderecos() async {
    var url = "/enderecos/";
    var result = await _customDio.dio.get(url);
    return EnderecosModel.fromJson(result.data);
  }

  Future<bool> buscarEndereco(String cep) async {
    bool encontrado = false;
    var url = "/enderecos/";
    url = "$url?where={\"cep\":\"$cep\"}";
    var result = await _customDio.dio.get(url);
    var registros = EnderecosModel.fromJson(result.data);
    if(registros.results.isNotEmpty){
      encontrado = true;
    }
    return encontrado;
  }

  Future<void> adicionar(EnderecoModel enderecoModel) async {
    try {
      await _customDio.dio
          .post("/enderecos/", data: enderecoModel.toJsonEndpoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> atualizar(EnderecoModel enderecoModel) async {
    try {
      await _customDio.dio.put(
          "/enderecos/${enderecoModel.objectId}",
          data: enderecoModel.toJsonEndpoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _customDio.dio.delete(
        "/enderecos/$objectId",
      );
    } catch (e) {
      throw e;
    }
  }
}