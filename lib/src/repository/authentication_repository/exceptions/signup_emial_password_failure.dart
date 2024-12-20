class SignupEmialPasswordFailure {
  final String message;

  const SignupEmialPasswordFailure(
      [this.message = "An Unknown error occured."]);

  factory SignupEmialPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupEmialPasswordFailure(
            'Please enter a strong password.');
      case 'invalid-email':
        return const SignupEmialPasswordFailure(
            'Email is not valid or badly formatted.');
      case 'email-already-in-use':
        return const SignupEmialPasswordFailure(
            'An account already exist for that email.');
      case 'operation-not-allowed':
        return const SignupEmialPasswordFailure(
            'Operation is not allowed. Please contact support.');
      case 'user-disabled':
        return const SignupEmialPasswordFailure(
            'This user has been disabled. Please contact support for help.');
      default:
        return const SignupEmialPasswordFailure();
    }
  }
}
