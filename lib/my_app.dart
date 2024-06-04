import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/home_page.dart';
import 'blocs/cep_bloc.dart';
import 'blocs/enderecos_bloc.dart';
import 'repositories/viacep_repository.dart';
import 'repositories/enderecos_salvos_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CepBloc>(
          create: (context) => CepBloc(ViaCepRepository()),
        ),
        BlocProvider<EnderecosBloc>(
          create: (context) => EnderecosBloc(EnderecosSalvosRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
