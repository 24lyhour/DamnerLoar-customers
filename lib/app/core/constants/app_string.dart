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
  static const cancel = 'cancel';
  static const save = 'save';
  static const change = 'change';
  static const verify = 'verify';

  // S2 Intro
  static const introTitle1 = 'intro_title_1';
  static const introBody1 = 'intro_body_1';
  static const introTitle2 = 'intro_title_2';
  static const introBody2 = 'intro_body_2';
  static const introTitle3 = 'intro_title_3';
  static const introBody3 = 'intro_body_3';
  static const tickets = 'tickets';
  static const ticketsDesc = 'tickets_desc';
  static const hotels = 'hotels';
  static const hotelsDesc = 'hotels_desc';
  static const transportHotel = 'transport_hotel';
  static const transportHotelDesc = 'transport_hotel_desc';

  // S3 Language
  static const chooseLanguage = 'choose_language';
  static const chooseLanguageDesc = 'choose_language_desc';
  static const browseAsGuest = 'browse_as_guest';

  // S4 Login
  static const logInOrSignUp = 'log_in_or_sign_up';
  static const enterPhoneNumber = 'enter_phone_number';
  static const enterPhoneNumberDesc = 'enter_phone_number_desc';
  static const sendCode = 'send_code';
  static const orContinueWith = 'or_continue_with';
  static const agreeToTerms = 'agree_to_terms';
  static const terms = 'terms';
  static const privacyPolicy = 'privacy_policy';
  static const loginNotNeeded = 'login_not_needed';

  // S5 OTP
  static const verifyYourPhone = 'verify_your_phone';
  static const enterOtpCode = 'enter_otp_code';
  static const sentTo = 'sent_to';
  static const resendCodeIn = 'resend_code_in';
  static const resendCode = 'resend_code';
  static const tooManyAttempts = 'too_many_attempts';

  // S6 Complete Profile
  static const completeYourProfile = 'complete_your_profile';
  static const addPhoto = 'add_photo';
  static const optional = 'optional';
  static const fullName = 'full_name';
  static const fullNameHint = 'full_name_hint';
  static const email = 'email';
  static const emailHint = 'email_hint';
  static const gender = 'gender';
  static const nationality = 'nationality';
  static const tripNotifications = 'trip_notifications';
  static const tripNotificationsDesc = 'trip_notifications_desc';
  static const saveAndContinue = 'save_and_continue';
  static const male = 'male';
  static const female = 'female';
  static const other = 'other';
  static const cambodian = 'cambodian';

  // S7-S9 Home
  static const hiUser = 'hi_user';
  static const whereAreYouGoing = 'where_are_you_going';
  static const transport = 'transport';
  static const hotel = 'hotel';
  static const oneWay = 'one_way';
  static const roundTrip = 'round_trip';
  static const from = 'from';
  static const to = 'to';
  static const departure = 'departure';
  static const returnDate = 'return_date';
  static const passengers = 'passengers';
  static const adults = 'adults';
  static const searchBuses = 'search_buses';
  static const destination = 'destination';
  static const checkIn = 'check_in';
  static const checkOut = 'check_out';
  static const guestsRooms = 'guests_rooms';
  static const rooms = 'rooms';
  static const searchHotels = 'search_hotels';
  static const depart = 'depart';
  static const travellersRooms = 'travellers_rooms';
  static const searchPackages = 'search_packages';
  static const popularDestinations = 'popular_destinations';
  static const popularHotels = 'popular_hotels';
  static const popularTransport = 'popular_transport';
  static const seeAll = 'see_all';
  static const home = 'home';
  static const myBookings = 'my_bookings';
  static const saved = 'saved';
  static const profile = 'profile';
}

