import 'package:flutter/material.dart';
import 'package:reposit/_comum/meu_snackbar.dart';
import 'package:reposit/_comum/minhas_cores.dart';
import 'package:reposit/componentes/decoracao_campo_autenticacao.dart';
import 'package:reposit/servicos/autenticacao_servico.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutenticacaoTelaState();
}

class _AutenticacaoTelaState extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _nomeController = TextEditingController();

  AutenticacaoServico _autenServico = AutenticacaoServico();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MinhasCores.azulTopoGradiente,
                  MinhasCores.azulBaixoGradiente,
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/new_image.jpg",
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Braypress",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo E-mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: getAuthenticationInputDecoration("E-mail"),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "O e-mail não pode ser vazio";
                        }
                        if (value.length < 5) {
                          return "O e-mail deve ter pelo menos 5 caracteres";
                        }
                        if (!value.contains("@") || !value.contains(".")) {
                          return "Informe um e-mail válido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Campo Senha
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: getAuthenticationInputDecoration("Senha"),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "A senha não pode ser vazia";
                        }
                        if (value.length < 5) {
                          return "A senha deve ter pelo menos 5 caracteres";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Campos visíveis apenas no modo de cadastro
                    if (!queroEntrar) ...[
                      TextFormField(
                        controller: _confirmarSenhaController,
                        obscureText: true,
                        decoration: getAuthenticationInputDecoration("Confirme a sua senha"),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "A confirmação da senha não pode ser vazia";
                          }
                          if (value != _senhaController.text) {
                            return "As senhas não coincidem";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nomeController,
                        decoration: getAuthenticationInputDecoration("Primeiro nome"),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return "O nome não pode ser vazio";
                          }
                          if (value.trim().length < 3) {
                            return "O nome deve ter pelo menos 3 caracteres";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                    ],

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: botaoPrincipalClicado,
                      child: Text(queroEntrar ? "Entrar" : "Cadastrar"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        String? erro = await _autenServico.logarComGoogle();

                        if (erro != null) {
                          mostrarSnackbar(context: context, texto: erro);
                        } else {
                          mostrarSnackbar(context: context, texto: "Autenticado com Google com sucesso!", isErro: false);
                        }
                      },
                      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.black),
                      label: Text(queroEntrar ? "Entrar com Google" : "Cadastrar com Google"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                    const Divider(height: 32),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          queroEntrar = !queroEntrar;
                          _formKey.currentState?.reset();
                        });
                      },
                      child: Text(
                        queroEntrar
                            ? "Ainda não tem uma conta? Cadastre-se!"
                            : "Já tem uma conta? Entre!",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void botaoPrincipalClicado() {
    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        AutenticacaoServico().logarUsuarios(email: _emailController.text, senha: _senhaController.text).then((String? erro) {
          if (erro != null) {
            mostrarSnackbar(context: context, texto: erro);
          }
        });
      } else {
        _autenServico.cadastrarUsuario(
          email: _emailController.text,
          senha: _senhaController.text,
          nome: _nomeController.text,
        ).then((String? erro) {
          if (erro != null) {
            mostrarSnackbar(context: context, texto: erro);
          } else {
            mostrarSnackbar(context: context, texto: "Cadastro realizado com sucesso!", isErro: false);
          }
        });
      }
    }
  }
}