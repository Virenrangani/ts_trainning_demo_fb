String? validateEmail(String email) {
  final emailValue = email.trim().toLowerCase();

  if (emailValue.isEmpty) return "Email is required";
  if (emailValue.contains(" ")) return "Email should not contain spaces";

  final regex = RegExp(
    r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$',
  );

  if (!regex.hasMatch(emailValue)) {
    return "Enter a valid email";
  }

  return null;
}

String? validatePassword(String password) {
  if (password.isEmpty) return "Password is required";
  if (password.length < 8) return "Minimum 8 characters required";
  if(password.contains(" ")) return "Password should not contain spaces";

  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return "Add at least one uppercase letter";
  }

  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return "Add at least one lowercase letter";
  }

  if (!RegExp(r'[0-9]').hasMatch(password)) {
    return "Add at least one number";
  }

  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    return "Add at least one special character";
  }

  return null;
}