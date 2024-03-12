import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_ar.dart';
import 'app_localizations_am.dart';
import 'app_localizations_en.dart';
import 'app_localizations_or.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_rw.dart';
import 'app_localizations_es.dart';
import 'app_localizations_lg.dart';
import 'app_localizations_rn.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_so.dart';
import 'app_localizations_ti.dart';
import 'app_localizations_tr.dart';
// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
    Locale('or'),
    Locale('sw'),
    Locale('fr'),
    Locale('ar'),
    Locale('rw'),
    Locale('es'),
    Locale('lg'),
    Locale('rn'),
    Locale('ru'),
    Locale('so'),
    Locale('ti'),
    Locale('tr'),
  ];

  /// No description provided for @homeText.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeText;

  /// No description provided for @priceCatagoryText.
  ///
  /// In en, this message translates to:
  /// **'Price category'**
  String get priceCatagoryText;

  /// No description provided for @reviewText.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewText;

  /// No description provided for @ethiopianCurrencyText.
  ///
  /// In en, this message translates to:
  /// **'Birr'**
  String get ethiopianCurrencyText;

  /// No description provided for @updateFiltreText.
  ///
  /// In en, this message translates to:
  /// **'UPDATE FILTER'**
  String get updateFiltreText;

  /// No description provided for @discoverText.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverText;

  /// No description provided for @searchText.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchText;

  /// No description provided for @profileText.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileText;

  /// No description provided for @langText.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get langText;

  /// No description provided for @englishText.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishText;

  /// No description provided for @amhText.
  ///
  /// In en, this message translates to:
  /// **'Amharic'**
  String get amhText;

  /// No description provided for @oroText.
  ///
  /// In en, this message translates to:
  /// **'Afaan Oromoo'**
  String get oroText;

  /// No description provided for @swText.
  ///
  /// In en, this message translates to:
  /// **'swahili'**
  String get swText;

  /// No description provided for @frText.
  ///
  /// In en, this message translates to:
  /// ** French'**
  String get frText;

  /// No description provided for @rwText.
  ///
  /// In en, this message translates to:
  /// **Kinyarwanda**
  String get rwText;

  /// No description provided for @flow1Text.
  ///
  /// In en, this message translates to:
  /// **'Choose restaurant'**
  ///
  String get flow1Text;

  /// No description provided for @flow1Description.
  ///
  /// In en, this message translates to:
  /// **'Find restaurants based on distance, cuisine, and quality'**
  String get flow1Description;

  /// No description provided for @flow2Text.
  ///
  /// In en, this message translates to:
  /// **'Explore the menu'**
  String get flow2Text;

  /// No description provided for @flow2Description.
  ///
  /// In en, this message translates to:
  /// **'If you know which restaurant you want to go'**
  String get flow2Description;

  /// No description provided for @discoverPageText.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do today?'**
  String get discoverPageText;

  /// No description provided for @popularText.
  ///
  /// In en, this message translates to:
  /// **'Popular items'**
  String get popularText;

  /// No description provided for @recommendedText.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommendedText;

  /// No description provided for @retryText.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryText;

  /// No description provided for @startText.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get\nstarted'**
  String get startText;

  /// No description provided for @skipText.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipText;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orText;

  /// No description provided for @googleText.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get googleText;

  /// No description provided for @facebookText.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get facebookText;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @otpText.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get otpText;

  /// No description provided for @verifyOtpText.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtpText;

  /// No description provided for @otpSentText.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully!'**
  String get otpSentText;

  /// No description provided for @otpSentToText.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to'**
  String get otpSentToText;

  /// No description provided for @phoneOtpNotSentText.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send OTP to your Phone'**
  String get phoneOtpNotSentText;

  /// No description provided for @emailOtpNotSentText.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send OTP to your email'**
  String get emailOtpNotSentText;

  /// No description provided for @notOtpSentText.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get notOtpSentText;

  /// No description provided for @resendText.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendText;

  /// No description provided for @validOtpText.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid OTP'**
  String get validOtpText;

  /// No description provided for @confirmText.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmText;

  /// No description provided for @searchRestaurantText.
  ///
  /// In en, this message translates to:
  /// **'Search restaurants'**
  String get searchRestaurantText;

  /// No description provided for @searchResultText.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResultText;

  /// No description provided for @searchStartText.
  ///
  /// In en, this message translates to:
  /// **'Start searching'**
  String get searchStartText;

  /// No description provided for @searchDescText.
  ///
  /// In en, this message translates to:
  /// **'Search and find your favorite restaurants'**
  String get searchDescText;

  /// No description provided for @fastingText.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get fastingText;

  /// No description provided for @resultText.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultText;

  /// No description provided for @filterText.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get filterText;

  /// No description provided for @maxPriceText.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get maxPriceText;

  /// No description provided for @ratingText.
  ///
  /// In en, this message translates to:
  /// **'Star rating'**
  String get ratingText;

  /// No description provided for @finishText.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishText;

  /// No description provided for @addReviewText.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get addReviewText;

  /// No description provided for @popularReviewText.
  ///
  /// In en, this message translates to:
  /// **'Popular reviews'**
  String get popularReviewText;

  /// No description provided for @firstReviewText.
  ///
  /// In en, this message translates to:
  /// **'Be our first reviewer!'**
  String get firstReviewText;

  /// No description provided for @ingredientText.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientText;

  /// No description provided for @loginRequiredText.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get loginRequiredText;

  /// No description provided for @loginNeededText.
  ///
  /// In en, this message translates to:
  /// **'You need to log in to perform this action'**
  String get loginNeededText;

  /// No description provided for @cancelText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelText;

  /// No description provided for @loginText.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginText;

  /// No description provided for @uploadText.
  ///
  /// In en, this message translates to:
  /// **'Upload images'**
  String get uploadText;

  /// No description provided for @clickUploadText.
  ///
  /// In en, this message translates to:
  /// **'Upload images or videos'**
  String get clickUploadText;

  /// No description provided for @submittingText.
  ///
  /// In en, this message translates to:
  /// **'Submitting'**
  String get submittingText;

  /// No description provided for @submitText.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitText;

  /// No description provided for @giveRatingText.
  ///
  /// In en, this message translates to:
  /// **'Give a rating'**
  String get giveRatingText;

  /// No description provided for @giveCommentText.
  ///
  /// In en, this message translates to:
  /// **'Please take a moment to rate your experience with this item'**
  String get giveCommentText;

  /// No description provided for @categoriesText.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesText;

  /// No description provided for @restText.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restText;

  /// No description provided for @itemText.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get itemText;

  /// No description provided for @userReviewText.
  ///
  /// In en, this message translates to:
  /// **'User reviews'**
  String get userReviewText;

  /// No description provided for @favText.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favText;

  /// No description provided for @filtersText.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filtersText;

  /// No description provided for @noAccText.
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue'**
  String get noAccText;

  /// No description provided for @clickAccText.
  ///
  /// In en, this message translates to:
  /// **'Click the \'Create an account\' button to get started'**
  String get clickAccText;

  /// No description provided for @accText.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get accText;

  /// No description provided for @logoutText.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutText;

  /// No description provided for @deleteAccountText.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountText;

  /// No description provided for @confirmDeleteAccountText.
  ///
  /// In en, this message translates to:
  /// **'Your account Will be deleted'**
  String get confirmDeleteAccountText;

  /// No description provided for @callText.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callText;

  /// No description provided for @seeText.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeText;

  /// No description provided for @restaurantDetailsText.
  ///
  /// In en, this message translates to:
  /// **'Getting restaurant details'**
  String get restaurantDetailsText;

  /// No description provided for @itemDetailsText.
  ///
  /// In en, this message translates to:
  /// **'Getting item details'**
  String get itemDetailsText;

  /// No description provided for @openText.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openText;

  /// No description provided for @permanentlyClosedText.
  ///
  /// In en, this message translates to:
  /// **'Permanently Closed'**
  String get permanentlyClosedText;

  /// No description provided for @closedText.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedText;

  /// No description provided for @opensAtText.
  ///
  /// In en, this message translates to:
  /// **'Opens at'**
  String get opensAtText;

  /// No description provided for @closesAtText.
  ///
  /// In en, this message translates to:
  /// **'Closes at'**
  String get closesAtText;

  /// No description provided for @closeText.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeText;

  /// No description provided for @noPopularText.
  ///
  /// In en, this message translates to:
  /// **'No popular items found'**
  String get noPopularText;

  /// No description provided for @errorPopularText.
  ///
  /// In en, this message translates to:
  /// **'Error loading popular items'**
  String get errorPopularText;

  /// No description provided for @errorReviewText.
  ///
  /// In en, this message translates to:
  /// **'Could not load reviews'**
  String get errorReviewText;

  /// No description provided for @unknownErrorText.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownErrorText;

  /// No description provided for @tryAgainText.
  ///
  /// In en, this message translates to:
  /// **'Unknown error. Please try again'**
  String get tryAgainText;

  /// No description provided for @noRecommendationsText.
  ///
  /// In en, this message translates to:
  /// **'No recommendations found'**
  String get noRecommendationsText;

  /// No description provided for @errRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Could not get recommendation'**
  String get errRecommendations;

  /// No description provided for @locationPermissionText.
  ///
  /// In en, this message translates to:
  /// **'Allow location permission to continue'**
  String get locationPermissionText;

  /// No description provided for @getLocationText.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get getLocationText;

  /// No description provided for @noResultText.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultText;

  /// No description provided for @searchNoText.
  ///
  /// In en, this message translates to:
  /// **'Sorry, we couldn\'t find any results matching your search'**
  String get searchNoText;

  /// No description provided for @loadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading results...'**
  String get loadingText;

  /// No description provided for @selectLocationText.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get selectLocationText;

  /// No description provided for @searchLocationText.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get searchLocationText;

  /// No description provided for @couldNtGetCoordinatesText.
  ///
  /// In en, this message translates to:
  /// **'Could not get coordinates'**
  String get couldNtGetCoordinatesText;

  /// No description provided for @networkText.
  ///
  /// In en, this message translates to:
  /// **'Connect to a network and try again'**
  String get networkText;

  /// No description provided for @noInternetText.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetText;

  /// No description provided for @connText.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get connText;

  /// No description provided for @failedMapText.
  ///
  /// In en, this message translates to:
  /// **'Failed to load map'**
  String get failedMapText;

  /// No description provided for @loadingOnlyText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingOnlyText;

  /// No description provided for @mapLoadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading your map...'**
  String get mapLoadingText;

  /// No description provided for @hereText.
  ///
  /// In en, this message translates to:
  /// **'You are here'**
  String get hereText;

  /// No description provided for @locationErrorText.
  ///
  /// In en, this message translates to:
  /// **'Unable to get user location'**
  String get locationErrorText;

  /// No description provided for @failedLocationText.
  ///
  /// In en, this message translates to:
  /// **'Unable to load user location'**
  String get failedLocationText;

  /// No description provided for @walkingDistanceText.
  ///
  /// In en, this message translates to:
  /// **'Minutes of walking distance'**
  String get walkingDistanceText;

  /// No description provided for @inText.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get inText;

  /// No description provided for @menuText.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get menuText;

  /// No description provided for @openingHrText.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHrText;

  /// No description provided for @visitText.
  ///
  /// In en, this message translates to:
  /// **'Visit restaurant'**
  String get visitText;

  /// No description provided for @revText.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get revText;

  /// No description provided for @maxDistText.
  ///
  /// In en, this message translates to:
  /// **'Maximum distance'**
  String get maxDistText;

  /// No description provided for @locationMaxDistText.
  ///
  /// In en, this message translates to:
  /// **'Maximum distance from selected location.'**
  String get locationMaxDistText;

  /// No description provided for @walkingDistText.
  ///
  /// In en, this message translates to:
  /// **'walking distance'**
  String get walkingDistText;

  /// No description provided for @drivingDistText.
  ///
  /// In en, this message translates to:
  /// **'driving distance'**
  String get drivingDistText;

  /// No description provided for @noRevText.
  ///
  /// In en, this message translates to:
  /// **'No reviews'**
  String get noRevText;

  /// No description provided for @backText.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backText;

  /// No description provided for @userReviewsText.
  ///
  /// In en, this message translates to:
  /// **'User reviews'**
  String get userReviewsText;

  /// No description provided for @basedOnText.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOnText;

  /// No description provided for @searchItemText.
  ///
  /// In en, this message translates to:
  /// **'Search item'**
  String get searchItemText;

  /// No description provided for @loadingProfileText.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get loadingProfileText;

  /// No description provided for @loadImageError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load\n image'**
  String get loadImageError;

  /// No description provided for @incentiveText.
  ///
  /// In en, this message translates to:
  /// **'Total incentivized'**
  String get incentiveText;

  /// No description provided for @pendingIncentiveText.
  ///
  /// In en, this message translates to:
  /// **'Pending incentive'**
  String get pendingIncentiveText;

  /// No description provided for @profileFailText.
  ///
  /// In en, this message translates to:
  /// **'Profile loading failed'**
  String get profileFailText;

  /// No description provided for @profileNoReviewsText.
  ///
  /// In en, this message translates to:
  /// **'No reviews found'**
  String get profileNoReviewsText;

  /// No description provided for @profileNoReviewsText1.
  ///
  /// In en, this message translates to:
  /// **'You have no reviews yet'**
  String get profileNoReviewsText1;

  /// No description provided for @profileNoDraftReviewsText.
  ///
  /// In en, this message translates to:
  /// **'No draft reviews found'**
  String get profileNoDraftReviewsText;

  /// No description provided for @profileNoDraftReviewsText1.
  ///
  /// In en, this message translates to:
  /// **'You have no draft reviews yet'**
  String get profileNoDraftReviewsText1;

  /// No description provided for @noFavText.
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get noFavText;

  /// No description provided for @noFavText1.
  ///
  /// In en, this message translates to:
  /// **'You have no favorite items'**
  String get noFavText1;

  /// No description provided for @othersnoFavText.
  ///
  /// In en, this message translates to:
  /// **'The user have no favorite items'**
  String get othersnoFavText;

  /// No description provided for @settingsText.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsText;

  /// No description provided for @termsText.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsText;

  /// No description provided for @privacyText.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyText;

  /// No description provided for @editProfileText.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get editProfileText;

  /// No description provided for @uploadPPtext.
  ///
  /// In en, this message translates to:
  /// **'Upload your photo '**
  String get uploadPPtext;

  /// No description provided for @optionalText.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalText;

  /// No description provided for @proText.
  ///
  /// In en, this message translates to:
  /// **'Will be displayed to others as your profile image'**
  String get proText;

  /// No description provided for @firstText.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstText;

  /// No description provided for @userNameErrorText.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get userNameErrorText;

  /// No description provided for @nameErrorText.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameErrorText;

  /// No description provided for @shortNameText.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters long'**
  String get shortNameText;

  /// No description provided for @emailText.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailText;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailError;

  /// No description provided for @dateOfBirthText.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthText;

  /// No description provided for @profileUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdatedText;

  /// No description provided for @lastText.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastText;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile update failed'**
  String get profileUpdateFailed;

  /// No description provided for @reportText.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportText;

  /// No description provided for @editText.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editText;

  /// No description provided for @deleteText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteText;

  /// No description provided for @noCommentText.
  ///
  /// In en, this message translates to:
  /// **'No comment'**
  String get noCommentText;

  /// No description provided for @voteErrorText.
  ///
  /// In en, this message translates to:
  /// **'Unable to process vote. Try again'**
  String get voteErrorText;

  /// No description provided for @mostPopularText.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get mostPopularText;

  /// No description provided for @ratedText.
  ///
  /// In en, this message translates to:
  /// **'Highest rated'**
  String get ratedText;

  /// No description provided for @priceText.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceText;

  /// No description provided for @distText.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distText;

  /// No description provided for @termsAndConditionsText.
  ///
  /// In en, this message translates to:
  /// **'See RateEat\'s terms and conditions'**
  String get termsAndConditionsText;

  /// No description provided for @seePrivacyPolicyText.
  ///
  /// In en, this message translates to:
  /// **'See RateEat\'s privacy policy'**
  String get seePrivacyPolicyText;

  /// No description provided for @logoutWantText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get logoutWantText;

  /// No description provided for @notificationText.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationText;

  /// No description provided for @pushText.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushText;

  /// No description provided for @dailyText.
  ///
  /// In en, this message translates to:
  /// **'For daily updates'**
  String get dailyText;

  /// No description provided for @smsText.
  ///
  /// In en, this message translates to:
  /// **'SMS notifications'**
  String get smsText;

  /// No description provided for @privacyTitleText.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitleText;

  /// No description provided for @accConnText.
  ///
  /// In en, this message translates to:
  /// **'Account connections'**
  String get accConnText;

  /// No description provided for @checkAccText.
  ///
  /// In en, this message translates to:
  /// **'Check account connectivity'**
  String get checkAccText;

  /// No description provided for @generalText.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalText;

  /// No description provided for @yesterdayText.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayText;

  /// No description provided for @todayText.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayText;

  /// No description provided for @mentionsText.
  ///
  /// In en, this message translates to:
  /// **'Mentions'**
  String get mentionsText;

  /// No description provided for @couponsText.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get couponsText;

  /// No description provided for @notificationsErrorText.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications'**
  String get notificationsErrorText;

  /// No description provided for @favoriteItemCommentMessage.
  ///
  /// In en, this message translates to:
  /// **'Commented on your favorite item'**
  String get favoriteItemCommentMessage;

  /// No description provided for @reactionMessageText.
  ///
  /// In en, this message translates to:
  /// **'You have a new reaction to your review'**
  String get reactionMessageText;

  /// No description provided for @restaurantReviewUpVoteReactionText.
  ///
  /// In en, this message translates to:
  /// **'upvoted your restaurant review'**
  String get restaurantReviewUpVoteReactionText;

  /// No description provided for @itemReviewUpVoteReactionText.
  ///
  /// In en, this message translates to:
  /// **'upvoted your item review'**
  String get itemReviewUpVoteReactionText;

  /// No description provided for @reactionMessageSubTitleText.
  ///
  /// In en, this message translates to:
  /// **'put a reaction on your review'**
  String get reactionMessageSubTitleText;

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **'Hour ago'**
  String get hourAgo;

  /// No description provided for @minuteAgo.
  ///
  /// In en, this message translates to:
  /// **'Minute ago'**
  String get minuteAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Hours ago'**
  String get hoursAgo;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Minutes ago'**
  String get minutesAgo;

  /// No description provided for @vocativeText.
  ///
  /// In en, this message translates to:
  /// **''**
  String get vocativeText;

  /// No description provided for @nowText.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get nowText;

  /// No description provided for @uploadVideoText.
  ///
  /// In en, this message translates to:
  /// **'Upload video'**
  String get uploadVideoText;

  /// No description provided for @giveRateText.
  ///
  /// In en, this message translates to:
  /// **'Give a rating'**
  String get giveRateText;

  /// No description provided for @gaveRateDesc.
  ///
  /// In en, this message translates to:
  /// **'Please take a moment to rate this item'**
  String get gaveRateDesc;

  /// No description provided for @hateAndHarassmentText.
  ///
  /// In en, this message translates to:
  /// **'Hate and harassment'**
  String get hateAndHarassmentText;

  /// No description provided for @nudityAndSexualContentText.
  ///
  /// In en, this message translates to:
  /// **'Nudity and sexual content'**
  String get nudityAndSexualContentText;

  /// No description provided for @shockingAndGraphicContentText.
  ///
  /// In en, this message translates to:
  /// **'Shocking and graphic content'**
  String get shockingAndGraphicContentText;

  /// No description provided for @misInformationText.
  ///
  /// In en, this message translates to:
  /// **'Misinformation'**
  String get misInformationText;

  /// No description provided for @deceptiveBehaviorAndSpamText.
  ///
  /// In en, this message translates to:
  /// **'Deceptive behavior and spam'**
  String get deceptiveBehaviorAndSpamText;

  /// No description provided for @fraudsAndScamsText.
  ///
  /// In en, this message translates to:
  /// **'Frauds and scams'**
  String get fraudsAndScamsText;

  /// No description provided for @sharingPersonalInformationText.
  ///
  /// In en, this message translates to:
  /// **'Sharing personal information'**
  String get sharingPersonalInformationText;

  /// No description provided for @counterFeitsAndIntellectualPropertyText.
  ///
  /// In en, this message translates to:
  /// **'Counterfeits and intellectual property'**
  String get counterFeitsAndIntellectualPropertyText;

  /// No description provided for @otherText.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherText;

  /// No description provided for @selectReasonText.
  ///
  /// In en, this message translates to:
  /// **'Select a reason'**
  String get selectReasonText;

  /// No description provided for @requiredText.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredText;

  /// No description provided for @requiredWarningText.
  ///
  /// In en, this message translates to:
  /// **'The reason should be at least three letters'**
  String get requiredWarningText;

  /// No description provided for @yourReasonText.
  ///
  /// In en, this message translates to:
  /// **'Your reason...'**
  String get yourReasonText;

  /// No description provided for @yourLocationText.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocationText;

  /// No description provided for @reviewAcceptanceText.
  ///
  /// In en, this message translates to:
  /// **'Thanks, we\'ve received your report, and we\'ll process it.'**
  String get reviewAcceptanceText;

  /// No description provided for @reportFailureText.
  ///
  /// In en, this message translates to:
  /// **'Unable to report the review.'**
  String get reportFailureText;

  /// No description provided for @canTGetReviewText.
  ///
  /// In en, this message translates to:
  /// **'Unable to get the review'**
  String get canTGetReviewText;

  /// No description provided for @canTGetItemDetailText.
  ///
  /// In en, this message translates to:
  /// **'Unable to get item detail'**
  String get canTGetItemDetailText;

  /// No description provided for @pageNotFoundText.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFoundText;

  /// No description provided for @locationPermissionTitleText.
  ///
  /// In en, this message translates to:
  /// **'Location permission required'**
  String get locationPermissionTitleText;

  /// No description provided for @locationPermissionContentText.
  ///
  /// In en, this message translates to:
  /// **'This app requires location permission'**
  String get locationPermissionContentText;

  /// No description provided for @openLocationSettingText.
  ///
  /// In en, this message translates to:
  /// **'Open location settings'**
  String get openLocationSettingText;

  /// No description provided for @createProfileText.
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get createProfileText;

  /// No description provided for @uploadPhotoText.
  ///
  /// In en, this message translates to:
  /// **'Upload your photo '**
  String get uploadPhotoText;

  /// No description provided for @createProfileMessageText.
  ///
  /// In en, this message translates to:
  /// **'Will be displayed to others as your profile image.'**
  String get createProfileMessageText;

  /// No description provided for @userNameText.
  ///
  /// In en, this message translates to:
  /// **'user name'**
  String get userNameText;

  /// No description provided for @firstNameText.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameText;

  /// No description provided for @emptyNameText.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get emptyNameText;

  /// No description provided for @invalidNameText.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters long'**
  String get invalidNameText;

  /// No description provided for @invalidUserNameText.
  ///
  /// In en, this message translates to:
  /// **'username must be at least 4 characters long'**
  String get invalidUserNameText;

  /// No description provided for @lastNameText.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameText;

  /// No description provided for @invalidEmailText.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmailText;

  /// No description provided for @genderText.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderText;

  /// No description provided for @signUpText.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpText;

  /// No description provided for @maleGenderText.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleGenderText;

  /// No description provided for @femaleGenderText.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleGenderText;

  /// No description provided for @cameraText.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraText;

  /// No description provided for @galleryText.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryText;

  /// No description provided for @starsText.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get starsText;

  /// No description provided for @starsAndUpText.
  ///
  /// In en, this message translates to:
  /// **'Stars & Up'**
  String get starsAndUpText;

  /// No description provided for @filterItemsText.
  ///
  /// In en, this message translates to:
  /// **'Filter items'**
  String get filterItemsText;

  /// No description provided for @moreText.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreText;

  /// No description provided for @lessText.
  ///
  /// In en, this message translates to:
  /// **'Lore'**
  String get lessText;

  /// No description provided for @visitPlaceText.
  ///
  /// In en, this message translates to:
  /// **'Visit place'**
  String get visitPlaceText;

  /// No description provided for @selectedTagsText.
  ///
  /// In en, this message translates to:
  /// **'Selected tags'**
  String get selectedTagsText;

  /// No description provided for @selectTagsText.
  ///
  /// In en, this message translates to:
  /// **'Select tags'**
  String get selectTagsText;

  /// No description provided for @addTagsText.
  ///
  /// In en, this message translates to:
  /// **'Add tags'**
  String get addTagsText;

  /// No description provided for @tagsText.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsText;

  /// No description provided for @etbText.
  ///
  /// In en, this message translates to:
  /// **'ETB'**
  String get etbText;

  /// No description provided for @tagNotAvailableText.
  ///
  /// In en, this message translates to:
  /// **'Tag not available'**
  String get tagNotAvailableText;

  /// No description provided for @ratingsText.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratingsText;

  /// No description provided for @changeLocationText.
  ///
  /// In en, this message translates to:
  /// **'Change location'**
  String get changeLocationText;

  /// No description provided for @changeLanguageText.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguageText;

  /// No description provided for @searchForAPlaceText.
  ///
  /// In en, this message translates to:
  /// **'Search for a place'**
  String get searchForAPlaceText;

  /// No description provided for @loadingMapText.
  ///
  /// In en, this message translates to:
  /// **'Loading map...'**
  String get loadingMapText;

  /// No description provided for @loadingMapFailedText.
  ///
  /// In en, this message translates to:
  /// **'Loading map failed'**
  String get loadingMapFailedText;

  /// No description provided for @errorLoadingPopularItemsText.
  ///
  /// In en, this message translates to:
  /// **'Error loading popular items'**
  String get errorLoadingPopularItemsText;

  /// No description provided for @noTopRatedText.
  ///
  /// In en, this message translates to:
  /// **'No top rated found'**
  String get noTopRatedText;

  /// No description provided for @noCategoriesText.
  ///
  /// In en, this message translates to:
  /// **'Unable to get categories'**
  String get noCategoriesText;

  /// No description provided for @noRecommendationsFoundText.
  ///
  /// In en, this message translates to:
  /// **'No recommendation found'**
  String get noRecommendationsFoundText;

  /// No description provided for @westernText.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get westernText;

  /// No description provided for @middleEastText.
  ///
  /// In en, this message translates to:
  /// **'Middle Eastern'**
  String get middleEastText;

  /// No description provided for @habeshanText.
  ///
  /// In en, this message translates to:
  /// **'Habeshan'**
  String get habeshanText;

  /// No description provided for @europeanText.
  ///
  /// In en, this message translates to:
  /// **'European'**
  String get europeanText;

  /// No description provided for @mediterraneanText.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean'**
  String get mediterraneanText;

  /// No description provided for @asianText.
  ///
  /// In en, this message translates to:
  /// **'Asian'**
  String get asianText;

  /// No description provided for @averagePriceText.
  ///
  /// In en, this message translates to:
  /// **'Average price'**
  String get averagePriceText;

  /// No description provided for @selectCategoriesText.
  ///
  /// In en, this message translates to:
  /// **'Select categories'**
  String get selectCategoriesText;

  /// No description provided for @doYouKnowText.
  ///
  /// In en, this message translates to:
  /// **'Do you know what you want to eat?'**
  String get doYouKnowText;

  /// No description provided for @searchFoodTypeText.
  ///
  /// In en, this message translates to:
  /// **'Search food type'**
  String get searchFoodTypeText;

  /// No description provided for @noResultDescriptionText.
  ///
  /// In en, this message translates to:
  /// **'Sorry, we couldn\'t find any results matching your search.'**
  String get noResultDescriptionText;

  /// No description provided for @startSearchingText.
  ///
  /// In en, this message translates to:
  /// **'Start searching...'**
  String get startSearchingText;

  /// No description provided for @searchFavoriteRestaurantsText.
  ///
  /// In en, this message translates to:
  /// **'Search and find your favorite restaurants.'**
  String get searchFavoriteRestaurantsText;

  /// No description provided for @cantLoadVideoText.
  ///
  /// In en, this message translates to:
  /// **'Can\'t load video. Please try again.'**
  String get cantLoadVideoText;

  /// No description provided for @descriptionText.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionText;

  /// No description provided for @clearAllText.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllText;

  /// No description provided for @clearHistoryText.
  ///
  /// In en, this message translates to:
  /// **'Clear history?'**
  String get clearHistoryText;

  /// No description provided for @yesText.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesText;

  /// No description provided for @noText.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noText;

  /// No description provided for @popularSearchesText.
  ///
  /// In en, this message translates to:
  /// **'Popular searches'**
  String get popularSearchesText;

  /// No description provided for @searchPlacesText.
  ///
  /// In en, this message translates to:
  /// **'Search places'**
  String get searchPlacesText;

  /// No description provided for @discoverRestaurantText.
  ///
  /// In en, this message translates to:
  /// **'Discover restaurant'**
  String get discoverRestaurantText;

  /// No description provided for @minutesText.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesText;

  /// No description provided for @noImagesRestaurantText.
  ///
  /// In en, this message translates to:
  /// **'No images of restaurant'**
  String get noImagesRestaurantText;

  /// No description provided for @errorOccurredText.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get errorOccurredText;

  /// No description provided for @noReviewsText.
  ///
  /// In en, this message translates to:
  /// **'No reviews'**
  String get noReviewsText;

  /// No description provided for @refreshText.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshText;

  /// No description provided for @noNewNotificationsText.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have new notifications'**
  String get noNewNotificationsText;

  /// No description provided for @nAText.
  ///
  /// In en, this message translates to:
  /// **'NA'**
  String get nAText;

  /// No description provided for @newReviewText.
  ///
  /// In en, this message translates to:
  /// **'New review'**
  String get newReviewText;

  /// No description provided for @yourReviewText.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get yourReviewText;

  /// No description provided for @notRatedText.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get notRatedText;

  /// No description provided for @reviewsText.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsText;

  /// No description provided for @addCommentText.
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get addCommentText;

  /// No description provided for @uploadFilesText.
  ///
  /// In en, this message translates to:
  /// **'Upload files'**
  String get uploadFilesText;

  /// No description provided for @selectedImagesText.
  ///
  /// In en, this message translates to:
  /// **'Selected images'**
  String get selectedImagesText;

  /// No description provided for @selectedVideosText.
  ///
  /// In en, this message translates to:
  /// **'Selected videos'**
  String get selectedVideosText;

  /// No description provided for @restaurantText.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurantText;

  /// No description provided for @previouslyUploadedImagesText.
  ///
  /// In en, this message translates to:
  /// **'Previously uploaded images'**
  String get previouslyUploadedImagesText;

  /// No description provided for @previouslyUploadedVideosText.
  ///
  /// In en, this message translates to:
  /// **'Previously uploaded videos'**
  String get previouslyUploadedVideosText;

  /// No description provided for @updateText.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateText;

  /// No description provided for @updatingText.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get updatingText;

  /// No description provided for @nothingSelectedText.
  ///
  /// In en, this message translates to:
  /// **'Nothing is selected'**
  String get nothingSelectedText;

  /// No description provided for @editCommentText.
  ///
  /// In en, this message translates to:
  /// **'Edit comment'**
  String get editCommentText;

  /// No description provided for @confirmationText.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmationText;

  /// No description provided for @deleteConfirmationText.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get deleteConfirmationText;

  /// No description provided for @kiloMeterText.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kiloMeterText;

  /// No description provided for @thatsAllText.
  ///
  /// In en, this message translates to:
  /// **'That\'s all'**
  String get thatsAllText;

  /// No description provided for @noMoreRestaurantsText.
  ///
  /// In en, this message translates to:
  /// **'That\'s all, no more restaurants'**
  String get noMoreRestaurantsText;

  /// No description provided for @noMoreItemsText.
  ///
  /// In en, this message translates to:
  /// **'That\'s all, no more items'**
  String get noMoreItemsText;

  /// No description provided for @noMoreReviewsText.
  ///
  /// In en, this message translates to:
  /// **'That\'s all, no more reviews'**
  String get noMoreReviewsText;

  /// No description provided for @noMoreDraftReviewsText.
  ///
  /// In en, this message translates to:
  /// **'That\'s all, no more draft reviews'**
  String get noMoreDraftReviewsText;

  /// No description provided for @filtersChangeText.
  ///
  /// In en, this message translates to:
  /// **'Please change filter details to view results'**
  String get filtersChangeText;

  /// No description provided for @loadingSettingsText.
  ///
  /// In en, this message translates to:
  /// **'Loading settings'**
  String get loadingSettingsText;

  /// No description provided for @errorLoadingMoreRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Error loading more recommendations'**
  String get errorLoadingMoreRecommendations;

  /// No description provided for @recentSearchesText.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearchesText;

  /// No description provided for @welcomeMessageText.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeMessageText;

  /// No description provided for @welcomeBackMessageText.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBackMessageText;

  /// No description provided for @quickReviewText.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get quickReviewText;

  /// No description provided for @findYourFavoriteFoodText.
  ///
  /// In en, this message translates to:
  /// **'Find your favorite food'**
  String get findYourFavoriteFoodText;

  /// No description provided for @restaurantsText.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurantsText;

  /// No description provided for @itemsText.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsText;

  /// No description provided for @locateYourNextMealText.
  ///
  /// In en, this message translates to:
  /// **'Locate your next meal'**
  String get locateYourNextMealText;

  /// No description provided for @favSuccessText.
  ///
  /// In en, this message translates to:
  /// **'Successfully added to favorites'**
  String get favSuccessText;

  /// No description provided for @favSuccessRemoveText.
  ///
  /// In en, this message translates to:
  /// **'Successfully removed from favorite'**
  String get favSuccessRemoveText;

  /// No description provided for @itemReviewSuccessText.
  ///
  /// In en, this message translates to:
  /// **'Item review added successfully'**
  String get itemReviewSuccessText;

  /// No description provided for @restaurantReviewSuccessText.
  ///
  /// In en, this message translates to:
  /// **'Restaurant review added successfully'**
  String get restaurantReviewSuccessText;

  /// No description provided for @leadText.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leadText;

  /// No description provided for @notificationErrorText.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications'**
  String get notificationErrorText;

  /// No description provided for @priceUpdateText.
  ///
  /// In en, this message translates to:
  /// **'Price update'**
  String get priceUpdateText;

  /// No description provided for @uploadMenuText.
  ///
  /// In en, this message translates to:
  /// **'Suggest a menu update'**
  String get uploadMenuText;

  /// No description provided for @expText.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get expText;

  /// No description provided for @giveFeedbackText.
  ///
  /// In en, this message translates to:
  /// **'Give us feedback'**
  String get giveFeedbackText;

  /// No description provided for @expDetailText.
  ///
  /// In en, this message translates to:
  /// **'Please share your experience with the app'**
  String get expDetailText;

  /// No description provided for @phoneNoText.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNoText;

  /// No description provided for @countryText.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get countryText;

  /// No description provided for @phoneNoreqText.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNoreqText;

  /// No description provided for @phoneNoInvalidText.
  ///
  /// In en, this message translates to:
  /// **'Phone number is invalid'**
  String get phoneNoInvalidText;

  /// No description provided for @phoneNoStartWithText.
  ///
  /// In en, this message translates to:
  /// **'Phone number must start with 9'**
  String get phoneNoStartWithText;

  /// No description provided for @rankingText.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rankingText;

  /// No description provided for @pointsText.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsText;

  /// No description provided for @noRateText.
  ///
  /// In en, this message translates to:
  /// **'Unrated'**
  String get noRateText;

  /// No description provided for @draftText.
  ///
  /// In en, this message translates to:
  /// **'Draft reviews'**
  String get draftText;

  /// No description provided for @biteCoinText.
  ///
  /// In en, this message translates to:
  /// **'Bite coins'**
  String get biteCoinText;

  /// No description provided for @singleMenuText.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get singleMenuText;

  /// No description provided for @singleRestaurantText.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get singleRestaurantText;

  /// No description provided for @afterText.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get afterText;

  /// No description provided for @minText.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minText;

  /// No description provided for @selectedFilesText.
  ///
  /// In en, this message translates to:
  /// **'Selected files'**
  String get selectedFilesText;

  /// No description provided for @imagesText.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get imagesText;

  /// No description provided for @videosText.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get videosText;

  /// No description provided for @imagesNotAllowedText.
  ///
  /// In en, this message translates to:
  /// **'Only 3 images are allowed to be uploaded'**
  String get imagesNotAllowedText;

  /// No description provided for @videosNotAllowedText.
  ///
  /// In en, this message translates to:
  /// **'Only 3 videos are allowed to be uploaded'**
  String get videosNotAllowedText;

  /// No description provided for @removePhotosText.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhotosText;

  /// No description provided for @removeVideosText.
  ///
  /// In en, this message translates to:
  /// **'Remove video'**
  String get removeVideosText;

  /// No description provided for @ingredientUnavailableText.
  ///
  /// In en, this message translates to:
  /// **'Ingredient unavailable'**
  String get ingredientUnavailableText;

  /// No description provided for @unableToLoadItemsText.
  ///
  /// In en, this message translates to:
  /// **'Unable to load items'**
  String get unableToLoadItemsText;

  /// No description provided for @searchedItemNotFoundText.
  ///
  /// In en, this message translates to:
  /// **'The searched food item is not registered!!!'**
  String get searchedItemNotFoundText;

  /// No description provided for @loadingResultsFailedText.
  ///
  /// In en, this message translates to:
  /// **'Unable to load results'**
  String get loadingResultsFailedText;

  /// No description provided for @tryAgainOnlyText.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get tryAgainOnlyText;

  /// No description provided for @unableToGetUserLocationText.
  ///
  /// In en, this message translates to:
  /// **'Unable to get user location'**
  String get unableToGetUserLocationText;

  /// No description provided for @whereAreYouAtText.
  ///
  /// In en, this message translates to:
  /// **'Where are you?'**
  String get whereAreYouAtText;

  /// No description provided for @typeRestaurantText.
  ///
  /// In en, this message translates to:
  /// **'Type restaurant'**
  String get typeRestaurantText;

  /// No description provided for @whatAreYouLookingForText.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get whatAreYouLookingForText;

  /// No description provided for @typeItemNameText.
  ///
  /// In en, this message translates to:
  /// **'Type item name'**
  String get typeItemNameText;

  /// No description provided for @savedToDraftText.
  ///
  /// In en, this message translates to:
  /// **'Saved to draft'**
  String get savedToDraftText;

  /// No description provided for @saveText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveText;

  /// No description provided for @notingIsSelectedText.
  ///
  /// In en, this message translates to:
  /// **'Nothing is selected'**
  String get notingIsSelectedText;

  /// No description provided for @sizeExceedsText.
  ///
  /// In en, this message translates to:
  /// **'Size exceeds the limit'**
  String get sizeExceedsText;

  /// No description provided for @couldNotFindNearbyRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Could not find restaurants near you'**
  String get couldNotFindNearbyRestaurants;

  /// No description provided for @incentivizeText.
  ///
  /// In en, this message translates to:
  /// **'Your review has been successfully submitted.”'**
  String get incentivizeText;

  /// No description provided for @draftReviewText.
  ///
  /// In en, this message translates to:
  /// **'You have a draft review, please complete it'**
  String get draftReviewText;

  /// No description provided for @nearByText.
  ///
  /// In en, this message translates to:
  /// **'Nearby restaurants'**
  String get nearByText;

  /// No description provided for @searchRestText.
  ///
  /// In en, this message translates to:
  /// **'Type restaurant name'**
  String get searchRestText;

  /// No description provided for @seeAllItemsText.
  ///
  /// In en, this message translates to:
  /// **'See all items'**
  String get seeAllItemsText;

  /// No description provided for @applyText.
  ///
  /// In en, this message translates to:
  /// **'Please apply other filters.'**
  String get applyText;

  /// No description provided for @suggestRestText.
  ///
  /// In en, this message translates to:
  /// **'Suggest Restaurant'**
  String get suggestRestText;

  /// No description provided for @uploadRestImage.
  ///
  /// In en, this message translates to:
  /// **'Upload restaurant images'**
  String get uploadRestImage;

  /// No description provided for @restName.
  ///
  /// In en, this message translates to:
  /// **'Restaurant name'**
  String get restName;

  /// No description provided for @restLocation.
  ///
  /// In en, this message translates to:
  /// **'Location Description'**
  String get restLocation;

  /// No description provided for @uploadMenuImagesText.
  ///
  /// In en, this message translates to:
  /// **'Upload Menu images'**
  String get uploadMenuImagesText;

  /// No description provided for @suggestPriceText.
  ///
  /// In en, this message translates to:
  /// **'Item price change suggestion'**
  String get suggestPriceText;

  /// No description provided for @newPriceText.
  ///
  /// In en, this message translates to:
  /// **'New price'**
  String get newPriceText;

  /// No description provided for @commentsText.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentsText;

  /// No description provided for @menuSuggestText.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Menu change suggestion'**
  String get menuSuggestText;

  /// No description provided for @suggestRestaurantText.
  ///
  /// In en, this message translates to:
  /// **'Suggest restaurant'**
  String get suggestRestaurantText;

  /// No description provided for @locationPermText.
  ///
  /// In en, this message translates to:
  /// **'Allow location service to use RateEat'**
  String get locationPermText;

  /// No description provided for @networkIssueText.
  ///
  /// In en, this message translates to:
  /// **'Connect to a network and try again'**
  String get networkIssueText;

  /// No description provided for @errText.
  ///
  /// In en, this message translates to:
  /// **'error occurred. Please try again later'**
  String get errText;

  /// No description provided for @allTimeText.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTimeText;

  /// No description provided for @monthlyText.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyText;

  /// No description provided for @weeklyText.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyText;

  /// No description provided for @dateErrorText.
  ///
  /// In en, this message translates to:
  /// **'Please select correct date'**
  String get dateErrorText;

  /// No description provided for @adultText.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old.'**
  String get adultText;

  /// No description provided for @okText.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okText;

  /// No description provided for @notSelectedText.
  ///
  /// In en, this message translates to:
  /// **'Nothing is selected.'**
  String get notSelectedText;

  /// No description provided for @noCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to use this feature.'**
  String get noCameraPermission;

  /// No description provided for @previewText.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewText;

  /// No description provided for @addingCandidateItemText.
  ///
  /// In en, this message translates to:
  /// **'Adding new Item'**
  String get addingCandidateItemText;

  /// No description provided for @itemNameText.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemNameText;

  /// No description provided for @categoryText.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryText;

  /// No description provided for @candidateItemSuccessText.
  ///
  /// In en, this message translates to:
  /// **'New item added'**
  String get candidateItemSuccessText;

  /// No description provided for @fileSizeLimitText.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds the limit'**
  String get fileSizeLimitText;

  /// No description provided for @doYouWantToAddCandidateITemText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add your item?'**
  String get doYouWantToAddCandidateITemText;

  /// No description provided for @addItemText.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemText;

  /// No description provided for @meterText.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get meterText;

  /// No description provided for @filterAgainText.
  ///
  /// In en, this message translates to:
  /// **'Try again with different filter'**
  String get filterAgainText;

  /// No description provided for @changeFiltersText.
  ///
  /// In en, this message translates to:
  /// **'That\'s all , try changing the filters'**
  String get changeFiltersText;

  /// No description provided for @loadText.
  ///
  /// In en, this message translates to:
  /// **'Loading more result'**
  String get loadText;

  /// No description provided for @seeMapText.
  ///
  /// In en, this message translates to:
  /// **'See on map'**
  String get seeMapText;

  /// No description provided for @navText.
  ///
  /// In en, this message translates to:
  /// **'Navigate directions'**
  String get navText;

  /// No description provided for @favRestText.
  ///
  /// In en, this message translates to:
  /// **'Find your favorite restaurant'**
  String get favRestText;

  /// No description provided for @goodMorningText.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorningText;

  /// No description provided for @goodAfternoonText.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoonText;

  /// No description provided for @goodEveningText.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEveningText;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeText;

  /// No description provided for @pleaseAllowLocationText.
  ///
  /// In en, this message translates to:
  /// **'Please allow location permission in settings'**
  String get pleaseAllowLocationText;

  /// No description provided for @gettingLocationText.
  ///
  /// In en, this message translates to:
  /// **'Getting location...'**
  String get gettingLocationText;

  /// No description provided for @turnOnLocationForRecommendationText.
  ///
  /// In en, this message translates to:
  /// **'Turn on location services for personalized recommendations.'**
  String get turnOnLocationForRecommendationText;

  /// No description provided for @locationDescriptionNotFoundText.
  ///
  /// In en, this message translates to:
  /// **'Could not find a description for your location.'**
  String get locationDescriptionNotFoundText;

  /// No description provided for @connectingText.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connectingText;

  /// No description provided for @checkConnectionText.
  ///
  /// In en, this message translates to:
  /// **'Check Connection'**
  String get checkConnectionText;

  /// No description provided for @orderNowCapitalText.
  ///
  /// In en, this message translates to:
  /// **'ORDER NOW'**
  String get orderNowCapitalText;

  /// No description provided for @uploadImagesText.
  ///
  /// In en, this message translates to:
  /// **'Upload images'**
  String get uploadImagesText;

  /// No description provided for @howToGetVerifiedText.
  ///
  /// In en, this message translates to:
  /// **'how to get verified temporary text'**
  String get howToGetVerifiedText;

  /// No description provided for @birrText.
  ///
  /// In en, this message translates to:
  /// **'BIRR'**
  String get birrText;

  /// No description provided for @lastMenuUpdateBeforeText.
  ///
  /// In en, this message translates to:
  /// **'Last menu update was before'**
  String get lastMenuUpdateBeforeText;

  /// No description provided for @lastPriceUpdateBeforeText.
  ///
  /// In en, this message translates to:
  /// **'Last price update was before'**
  String get lastPriceUpdateBeforeText;

  /// No description provided for @openNowText.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNowText;

  /// No description provided for @suggestPriceUpdateText.
  ///
  /// In en, this message translates to:
  /// **'Suggest price update'**
  String get suggestPriceUpdateText;

  /// No description provided for @daysText.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysText;

  /// No description provided for @dayText.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get dayText;

  /// No description provided for @phoneText.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneText;

  /// No description provided for @faileToSaveMediaText.
  ///
  /// In en, this message translates to:
  /// **'Failed to save media'**
  String get faileToSaveMediaText;

  /// No description provided for @selectMediaText.
  ///
  /// In en, this message translates to:
  /// **'Select Media'**
  String get selectMediaText;

  /// No description provided for @selectedImagesAndVideosText.
  ///
  /// In en, this message translates to:
  /// **'Selected images and videos'**
  String get selectedImagesAndVideosText;

  /// No description provided for @cannotUploadMoreThanFiveText.
  ///
  /// In en, this message translates to:
  /// **'Please select up to four images and upto four videos you can\'t continue with more than 5 videos or more than 5 images'**
  String get cannotUploadMoreThanFiveText;

  /// No description provided for @followingText.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingText;

  /// No description provided for @followersText.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followersText;

  /// No description provided for @messageText.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageText;

  /// No description provided for @notRankedText.
  ///
  /// In en, this message translates to:
  /// **'Not Ranked'**
  String get notRankedText;

  /// No description provided for @notRankedTooltipText.
  ///
  /// In en, this message translates to:
  /// **'Give a review to get into weekly rank'**
  String get notRankedTooltipText;

  /// No description provided for @contributionsText.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get contributionsText;

  /// No description provided for @loadingRanksText.
  ///
  /// In en, this message translates to:
  /// **'Loading ranks'**
  String get loadingRanksText;

  /// No description provided for @failedToLoadRanksText.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ranks'**
  String get failedToLoadRanksText;

  /// No description provided for @cantAddMoreThanFiveText.
  ///
  /// In en, this message translates to:
  /// **'You can\'t add more than five files'**
  String get cantAddMoreThanFiveText;

  /// No description provided for @failedToFollowText.
  ///
  /// In en, this message translates to:
  /// **'Failed to follow user'**
  String get failedToFollowText;

  /// No description provided for @failedToUnfollowText.
  ///
  /// In en, this message translates to:
  /// **'Failed to unfollow user'**
  String get failedToUnfollowText;

  /// No description provided for @messageFeatureCommingSoonText.
  ///
  /// In en, this message translates to:
  /// **'Message feature comming soon'**
  String get messageFeatureCommingSoonText;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @noLevel.
  ///
  /// In en, this message translates to:
  /// **'no level'**
  String get noLevel;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @weeklySmallText.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get weeklySmallText;

  /// No description provided for @failedToGetWeeklyRankText.
  ///
  /// In en, this message translates to:
  /// **'failed to get weekly rank'**
  String get failedToGetWeeklyRankText;

  /// No description provided for @remainingContributionsForNextLevelText.
  ///
  /// In en, this message translates to:
  /// **'Total number of contribution required to reach next level is'**
  String get remainingContributionsForNextLevelText;

  /// No description provided for @editProfileButtonText.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileButtonText;

  /// No description provided for @alreadyMaximumLevelText.
  ///
  /// In en, this message translates to:
  /// **'Already at maximum level'**
  String get alreadyMaximumLevelText;

  /// No description provided for @addMoreContributionsTooltipText.
  ///
  /// In en, this message translates to:
  /// **'Add more contributions to advance levels'**
  String get addMoreContributionsTooltipText;

  /// No description provided for @cannotFollowYourselfText.
  ///
  /// In en, this message translates to:
  /// **'You cannot follow yourself'**
  String get cannotFollowYourselfText;

  /// No description provided for @recommendFoodText.
  ///
  /// In en, this message translates to:
  /// **'Recommend Food'**
  String get recommendFoodText;

  /// No description provided for @recommendRestaurantText.
  ///
  /// In en, this message translates to:
  /// **'Recommend a restaurant'**
  String get recommendRestaurantText;

  /// No description provided for @recommendationMessageText.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Message'**
  String get recommendationMessageText;

  /// No description provided for @writeYourReviewHereText.
  ///
  /// In en, this message translates to:
  /// **'Write your review here...'**
  String get writeYourReviewHereText;

  /// No description provided for @shareRecommendationText.
  ///
  /// In en, this message translates to:
  /// **'Share Recommendation'**
  String get shareRecommendationText;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @unableToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load\n image'**
  String get unableToLoadImage;

  /// No description provided for @favoriteText.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favoriteText;

  /// No description provided for @followFailed.
  ///
  /// In en, this message translates to:
  /// **'Follow Failed'**
  String get followFailed;

  /// No description provided for @noFollowings.
  ///
  /// In en, this message translates to:
  /// **'You have no followings'**
  String get noFollowings;

  /// No description provided for @followingAppearHereText.
  ///
  /// In en, this message translates to:
  /// **'People you follow will appear here'**
  String get followingAppearHereText;

  /// No description provided for @unableToGetFollowings.
  ///
  /// In en, this message translates to:
  /// **'Unable to get followings'**
  String get unableToGetFollowings;

  /// No description provided for @errorWhileLoadingFollowings.
  ///
  /// In en, this message translates to:
  /// **'Error while loading followings'**
  String get errorWhileLoadingFollowings;

  /// No description provided for @noFollowers.
  ///
  /// In en, this message translates to:
  /// **'You have no follower'**
  String get noFollowers;

  /// No description provided for @followersAppearHereText.
  ///
  /// In en, this message translates to:
  /// **'People follow you will appear here'**
  String get followersAppearHereText;

  /// No description provided for @unableToGetFollowers.
  ///
  /// In en, this message translates to:
  /// **'Unable to get followers'**
  String get unableToGetFollowers;

  /// No description provided for @errorWhileLoadingFollowers.
  ///
  /// In en, this message translates to:
  /// **'Error while loading followings'**
  String get errorWhileLoadingFollowers;

  /// No description provided for @noMoreReviews.
  ///
  /// In en, this message translates to:
  /// **'That\'s all no more reviews'**
  String get noMoreReviews;

  /// No description provided for @noRecommendationFound.
  ///
  /// In en, this message translates to:
  /// **'No recommendation found'**
  String get noRecommendationFound;

  /// No description provided for @noMoreRecommendations.
  ///
  /// In en, this message translates to:
  /// **'That\'s all no more recommendations'**
  String get noMoreRecommendations;

  /// No description provided for @minimumRatingText.
  ///
  /// In en, this message translates to:
  /// **'Minimum rating'**
  String get minimumRatingText;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'onboardingTitle1'**
  String get onboardingTitle1;

  /// No description provided for onboardingDetail1.
  ///
  /// In en, this message translates to:
  /// **'onboardingDetail1'**
  String get onboardingDetail1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'onboardingTitle2'**
  String get onboardingTitle2;

  /// No description provided for onboardingDetail2.
  ///
  /// In en, this message translates to:
  /// **'onboardingDetail2'**
  String get onboardingDetail2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'onboardingTitle3'**
  String get onboardingTitle3;

  /// No description provided for onboardingDetail3.
  ///
  /// In en, this message translates to:
  /// **'onboardingDetail3'**
  String get onboardingDetail3;

  /// No description provided for Currency Text.
  ///
  /// In en, this message translates to:
  /// **'currencyText**
  String get currencyText;

  /// No description provided for Currency description.
  ///
  /// In en, this message translates to:
  /// **'currencyDescription**
  String get currencyDescription;

  /// No description provided for preferenceText.
  ///
  /// In en, this message translates to:
  /// **'preferenceText**
  String get preferenceText;

  /// No description provided for Preference description.
  ///
  /// In en, this message translates to:
  /// **PreferenceDescription**
  String get preferenceDescription;

  /// No description provided for ratedDish.
  ///
  /// In en, this message translates to:
  /// **ratedDish**
  String get ratedDish;

  /// No description provided for similarDishes.
  ///
  /// In en, this message translates to:
  /// **similarDishes**
  String get similarDishes;

  /// No description provided for seeMenu
  ///
  /// In en, this message translates to:
  /// **seeMenu**
  String get seeMenu;

  /// No description provided for appleText.
  ///
  /// In en, this message translates to:
  /// **appleText**
  String get appleText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'am',
        'en',
        'or',
        'rw',
        'ar',
        'sw',
        'fr',
        'es',
        'lg',
        'rn',
        'ru',
        'so',
        'ti',
        'tr',
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
    case 'or':
      return AppLocalizationsOr();
    case 'sw':
      return AppLocalizationsSw();
    case 'fr':
      return AppLocalizationsFr();
    case 'rw':
      return AppLocalizationsRw();
    case 'ar':
      return AppLocalizationsAr();
    case 'es':
      return AppLocalizationsEs();
    case 'lg':
      return AppLocalizationsLg();
    case 'rn':
      return AppLocalizationsRn();
    case 'ru':
      return AppLocalizationsRu();
    case 'so':
      return AppLocalizationsSo();
    case 'ti':
      return AppLocalizationsTi();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
