part of "../login.dart";

class AuthPageWidget extends ConsumerStatefulWidget {
  const AuthPageWidget(
    this.formKey, {
    super.key,
    required this.emailController,
    required this.passController,
    required this.isObsecure,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passController;
  final bool isObsecure;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageWidgetState();
}

class _AuthPageWidgetState extends ConsumerState<AuthPageWidget> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifier).isLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldInput(
          title: "Email",
          hintText: "Masukkan Alamat Email",
          controller: widget.emailController,
          textValidator: "Email",
          keyboardType: TextInputType.text,
          obsecureText: false,
        ),
        const SizedBox(height: 10),
        FieldInput(
          title: "Password",
          hintText: "Password 8+ Karakter",
          controller: widget.passController,
          textValidator: "Email",
          keyboardType: TextInputType.text,
          obsecureText: widget.isObsecure,
          suffixIcon: IconButton(
            onPressed: () {
              ref.watch(obsecureProvider.notifier).state = (!widget.isObsecure);
            },
            icon: Icon(
              widget.isObsecure ? Icons.visibility_off : Icons.visibility,
              color: widget.isObsecure ? Colors.grey : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: _handleLogin,
          child: isLoading ? const LoadingInButton() : const Text("Masuk"),
        ),
      ],
    );
  }

  _handleLogin() {
    if (widget.formKey.currentState!.validate()) {
      final auth = ref.watch(authNotifier.notifier);
      auth
          .login(widget.emailController.text, widget.passController.text)
          .then((success) {
        if (success) {
          final route = ref.watch(authNotifier).data;
          log(route!);
          nextPageRemove(context, route);
        } else {
          final msg = ref.watch(authNotifier).error;
          showSnackbar(context, msg!, isWarning: true);
        }
      });
    }
  }

}
