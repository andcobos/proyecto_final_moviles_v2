import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';

class ProviderRegisterPage extends ConsumerStatefulWidget {
  static const name = 'ProviderRegisterPage';
  const ProviderRegisterPage({super.key});

  @override
  ConsumerState<ProviderRegisterPage> createState() => _ProviderRegisterPageState();
}

class _ProviderRegisterPageState extends ConsumerState<ProviderRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _professionCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _professionCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu nombre';
    if (v.trim().length < 3) return 'Nombre demasiado corto';
    return null;
  }

  String? _validateProfession(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu profesión/oficio';
    if (v.trim().length < 3) return 'Profesión demasiado corta';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
    final re = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!re.hasMatch(v.trim())) return 'Correo inválido';
    return null;
  }

  String? _validatePass(String? v) {
    if (v == null || v.isEmpty) return 'Crea una contraseña';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  Future<void> _onSubmit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    try {
      // Parse name into firstName and lastName
      final nameParts = _nameCtrl.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Create register request
      final request = RegisterRequest(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        firstName: firstName,
        lastName: lastName.isEmpty ? firstName : lastName,
        role: 'CONTRACTOR',
      );

      // Register and login
      await ref.read(authProvider.notifier).register(request);

      if (mounted) {
        // Navigate to contractor home
        context.go('/pro/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Bienvenido $firstName! No olvides agregar tus servicios.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1D3557),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Volver a inicio',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.jpg', width: 140, fit: BoxFit.contain),
                  const SizedBox(height: 12),
                  Text('Bienvenido!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.blueGrey.shade700,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    'Encuentra proyectos y tareas en hogares que necesitan tu experiencia. '
                    'Fixea te conecta con clientes que buscan profesionales confiables y calificados como tú.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Nombre Apellido',
                          ),
                          validator: _validateName,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _professionCtrl,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Profesión',
                            hintText: 'Ej.: Electricista, Plomero, Albañil',
                          ),
                          validator: _validateProfession,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          validator: _validatePass,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _onSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color(0xFF1D3557),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20, width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Registrarse', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Ya tienes cuenta? '),
                      InkWell(
                        onTap: () => context.go('/auth/provider/login'),
                        child: const Text('Inicia Sesión', style: TextStyle(decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
