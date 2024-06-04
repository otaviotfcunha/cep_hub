import 'package:cep_hub/repositories/enderecos_salvos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cep_hub/blocs/enderecos_bloc.dart';
import 'package:cep_hub/models/enderecos_model.dart';
import 'package:cep_hub/models/viacep_model.dart';
import 'package:cep_hub/repositories/viacep_repository.dart';

class EnderecosPage extends StatefulWidget {
  const EnderecosPage({super.key});

  @override
  State<EnderecosPage> createState() => _EnderecosPageState();
}

class _EnderecosPageState extends State<EnderecosPage> {
  @override
  void initState() {
    super.initState();
    context.read<EnderecosBloc>().add(CarregarEnderecos());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Seus endereços",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<EnderecosBloc, EnderecosState>(
          builder: (context, state) {
            if (state is EnderecosLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EnderecosLoaded) {
              return ListView.builder(
                itemCount: state.enderecos.results.length,
                itemBuilder: (BuildContext bc, int index) {
                  var end = state.enderecos.results[index];
                  var cepController = TextEditingController(text: end.cep.replaceAll(RegExp(r'[^0-9]'), ""));
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NOME: ${end.nome.toString()}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "CEP: ${end.cep.toString()}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(end.rua.toString()),
                                Text(end.bairro.toString()),
                                Text("${end.cidade} / ${end.estado}"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  context: context,
                                  builder: (BuildContext bc) {
                                    var cepConsultado = ViaCepModel();
                                    var viaCEPRepository = ViaCepRepository();
                                    var enderecoSalvoRepository = EnderecosSalvosRepository();
                                    bool loading = false;
                                    return Column(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextField(
                                                  maxLength: 8,
                                                  keyboardType: TextInputType.number,
                                                  controller: cepController,
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    FocusManager.instance.primaryFocus?.unfocus();
                                                    Navigator.pop(context);
                                                    var cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), "");
                                                    if (cep.length == 8) {
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                      cepConsultado = await viaCEPRepository.consultarCEP(cep);
                                                      if (cepController.text != end.cep.replaceAll(RegExp(r'[^0-9]'), "")) {
                                                        bool verificaCep = await enderecoSalvoRepository.buscarEndereco(cepConsultado.cep ?? "");
                                                        if (verificaCep) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(content: Text("O cep digitado já está na base de dados...")),
                                                          );
                                                          context.read<EnderecosBloc>().add(CarregarEnderecos());
                                                          return;
                                                        }
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext bc) {
                                                            return AlertDialog(
                                                              alignment: Alignment.centerLeft,
                                                              title: const Text("Atualizar Endereço"),
                                                              content: Wrap(
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      const Text("Novo endereço localizado:"),
                                                                      Text(cepConsultado.nome ?? end.nome.toString()),
                                                                      Text(cepConsultado.logradouro ?? ""),
                                                                      Text(cepConsultado.bairro ?? ""),
                                                                      Text(cepConsultado.localidade ?? ""),
                                                                      Text(cepConsultado.uf ?? ""),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text("Cancelar"),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () async {
                                                                    var cepAltera = EnderecoModel.adicionaEAtualiza(
                                                                      end.objectId,
                                                                      end.nome.toString(),
                                                                      cepConsultado.cep ?? "",
                                                                      cepConsultado.logradouro ?? "",
                                                                      cepConsultado.bairro ?? "",
                                                                      cepConsultado.localidade ?? "",
                                                                      cepConsultado.uf ?? "",
                                                                    );
                                                                    context.read<EnderecosBloc>().add(AtualizarEndereco(cepAltera));
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text("Atualizar"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("Você não modificou o cep...")),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: const Text("Verificar Endereço"),
                                                ),
                                                const Divider(height: 5),
                                                Visibility(
                                                  visible: loading,
                                                  child: const CircularProgressIndicator(),
                                                ),
                                                Text(cepConsultado.logradouro ?? end.rua),
                                                Text(cepConsultado.bairro ?? end.bairro),
                                                Text(cepConsultado.localidade ?? end.cidade),
                                                Text(cepConsultado.uf ?? end.estado),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(Icons.edit),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              onPressed: () {
                                context.read<EnderecosBloc>().add(RemoverEndereco(end.objectId));
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is EnderecosError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
