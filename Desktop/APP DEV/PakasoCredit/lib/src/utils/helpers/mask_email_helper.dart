class MaskEmailHelper {
  static String maskEmail(String email) {
    if (email.isEmpty || !email.contains('@')) return email;
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final username = parts[0];
    final domain = parts[1];
    final lastDotIndex = domain.lastIndexOf('.');
    if (lastDotIndex == -1) return '$username@*****';
    final maskedDomain = '*****${domain.substring(lastDotIndex)}';
    return '$username@$maskedDomain';
  }
}
