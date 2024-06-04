class EnderecosModel {
  List<EnderecoModel> results = [];

  EnderecosModel(this.results);

  EnderecosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <EnderecoModel>[];
      json['results'].forEach((v) {
        results.add(EnderecoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class EnderecoModel {
  String objectId = "";
  String nome = "";
  String cep = "";
  String rua = "";
  String bairro = "";
  String cidade = "";
  String estado = "";
  String createdAt = "";
  String updatedAt = "";

  EnderecoModel(this.objectId, this.nome, this.cep, this.rua, this.bairro, this.cidade, this.estado, this.createdAt, this.updatedAt);

  EnderecoModel.adicionar(this.nome, this.cep, this.rua, this.bairro, this.cidade, this.estado);
  EnderecoModel.adicionaEAtualiza(this.objectId, this.nome, this.cep, this.rua, this.bairro, this.cidade, this.estado);

  EnderecoModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'].toString();
    cep = json['cep'];
    rua = json['rua'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    estado = json['estado'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['cep'] = cep;
    data['rua'] = rua;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['estado'] = estado;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['cep'] = cep;
    data['rua'] = rua;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['estado'] = estado;
    return data;
  }
}