/// GetX translations. Khmer copy needs native-speaker review (UI/UX v3.1 next steps #5).
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      // Common
      AppString.next: 'Next',
      AppString.skip: 'Skip',
      AppString.continueText: 'Continue',
      AppString.getStarted: 'Get started',
      AppString.cancel: 'Cancel',
      AppString.save: 'Save',
      AppString.change: 'Change',
      AppString.verify: 'Verify',

      // S2 Intro
      AppString.introTitle1: 'Bus, hotel or both',
      AppString.introBody1:
          'Book bus tickets, hotels and Transport + Hotel packages across Cambodia in one app.',
      AppString.introTitle2: 'Pick your seat',
      AppString.introBody2:
          'See the seat map, choose your seat and get a QR ticket on your phone.',
      AppString.introTitle3: 'Pay your way',
      AppString.introBody3:
          'Pay with KHQR, ABA Mobile or card. Your tickets and vouchers work offline.',
      AppString.tickets: 'Tickets',
      AppString.ticketsDesc: 'Pick your seat, QR ticket',
      AppString.hotels: 'Hotels',
      AppString.hotelsDesc: 'Photos, rooms, free cancellation',
      AppString.transportHotel: 'Packages',
      AppString.transportHotelDesc: 'Book both, save up to 10%',

      // S3 Language
      AppString.chooseLanguage: 'Choose your language',
      AppString.chooseLanguageDesc: 'You can change this later in Profile.',
      AppString.browseAsGuest: 'Browse as guest',

      // S4 Login
      AppString.logInOrSignUp: 'Log in or sign up',
      AppString.enterPhoneNumber: 'Enter your phone number',
      AppString.enterPhoneNumberDesc: "We'll send a 6-digit code by SMS.",
      AppString.sendCode: 'Send code',
      AppString.orContinueWith: 'or continue with',
      AppString.agreeToTerms: 'I agree to the ',
      AppString.terms: 'Terms',
      AppString.privacyPolicy: 'Privacy Policy',
      AppString.loginNotNeeded:
          'Login is needed only at checkout. Guests can search and view all services.',

      // S5 OTP
      AppString.verifyYourPhone: 'Verify your phone',
      AppString.enterOtpCode: 'Enter the 6-digit code',
      AppString.sentTo: 'Sent to ',
      AppString.resendCodeIn: 'Resend code in ',
      AppString.resendCode: 'Resend code',
      AppString.tooManyAttempts:
          'Too many wrong codes locks login for 15 minutes.',

      // S6 Complete Profile
      AppString.completeYourProfile: 'Complete your profile',
      AppString.addPhoto: 'Add photo',
      AppString.optional: 'optional',
      AppString.fullName: 'Full name (as on ID)',
      AppString.fullNameHint: 'Enter your full name',
      AppString.email: 'Email (for receipts & vouchers)',
      AppString.emailHint: 'Enter your email',
      AppString.gender: 'Gender',
      AppString.nationality: 'Nationality',
      AppString.tripNotifications: 'Trip notifications',
      AppString.tripNotificationsDesc: 'Reminders, gate changes, refunds',
      AppString.saveAndContinue: 'Save & continue',
      AppString.male: 'Male',
      AppString.female: 'Female',
      AppString.other: 'Other',
      AppString.cambodian: 'Cambodian',

      // S7-S9 Home
      AppString.hiUser: 'Hi',
      AppString.whereAreYouGoing: 'Where are you going?',
      AppString.transport: 'Transport',
      AppString.hotel: 'Hotel',
      AppString.oneWay: 'One-way',
      AppString.roundTrip: 'Round-trip',
      AppString.from: 'From',
      AppString.to: 'To',
      AppString.departure: 'Departure',
      AppString.returnDate: 'Return',
      AppString.passengers: 'Passengers',
      AppString.adults: 'adults',
      AppString.searchBuses: 'Search Tickets',
      AppString.destination: 'Destination',
      AppString.checkIn: 'Check-in',
      AppString.checkOut: 'Check-out',
      AppString.guestsRooms: 'Guests · Rooms',
      AppString.rooms: 'room',
      AppString.searchHotels: 'Search hotels',
      AppString.depart: 'Depart',
      AppString.travellersRooms: 'Travellers · Rooms',
      AppString.searchPackages: 'Search packages · save 10%',
      AppString.popularDestinations: 'Popular destinations',
      AppString.popularHotels: 'Popular hotels',
      AppString.popularTransport: 'Popular routes',
      AppString.seeAll: 'See all',
      AppString.home: 'Home',
      AppString.myBookings: 'My Bookings',
      AppString.saved: 'Saved',
      AppString.profile: 'Profile',
    },
    'km': {
      // Common
      AppString.next: 'បន្ទាប់',
      AppString.skip: 'រំលង',
      AppString.continueText: 'បន្ត',
      AppString.getStarted: 'ចាប់ផ្តើម',
      AppString.cancel: 'បោះបង់',
      AppString.save: 'រក្សាទុក',
      AppString.change: 'ប្តូរ',
      AppString.verify: 'ផ្ទៀងផ្ទាត់',

      // S2 Intro
      AppString.introTitle1: 'ឡានក្រុង សណ្ឋាគារ ឬទាំងពីរ',
      AppString.introBody1:
          'កក់សំបុត្រឡានក្រុង សណ្ឋាគារ និងកញ្ចប់ដំណើរ នៅទូទាំងកម្ពុជា ក្នុងកម្មវិធីតែមួយ។',
      AppString.introTitle2: 'ជ្រើសរើសកៅអីរបស់អ្នក',
      AppString.introBody2:
          'មើលប្លង់កៅអី ជ្រើសរើសកៅអី ហើយទទួលបានសំបុត្រ QR នៅលើទូរស័ព្ទ។',
      AppString.introTitle3: 'បង់ប្រាក់ងាយស្រួល',
      AppString.introBody3:
          'បង់ប្រាក់តាម KHQR, ABA Mobile ឬកាត។ សំបុត្រ និងប័ណ្ណស្នាក់នៅ ប្រើបានទោះគ្មានអ៊ីនធឺណិត។',
      AppString.tickets: 'សំបុត្រ',
      AppString.ticketsDesc: 'ជ្រើសរើសកៅអី សំបុត្រ QR',
      AppString.hotels: 'សណ្ឋាគារ',
      AppString.hotelsDesc: 'រូបភាព បន្ទប់ លុបចោលឥតគិតថ្លៃ',
      AppString.transportHotel: 'កញ្ចប់ដំណើរ',
      AppString.transportHotelDesc: 'កក់ទាំងពីរ សន្សំបានដល់ 10%',

      // S3 Language
      AppString.chooseLanguage: 'ជ្រើសរើសភាសា',
      AppString.chooseLanguageDesc: 'អ្នកអាចប្តូរនៅពេលក្រោយក្នុងប្រវត្តិរូប។',
      AppString.browseAsGuest: 'មើលជាភ្ញៀវ',

      // S4 Login
      AppString.logInOrSignUp: 'ចូល ឬចុះឈ្មោះ',
      AppString.enterPhoneNumber: 'បញ្ចូលលេខទូរស័ព្ទ',
      AppString.enterPhoneNumberDesc: 'យើងនឹងផ្ញើលេខកូដ ៦ ខ្ទង់តាម SMS។',
      AppString.sendCode: 'ផ្ញើកូដ',
      AppString.orContinueWith: 'ឬបន្តជាមួយ',
      AppString.agreeToTerms: 'ខ្ញុំយល់ព្រមតាម ',
      AppString.terms: 'ល័ក្ខខ័ណ្ឌ',
      AppString.privacyPolicy: 'គោលការណ៍ឯកជនភាព',
      AppString.loginNotNeeded:
          'ការចូលត្រូវការតែពេលទូទាត់។ ភ្ញៀវអាចស្វែងរក និងមើលសេវាកម្មទាំងអស់។',

      // S5 OTP
      AppString.verifyYourPhone: 'ផ្ទៀងផ្ទាត់ទូរស័ព្ទ',
      AppString.enterOtpCode: 'បញ្ចូលលេខកូដ ៦ ខ្ទង់',
      AppString.sentTo: 'ផ្ញើទៅ ',
      AppString.resendCodeIn: 'ផ្ញើកូដម្តងទៀតក្នុង ',
      AppString.resendCode: 'ផ្ញើកូដម្តងទៀត',
      AppString.tooManyAttempts: 'បញ្ចូលកូដខុសច្រើនដងនឹងចាក់សោរការចូល ១៥ នាទី។',

      // S6 Complete Profile
      AppString.completeYourProfile: 'បំពេញប្រវត្តិរូប',
      AppString.addPhoto: 'បន្ថែមរូបថត',
      AppString.optional: 'ស្រេចចិត្ត',
      AppString.fullName: 'ឈ្មោះពេញ (ដូចអត្តសញ្ញាណប័ណ្ណ)',
      AppString.fullNameHint: 'បញ្ចូលឈ្មោះពេញរបស់អ្នក',
      AppString.email: 'អ៊ីមែល (សម្រាប់បង្កាន់ដៃ និងប័ណ្ណ)',
      AppString.emailHint: 'បញ្ចូលអ៊ីមែលរបស់អ្នក',
      AppString.gender: 'ភេទ',
      AppString.nationality: 'សញ្ជាតិ',
      AppString.tripNotifications: 'ការជូនដំណឹងការធ្វើដំណើរ',
      AppString.tripNotificationsDesc:
          'ការរំលឹក ការប្តូរច្រកចូល ការសងប្រាក់វិញ',
      AppString.saveAndContinue: 'រក្សាទុក និងបន្ត',
      AppString.male: 'ប្រុស',
      AppString.female: 'ស្រី',
      AppString.other: 'ផ្សេងទៀត',
      AppString.cambodian: 'កម្ពុជា',

      // S7-S9 Home
      AppString.hiUser: 'សួស្តី',
      AppString.whereAreYouGoing: 'តើអ្នកចង់ទៅណា?',
      AppString.transport: 'ដឹកជញ្ជូន',
      AppString.hotel: 'សណ្ឋាគារ',
      AppString.oneWay: 'ទៅមួយផ្លូវ',
      AppString.roundTrip: 'ទៅមក',
      AppString.from: 'ចេញពី',
      AppString.to: 'ទៅ',
      AppString.departure: 'ថ្ងៃចេញ',
      AppString.returnDate: 'ថ្ងៃត្រឡប់',
      AppString.passengers: 'អ្នកដំណើរ',
      AppString.adults: 'មនុស្សពេញវ័យ',
      AppString.searchBuses: 'ស្វែងរកឡានក្រុង',
      AppString.destination: 'គោលដៅ',
      AppString.checkIn: 'ចូល',
      AppString.checkOut: 'ចេញ',
      AppString.guestsRooms: 'ភ្ញៀវ · បន្ទប់',
      AppString.rooms: 'បន្ទប់',
      AppString.searchHotels: 'ស្វែងរកសណ្ឋាគារ',
      AppString.depart: 'ចេញ',
      AppString.travellersRooms: 'អ្នកដំណើរ · បន្ទប់',
      AppString.searchPackages: 'ស្វែងរកកញ្ចប់ · សន្សំ 10%',
      AppString.popularDestinations: 'គោលដៅពេញនិយម',
      AppString.popularHotels: 'សណ្ឋាគារពេញនិយម',
      AppString.popularTransport: 'ផ្លូវពេញនិយម',
      AppString.seeAll: 'មើលទាំងអស់',
      AppString.home: 'ទំព័រដើម',
      AppString.myBookings: 'ការកក់របស់ខ្ញុំ',
      AppString.saved: 'បានរក្សាទុក',
      AppString.profile: 'ប្រវត្តិរូប',
    },
  };
}
