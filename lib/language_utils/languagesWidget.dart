class Language {
  final int id;
  final String flag;
  final String name;
  final String code;

  Language(this.id, this.flag, this.name, this.code);

  static List<Language> languagesList(){
    return [
      Language(1, '🇺🇸', 'English', 'en'),
      Language(1, '🇩🇿', 'Arabic', 'ar'),
      Language(1, '🇫🇷󠁦󠁲󠁨󠁤', 'French', 'fr'),
    ];
  }
}