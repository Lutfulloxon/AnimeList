import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('uz', ''),
    Locale('en', ''),
  ];

  // Home Screen
  String get appName => locale.languageCode == 'uz' ? 'Anime Uy' : 'Anime Home';
  String get trending => locale.languageCode == 'uz' ? 'Mashhur' : 'Trending';
  String get seeAll =>
      locale.languageCode == 'uz' ? 'Barchasini ko\'rish' : 'See all';
  String get play => locale.languageCode == 'uz' ? 'Tomosha qilish' : 'Play';
  String get myList =>
      locale.languageCode == 'uz' ? 'Mening ro\'yxatim' : 'My List';
  String get added => locale.languageCode == 'uz' ? 'Qo\'shildi' : 'Added';

  // Navigation
  String get home => locale.languageCode == 'uz' ? 'Bosh sahifa' : 'Home';
  String get search => locale.languageCode == 'uz' ? 'Qidirish' : 'Search';
  String get categories =>
      locale.languageCode == 'uz' ? 'Kategoriyalar' : 'Categories';
  String get likes => locale.languageCode == 'uz' ? 'Sevimlilar' : 'Likes';
  String get profile => locale.languageCode == 'uz' ? 'Profil' : 'Profile';

  // Search
  String get searchHint =>
      locale.languageCode == 'uz' ? 'Anime qidiring...' : 'Search anime...';
  String get resultsFound =>
      locale.languageCode == 'uz' ? 'natija topildi' : 'results found';
  String get noResults =>
      locale.languageCode == 'uz' ? 'Hech narsa topilmadi' : 'No results found';
  String get tryDifferentKeywords => locale.languageCode == 'uz'
      ? 'Boshqa kalit so\'zlarni sinab ko\'ring'
      : 'Try different keywords';

  // Categories
  String get exploreByGenre => locale.languageCode == 'uz'
      ? 'Janr bo\'yicha o\'rganing'
      : 'Explore anime by genre';
  String get categoryNotFound => locale.languageCode == 'uz'
      ? 'kategoriyasida\nanime topilmadi'
      : 'category\nno anime found';
  String get tryOtherCategories => locale.languageCode == 'uz'
      ? 'Boshqa kategoriyalarni sinab ko\'ring'
      : 'Try other categories';

  // Profile
  String get editProfile =>
      locale.languageCode == 'uz' ? 'Profilni tahrirlash' : 'Edit Profile';
  String get notification =>
      locale.languageCode == 'uz' ? 'Bildirishnomalar' : 'Notification';
  String get security =>
      locale.languageCode == 'uz' ? 'Xavfsizlik' : 'Security';
  String get language => locale.languageCode == 'uz' ? 'Til' : 'Language';
  String get darkMode =>
      locale.languageCode == 'uz' ? 'Tungi rejim' : 'Dark Mode';
  String get helpSupport => locale.languageCode == 'uz'
      ? 'Yordam va qo\'llab-quvvatlash'
      : 'Help & Support';
  String get aboutApp =>
      locale.languageCode == 'uz' ? 'Ilova haqida' : 'About App';

  // Profile Edit
  String get chooseAvatar =>
      locale.languageCode == 'uz' ? 'Avatar tanlang' : 'Choose Avatar';
  String get name => locale.languageCode == 'uz' ? 'Ism' : 'Name';
  String get email => locale.languageCode == 'uz' ? 'Email' : 'Email';
  String get bio => locale.languageCode == 'uz' ? 'Bio' : 'Bio';
  String get save => locale.languageCode == 'uz' ? 'Saqlash' : 'Save';
  String get saving =>
      locale.languageCode == 'uz' ? 'Saqlanmoqda...' : 'Saving...';
  String get profileSaved =>
      locale.languageCode == 'uz' ? 'Profil saqlandi!' : 'Profile saved!';
  String get pleaseEnterName => locale.languageCode == 'uz'
      ? 'Iltimos, ismingizni kiriting'
      : 'Please enter your name';
  String get pleaseEnterValidEmail => locale.languageCode == 'uz'
      ? 'Iltimos, to\'g\'ri email kiriting'
      : 'Please enter a valid email';

  // Language Dialog
  String get chooseLanguage =>
      locale.languageCode == 'uz' ? 'Tilni tanlang' : 'Choose Language';
  String get uzbek => locale.languageCode == 'uz' ? 'O\'zbek' : 'Uzbek';
  String get english => locale.languageCode == 'uz' ? 'Ingliz' : 'English';
  String get cancel => locale.languageCode == 'uz' ? 'Bekor qilish' : 'Cancel';

  // Likes Screen
  String get myListTitle =>
      locale.languageCode == 'uz' ? 'Mening ro\'yxatim' : 'My List';
  String get favoriteCollection => locale.languageCode == 'uz'
      ? 'Sevimli anime to\'plamingiz'
      : 'Your favorite anime collection';
  String get favoriteAnimes => locale.languageCode == 'uz'
      ? 'Sevimli anime\'laringiz'
      : 'Your favorite animes';
  String get clearAll =>
      locale.languageCode == 'uz' ? 'Barchasini tozalash' : 'Clear All';
  String get noFavorites => locale.languageCode == 'uz'
      ? 'Hali sevimli anime\'lar yo\'q'
      : 'No favorite animes yet';
  String get startExploring => locale.languageCode == 'uz'
      ? 'Kashf qilishni boshlang va sevimli anime\'laringizni qo\'shing'
      : 'Start exploring and add your favorite animes';

  // Messages
  String get addedToMyList => locale.languageCode == 'uz'
      ? 'My List\'ga qo\'shildi'
      : 'Added to My List';
  String get removedFromFavorites => locale.languageCode == 'uz'
      ? 'Sevimlilardan olib tashlandi'
      : 'Removed from favorites';
  String get error =>
      locale.languageCode == 'uz' ? 'Xatolik yuz berdi' : 'An error occurred';

  // Anime Details
  String get releaseDate =>
      locale.languageCode == 'uz' ? 'Chiqarilgan sana' : 'Release date';
  String get synopsis =>
      locale.languageCode == 'uz' ? 'Qisqacha mazmun' : 'Synopsis';
  String get episodes => locale.languageCode == 'uz' ? 'Epizodlar' : 'Episodes';
  String get rating => locale.languageCode == 'uz' ? 'Reyting' : 'Rating';
  String get genres => locale.languageCode == 'uz' ? 'Janrlar' : 'Genres';
  String get imagesAndVideos =>
      locale.languageCode == 'uz' ? 'Rasmlar va Videolar' : 'Images and Videos';

  // Common
  String get loading =>
      locale.languageCode == 'uz' ? 'Yuklanmoqda...' : 'Loading...';
  String get retry => locale.languageCode == 'uz' ? 'Qayta urinish' : 'Retry';
  String get unknown => locale.languageCode == 'uz' ? 'Noma\'lum' : 'Unknown';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['uz', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
