import 'package:get/get.dart';

/// Translation keys. Use with `.tr`: `Text(AppString.next.tr)`.
abstract class AppString {
  const AppString._();

  // Brand (not translated)
  static const appName = 'DamnerLaor';
  static const appNameKm = 'ដំណើរល្អ';
  static const tagline = 'Travel More · Explore More · Together';

  // Common
  static const next = 'next';
  static const skip = 'skip';
  static const continueText = 'continue';
  static const getStarted = 'get_started';

  // S2 Intro
  static const introTitle1 = 'intro_title_1';
  static const introBody1 = 'intro_body_1';
  static const introTitle2 = 'intro_title_2';
  static const introBody2 = 'intro_body_2';
  static const introTitle3 = 'intro_title_3';
  static const introBody3 = 'intro_body_3';
  static const busTickets = 'bus_tickets';
  static const busTicketsDesc = 'bus_tickets_desc';
  static const hotels = 'hotels';
  static const hotelsDesc = 'hotels_desc';
  static const transportHotel = 'transport_hotel';
  static const transportHotelDesc = 'transport_hotel_desc';

  // S3 Language
  static const chooseLanguage = 'choose_language';
  static const chooseLanguageDesc = 'choose_language_desc';
  static const browseAsGuest = 'browse_as_guest';
}

/// GetX translations. Khmer copy needs native-speaker review (UI/UX v3.1 next steps #5).
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          AppString.next: 'Next',
          AppString.skip: 'Skip',
          AppString.continueText: 'Continue',
          AppString.getStarted: 'Get started',
          AppString.introTitle1: 'Bus, hotel or both',
          AppString.introBody1:
              'Book bus tickets, hotels and Transport + Hotel packages across Cambodia in one app.',
          AppString.introTitle2: 'Pick your seat',
          AppString.introBody2:
              'See the seat map, choose your seat and get a QR ticket on your phone.',
          AppString.introTitle3: 'Pay your way',
          AppString.introBody3:
              'Pay with KHQR, ABA Mobile or card. Your tickets and vouchers work offline.',
          AppString.busTickets: 'Bus tickets',
          AppString.busTicketsDesc: 'Pick your seat, QR ticket',
          AppString.hotels: 'Hotels',
          AppString.hotelsDesc: 'Photos, rooms, free cancellation',
          AppString.transportHotel: 'Transport + Hotel',
          AppString.transportHotelDesc: 'Book both, save up to 10%',
          AppString.chooseLanguage: 'Choose your language',
          AppString.chooseLanguageDesc: 'You can change this later in Profile.',
          AppString.browseAsGuest: 'Browse as guest',
        },
        'km': {
          AppString.next: 'បន្ទាប់',
          AppString.skip: 'រំលង',
          AppString.continueText: 'បន្ត',
          AppString.getStarted: 'ចាប់ផ្តើម',
          AppString.introTitle1: 'ឡានក្រុង សណ្ឋាគារ ឬទាំងពីរ',
          AppString.introBody1:
              'កក់សំបុត្រឡានក្រុង សណ្ឋាគារ និងកញ្ចប់ដំណើរ នៅទូទាំងកម្ពុជា ក្នុងកម្មវិធីតែមួយ។',
          AppString.introTitle2: 'ជ្រើសរើសកៅអីរបស់អ្នក',
          AppString.introBody2:
              'មើលប្លង់កៅអី ជ្រើសរើសកៅអី ហើយទទួលបានសំបុត្រ QR នៅលើទូរស័ព្ទ។',
          AppString.introTitle3: 'បង់ប្រាក់ងាយស្រួល',
          AppString.introBody3:
              'បង់ប្រាក់តាម KHQR, ABA Mobile ឬកាត។ សំបុត្រ និងប័ណ្ណស្នាក់នៅ ប្រើបានទោះគ្មានអ៊ីនធឺណិត។',
          AppString.busTickets: 'សំបុត្រឡានក្រុង',
          AppString.busTicketsDesc: 'ជ្រើសរើសកៅអី សំបុត្រ QR',
          AppString.hotels: 'សណ្ឋាគារ',
          AppString.hotelsDesc: 'រូបភាព បន្ទប់ លុបចោលឥតគិតថ្លៃ',
          AppString.transportHotel: 'កញ្ចប់ដំណើរ',
          AppString.transportHotelDesc: 'កក់ទាំងពីរ សន្សំបានដល់ 10%',
          AppString.chooseLanguage: 'ជ្រើសរើសភាសា',
          AppString.chooseLanguageDesc: 'អ្នកអាចប្តូរនៅពេលក្រោយក្នុងប្រវត្តិរូប។',
          AppString.browseAsGuest: 'មើលជាភ្ញៀវ',
        },
      };
}
