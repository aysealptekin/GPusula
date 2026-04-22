class AppValidators {
  static String? emailDogrula(String? value) {
    if (value == null || value.isEmpty) {
      return "E-posta boş olamaz";
    }
    if (!value.endsWith("@gmail.com")) {
      return "Sadece @gmail.com uzantısı kabul edilir";
    }
    return null;
  }

  static String? sifreDogrula(String? value) {
    if (value == null || value.isEmpty) return "Şifre boş olamaz";
    if (value.length < 6) return "En az 6 karakter olmalı";
    if (!value.contains(RegExp(r'[A-Z]'))) return "En az bir büyük harf lazım";
    if (!value.contains(RegExp(r'[0-9]'))) return "En az bir rakam lazım";
    return null;
  }

  static String? isimZorunlu(String? value) {
    if (value == null || value.isEmpty) {
      return "isim girilmesi zorunludur.";
    }
    return null;
  }
}
