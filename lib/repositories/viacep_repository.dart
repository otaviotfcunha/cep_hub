import 'dart:convert';
import 'package:cep_hub/models/viacep_model.dart';
import 'package:http/http.dart' as http;

class ViaCepRepository {

  Future<ViaCepModel> consultarCEP(String cep) async{

    var resposta = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if(resposta.statusCode == 200){
      var respostaJson = jsonDecode(resposta.body);
      return ViaCepModel.fromJson(respostaJson);
    }else{
      return ViaCepModel();
    }
  }

}