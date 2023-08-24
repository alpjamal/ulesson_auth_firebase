part of 'package:ulesson_auth_firebase/auth/presentation/sign_up_page.dart';

mixin SignUpPageMixin on State<SignUpPage> {
  late AuthBloc _authBloc;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  _initControllers() {
    _authBloc = context.read<AuthBloc>();
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }
}
