import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cep_hub/blocs/cep_bloc.dart';
import 'package:cep_hub/models/enderecos_model.dart';
import 'package:cep_hub/pages/enderecos_page.dart';
import 'package:cep_hub/repositories/enderecos_salvos_repository.dart';
import 'package:cep_hub/shared/app_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cepController = TextEditingController(text: "");
  var nomeController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Image(image: AssetImage(AppImages.logotipo)),
            ),
          ),
        ),
        body: BlocListener<CepBloc, CepState>(
          listener: (context, state) {
            if (state is CepLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("CEP consultado com sucesso.")),
              );
            } else if (state is CepError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      const Text("Nome do Local"),
                      const SizedBox(height: 25),
                      TextField(
                        maxLength: 8,
                        controller: nomeController,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 25),
                      const Text("Consultar CEP"),
                      const SizedBox(height: 25),
                      TextField(
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        controller: cepController,
                        onChanged: (value) {
                          var cep = value.replaceAll(RegExp(r'[^0-9]'), "");
                          if (cep.length == 8) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<CepBloc>().add(ConsultarCep(cep));
                          }
                        },
                      ),
                      BlocBuilder<CepBloc, CepState>(
                        builder: (context, state) {
                          if (state is CepLoading) {
                            return const CircularProgressIndicator();
                          } else if (state is CepLoaded) {
                            return Column(
                              children: [
                                const SizedBox(height: 50),
                                Text(state.cepModel.logradouro ?? ""),
                                const SizedBox(height: 10),
                                Text(state.cepModel.bairro ?? ""),
                                const SizedBox(height: 10),
                                Text("${state.cepModel.localidade ?? ""} ${state.cepModel.uf ?? ""}"),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<CepBloc, CepState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (cepController.text.length == 8 && state is CepLoaded) {
                  EnderecosSalvosRepository endSalvos = EnderecosSalvosRepository();
                  bool verificaCep = await endSalvos.buscarEndereco(state.cepModel.cep ?? "");

                  if (!verificaCep) {
                    await endSalvos.adicionar(EnderecoModel.adicionar(
                      state.cepModel.nome ?? nomeController.text,
                      state.cepModel.cep ?? "",
                      state.cepModel.logradouro ?? "",
                      state.cepModel.bairro ?? "",
                      state.cepModel.localidade ?? "",
                      state.cepModel.uf ?? "",
                    ));
                    cepController.clear();
                    nomeController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("O endereço foi adicionado com sucesso!.")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Este endereço já existe no banco de dados.")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Você precisa digitar um cep válido para salvar.")),
                  );
                  cepController.clear();
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            if (value == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EnderecosPage()),
              );
            }
          },
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: "Endereços Salvos", icon: Icon(Icons.history)),
          ],
        ),
      ),
    );
  }
}
