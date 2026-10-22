// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'Garaža';

  @override
  String get commonShare => 'Podijeli';

  @override
  String get commonSave => 'Spremi';

  @override
  String get saveStillSaving => 'Još se sprema…';

  @override
  String get saveEntryKept => 'Tvoj unos je još tu.';

  @override
  String get commonCancel => 'Odustani';

  @override
  String get commonUndo => 'Poništi';

  @override
  String get discardTitle => 'Odbaciti uneseno?';

  @override
  String get discardKeep => 'Nastavi uređivati';

  @override
  String get discardConfirm => 'Odbaci';

  @override
  String get commonRetry => 'Pokušaj ponovno';

  @override
  String get commonDelete => 'Obriši';

  @override
  String get errorGeneric => 'Nešto je pošlo po zlu. Pokušaj ponovno.';

  @override
  String get errorNoConnection =>
      'Nema internetske veze. Provjeri mrežu i pokušaj ponovno.';

  @override
  String get errorTimeout =>
      'Poslužitelj nije odgovorio na vrijeme. Možda je ipak spremljeno: provjeri popis prije ponovnog pokušaja.';

  @override
  String get errorPermission => 'Nemaš pristup tome.';

  @override
  String get errorNotFound => 'Nije pronađeno.';

  @override
  String get errorTransferCode =>
      'Taj kod za prijenos nije valjan ili je već iskorišten.';

  @override
  String get errorTransferHere => 'To vozilo je već u ovoj garaži.';

  @override
  String get errorConflict => 'To već postoji.';

  @override
  String get errorInvalid =>
      'Neke vrijednosti nisu prihvaćene. Provjeri ih i pokušaj ponovno.';

  @override
  String get errorExpired => 'Kod pozivnice je istekao.';

  @override
  String get errorAlreadyUsed => 'Kod pozivnice je već iskorišten.';

  @override
  String get errorHandoverClash =>
      'Vozilo je tog dana već predano. Najprije ukloni tu predaju ili odaberi drugi dan.';

  @override
  String get errorPlanLimit =>
      'Garaža već ima pet vozila besplatnog plana. Najprije arhiviraj jedno; poslovni plan ukida ograničenje.';

  @override
  String get errorDriversNeedAdmin =>
      'Garaža vozača treba administratora. Prije odlaska učini nekoga administratorom.';

  @override
  String get errorDriverCodeNeedsPlan =>
      'Ovaj kod je za vozača, a poslovni plan garaže je istekao. Javi se onome tko ti ga je poslao.';

  @override
  String get errorAuth => 'Prijava nije uspjela. Provjeri e-adresu i lozinku.';

  @override
  String get errorEmailNotConfirmed =>
      'Najprije potvrdi svoju e-adresu. Poveznicu za potvrdu poslali smo ti pri otvaranju računa.';

  @override
  String get authWhatIsThis => 'Što Garaža nudi';

  @override
  String get authPrivacyPolicy => 'Pravila privatnosti';

  @override
  String get authTagline => 'Gorivo i održavanje, sve zabilježeno.';

  @override
  String get authSignInTitle => 'Prijava';

  @override
  String get authSignUpTitle => 'Otvori račun';

  @override
  String get authEmail => 'E-adresa';

  @override
  String get authPassword => 'Lozinka';

  @override
  String get authDisplayName => 'Tvoje ime';

  @override
  String get authDisplayNameHint => 'Vide ga članovi tvoje garaže';

  @override
  String get authSignInAction => 'Prijavi se';

  @override
  String get authSignUpAction => 'Otvori račun';

  @override
  String get authConfirmEmailTitle => 'Provjeri e-poštu';

  @override
  String authConfirmEmailBody(String email) {
    return 'Poslali smo poveznicu za potvrdu na $email. Otvori je, a zatim se vrati i prijavi.';
  }

  @override
  String get authConfirmEmailAction => 'Natrag na prijavu';

  @override
  String get authNoAccount => 'Nemaš račun? Otvori ga';

  @override
  String get authForgotPassword => 'Zaboravljena lozinka?';

  @override
  String get authResetSent => 'Poslali smo ti poveznicu za promjenu lozinke.';

  @override
  String get authLinkFailed =>
      'Poveznica je istekla ili je već iskorištena. Prijavi se ispod ili ponovno otvori račun.';

  @override
  String get authContinueWithGoogle => 'Nastavi s Googleom';

  @override
  String get authSetNewPasswordTitle => 'Postavi novu lozinku';

  @override
  String get authPasswordUpdated => 'Lozinka je promijenjena.';

  @override
  String get authInvalidEmail => 'Unesi ispravnu e-adresu';

  @override
  String get authPasswordTooShort => 'Lozinka mora imati najmanje 8 znakova';

  @override
  String get authNameRequired => 'Unesi svoje ime';

  @override
  String get onboardingTitle => 'Postavi svoju garažu';

  @override
  String get onboardingCreateTitle => 'Napravi garažu';

  @override
  String get onboardingCreateHint => 'Svi koje pozoveš dijele ova vozila';

  @override
  String get onboardingHouseholdName => 'Naziv garaže';

  @override
  String get onboardingCreateAction => 'Napravi';

  @override
  String get onboardingJoinTitle => 'Pridruži se kodom';

  @override
  String get onboardingJoinHint =>
      'Zatraži od nekoga iz garaže kod pozivnice od osam znakova';

  @override
  String get onboardingInviteCode => 'Kod pozivnice';

  @override
  String get onboardingJoinAction => 'Pridruži se';

  @override
  String get onboardingNameRequired => 'Unesi naziv';

  @override
  String get onboardingSuggestName => 'Predloži naziv';

  @override
  String onboardingNameOfPerson(String name) {
    return 'Garaža $name';
  }

  @override
  String get onboardingNameIdea1 => 'Obiteljska garaža';

  @override
  String get onboardingNameIdea2 => 'Kućna flota';

  @override
  String get onboardingNameIdea3 => 'Naši auti';

  @override
  String get onboardingNameIdea4 => 'Dvorište';

  @override
  String get onboardingNameIdea5 => 'Vozni park';

  @override
  String get onboardingCodeInvalid => 'Unesi kod od osam znakova';

  @override
  String get onboardingSignOut => 'Odjava';

  @override
  String get joinTitle => 'Pridruži se garaži';

  @override
  String get joinInvited =>
      'Stigla ti je pozivnica u zajedničku garažu. Prijavi se ili otvori račun i odmah ćeš joj se pridružiti.';

  @override
  String get joinJoining => 'Pridruživanje…';

  @override
  String get joinDone =>
      'Unutra si. Sve što se bilježi u garaži sad je i tvoje.';

  @override
  String get joinOpenGarage => 'Otvori moju garažu';

  @override
  String get householdShareInvite => 'Podijeli pozivnicu';

  @override
  String get householdInviteLinkCopied => 'Poruka s pozivnicom je kopirana';

  @override
  String householdInviteMessageNoExpiry(String code, String link) {
    return 'Pridruži se mojoj garaži u aplikaciji Garaža: instaliraj aplikaciju, otvori račun, dodirni „Pridruži se kodom” i upiši $code. Može i jednostavnije: otvori $link.';
  }

  @override
  String householdInviteMessage(String code, String link, String until) {
    return 'Pridruži se mojoj garaži u aplikaciji Garaža: instaliraj aplikaciju, otvori račun, dodirni „Pridruži se kodom” i upiši $code. Može i jednostavnije: otvori $link. Kod vrijedi do $until.';
  }

  @override
  String get transferVehicleLocked =>
      'Ovim se kodom prenosi ovo vozilo. Vrati se ako želiš odabrati drugo.';

  @override
  String householdTransferNamed(String vehicle) {
    return 'Prenesi vozilo $vehicle u drugu garažu';
  }

  @override
  String get householdTransferPick => 'Prenesi vozilo u drugu garažu…';

  @override
  String get householdDangerZone => 'Napuštanje ili brisanje';

  @override
  String get householdManage => 'Upravljanje';

  @override
  String get householdTitle => 'Garaža';

  @override
  String get householdMembers => 'Članovi';

  @override
  String get householdInvite => 'Pozovi nekoga';

  @override
  String get householdCopyCode => 'Kopiraj kod';

  @override
  String get householdCopied => 'Kopirano';

  @override
  String get householdLeave => 'Napusti garažu';

  @override
  String get householdLeaveConfirm =>
      'Napustiti ovu garažu? Izgubit ćeš pristup njezinim vozilima.';

  @override
  String get householdSpend => 'Zajednički troškovi';

  @override
  String get householdSpendHint =>
      'Svi troškovi vozila ove garaže, po tome tko ih je unio';

  @override
  String householdUnattributed(String amount) {
    return 'S obrisanog računa: $amount';
  }

  @override
  String householdShareEach(String amount) {
    return 'Jednak udio: $amount';
  }

  @override
  String get householdSettled => 'Sve je poravnato';

  @override
  String householdOwes(String from, String to, String amount) {
    return '$from duguje $amount (prima $to)';
  }

  @override
  String get householdRemoveMember => 'Ukloni iz garaže';

  @override
  String get householdRoleAdmin => 'Administrator';

  @override
  String get householdRoleMember => 'Član';

  @override
  String get settingsUnits => 'Mjerne jedinice';

  @override
  String get settingsUnitsHint =>
      'Kako se prikazuju udaljenosti, količine i cijene';

  @override
  String get settingsDistance => 'Udaljenost';

  @override
  String get settingsVolume => 'Obujam';

  @override
  String get settingsCurrency => 'Valuta';

  @override
  String get calculatorTitle => 'Kalkulator';

  @override
  String calculatorFromCar(String vehicle, String economy) {
    return 'Iz vozila $vehicle: $economy';
  }

  @override
  String get calcModeTripCost => 'Trošak putovanja';

  @override
  String get calcModeDistance => 'Udaljenost';

  @override
  String get calcModeConsumption => 'Potrošnja';

  @override
  String get calcModeRequiredFuel => 'Potrebno gorivo';

  @override
  String get calcConsumption => 'Potrošnja';

  @override
  String get calcFuelAvailable => 'Gorivo u spremniku';

  @override
  String get calcFuelUsed => 'Potrošeno gorivo';

  @override
  String get calcResult => 'Rezultat';

  @override
  String get stationsTitle => 'Benzinske postaje';

  @override
  String get stationsFuelPetrol => 'Benzin';

  @override
  String get stationsFuelDiesel => 'Dizel';

  @override
  String get stationsFuelLpg => 'Autoplin';

  @override
  String get stationsAttribution =>
      'Cijene: mzoe-gor.hr (Ministarstvo gospodarstva)';

  @override
  String get stationsOpenMap => 'Otvori kartu';

  @override
  String get stationsNoLocationTitle => 'Najjeftinije u Hrvatskoj';

  @override
  String get stationsNoLocationBody =>
      'Bez tvoje lokacije ovo su najjeftinije postaje u zemlji, a ne najbliže. Ništa ovdje nije poredano po udaljenosti.';

  @override
  String get stationsUseLocation => 'Koristi moju lokaciju';

  @override
  String get stationsGradesNearby => 'Vrste goriva u blizini';

  @override
  String get stationsGradesCountry => 'Vrste goriva u zemlji';

  @override
  String get stationsGradesNote => 'Poredano od najraširenijih';

  @override
  String get stationsFavourite => 'Omiljena';

  @override
  String get stationsAvgNearby => 'Prosjek u blizini';

  @override
  String get stationsNationalAvg => 'Nacionalni prosjek';

  @override
  String stationsTrendUp(String amount) {
    return '$amount više nego prošlog tjedna';
  }

  @override
  String stationsTrendDown(String amount) {
    return '$amount manje nego prošlog tjedna';
  }

  @override
  String get stationsTrendSteady => 'Bez promjene u odnosu na prošli tjedan';

  @override
  String get stationsEmpty => 'Nije pronađena nijedna postaja.';

  @override
  String stationsOutOfRange(String distance) {
    return 'Cijene goriva dolaze iz otvorenih podataka hrvatskog ministarstva, pa su korisne samo unutar Hrvatske. Najbliža zabilježena postaja udaljena je $distance.';
  }

  @override
  String get timelineTitle => 'Povijest';

  @override
  String get timelineEmpty => 'Još ništa nije zabilježeno.';

  @override
  String get statsTitle => 'Statistika';

  @override
  String get statsTabFillUps => 'Točenja';

  @override
  String get statsTabCosts => 'Troškovi';

  @override
  String get statsTabDistance => 'Udaljenost';

  @override
  String get statsAllVehicles => 'Sva vozila';

  @override
  String get commonVehicle => 'Vozilo';

  @override
  String get statsThisYear => 'Ova godina';

  @override
  String get statsPreviousYear => 'Prošla godina';

  @override
  String get statsThisMonth => 'Ovaj mjesec';

  @override
  String get statsPreviousMonth => 'Prošli mjesec';

  @override
  String get statsFillUps => 'Točenja';

  @override
  String get statsFuelVolume => 'Gorivo';

  @override
  String get statsMinFill => 'Najmanje točenje';

  @override
  String get statsMaxFill => 'Najveće točenje';

  @override
  String get statsAvgEconomy => 'Prosječna potrošnja';

  @override
  String get statsBestEconomy => 'Najbolja potrošnja';

  @override
  String get statsWorstEconomy => 'Najgora potrošnja';

  @override
  String get statsTotalWithFuel => 'Troškovi (s gorivom)';

  @override
  String get statsTotalWithoutFuel => 'Troškovi (bez goriva)';

  @override
  String get statsFuelOnly => 'Gorivo';

  @override
  String get statsLowestBill => 'Najniži račun';

  @override
  String get statsHighestBill => 'Najviši račun';

  @override
  String get statsBestFuelPrice => 'Najbolja cijena goriva';

  @override
  String get statsWorstFuelPrice => 'Najgora cijena goriva';

  @override
  String get statsAvgPerDay => 'Prosjek po danu';

  @override
  String get statsAvgPerMonth => 'Prosjek po mjesecu';

  @override
  String get statsAvgPerYear => 'Prosjek po godini';

  @override
  String get statsCategories => 'Kategorije';

  @override
  String get statsDistanceTracked => 'Prijeđena udaljenost';

  @override
  String get statsDistanceNeedsSecond => 'Treba još jedno očitanje';

  @override
  String get statsLastOdometer => 'Posljednja kilometraža';

  @override
  String get statsEmpty => 'Još nema dovoljno podataka.';

  @override
  String get reminderLogIt => 'Zabilježi da je obavljeno';

  @override
  String get commonEdit => 'Uredi';

  @override
  String get confirmDeleteTitle => 'Obrisati unos?';

  @override
  String get confirmDeleteBody => 'Ovo se ne može poništiti.';

  @override
  String get settingsImportFuelio => 'Uvezi iz Fuelija';

  @override
  String get settingsImportFuelioHint =>
      'Odaberi CSV sigurnosnu kopiju iz Fuelija. Uvoze se točenja, troškovi, servisi i ponavljajući podsjetnici; ponovni uvoz preskače već postojeće retke.';

  @override
  String get settingsImportVehicle => 'Uvezi u vozilo';

  @override
  String get settingsImportRun => 'Uvezi';

  @override
  String settingsImportDone(int fills, int services, int costs, int reminders) {
    return 'Uvezeno: točenja $fills, servisi $services, troškovi $costs, podsjetnici $reminders.';
  }

  @override
  String settingsImportSkipped(String titles) {
    return 'Nije prepoznato, preskočeno: $titles';
  }

  @override
  String get vehicleCurrentOdometer => 'Trenutna kilometraža';

  @override
  String get dashboardRecent => 'Nedavna aktivnost';

  @override
  String get dashboardTotalSpent => 'Ukupno potrošeno';

  @override
  String calendarNothingOn(String date) {
    return 'Ništa ne dospijeva $date';
  }

  @override
  String get calendarTapHint => 'Dodirni dan da vidiš što dospijeva';

  @override
  String get reportsNotSaved => 'Izvještaj nije spremljen';

  @override
  String get reportsTitle => 'Izradi izvještaj';

  @override
  String get reportSellers => 'Izvještaj za prodaju';

  @override
  String get reportMaintenance => 'Povijest održavanja';

  @override
  String get reportSchedule => 'Plan servisa';

  @override
  String get reportScheduleHint =>
      'Intervali postavljeni za ovaj auto, na listu koji možeš ispisati ili nekome dati';

  @override
  String get reportScheduleItem => 'Stavka';

  @override
  String get reportScheduleEvery => 'Interval';

  @override
  String get reportScheduleLastDone => 'Posljednji put';

  @override
  String get reportScheduleNextDue => 'Sljedeći rok';

  @override
  String get reportScheduleNone =>
      'Za ovo vozilo još nisu postavljeni intervali.';

  @override
  String reportScheduleKm(String km) {
    return '$km km';
  }

  @override
  String reportScheduleMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mjeseci',
      few: '$count mjeseca',
      one: '$count mjesec',
    );
    return '$_temp0';
  }

  @override
  String get reportScheduleOnce => 'Jednokratno';

  @override
  String get reportScheduleNote =>
      'Intervali su postavke ove garaže, a ne proizvođačev plan servisa.';

  @override
  String get reportTripLog => 'Putni nalog';

  @override
  String get reportTripLogHint =>
      'Sva putovanja u razdoblju, s poslovnim udjelom i mjestom za potpis';

  @override
  String get reportTripLogPeriod => 'Razdoblje';

  @override
  String get reportTripLogDriver => 'Vozač';

  @override
  String get reportTripLogPurpose => 'Opis';

  @override
  String get reportTripLogRoute => 'Relacija';

  @override
  String get reportTripLogBusinessTotal => 'Poslovno prijeđeno';

  @override
  String get reportTripLogPrivateTotal => 'Privatno prijeđeno';

  @override
  String get reportTripLogTotal => 'Ukupno prijeđeno';

  @override
  String get reportTripLogTrips => 'Putovanja';

  @override
  String get reportTripLogSignature => 'Potpis';

  @override
  String get reportTripLogDate => 'Datum';

  @override
  String get reportTripLogNoTrips =>
      'U ovom razdoblju nema zabilježenih putovanja.';

  @override
  String get reportTripLogPickPeriod => 'Koje razdoblje?';

  @override
  String get reportTripLogThisMonth => 'Ovaj mjesec';

  @override
  String get reportTripLogLastMonth => 'Prošli mjesec';

  @override
  String get reportTripLogThisYear => 'Ova godina';

  @override
  String get reportAnnual => 'Godišnji sažetak';

  @override
  String get reportSellersHint =>
      'Ono što kupca zanima: povijest, kilometraža i troškovi';

  @override
  String get reportMaintenanceHint =>
      'Svi zabilježeni servisi, s datumima i kilometražom';

  @override
  String get reportAnnualHint =>
      'Gorivo, servisi i ostali troškovi za jednu godinu';

  @override
  String get costsTitle => 'Troškovi';

  @override
  String get costAdd => 'Dodaj trošak';

  @override
  String get costEdit => 'Uredi trošak';

  @override
  String get costAmount => 'Iznos';

  @override
  String get costCategory => 'Kategorija';

  @override
  String get costDate => 'Datum';

  @override
  String get costRemindNextYear => 'Podsjeti me kad ponovno dospije';

  @override
  String get costsEmpty => 'Još nema unesenih troškova.';

  @override
  String get costsEmptyBeyondFuel => 'Osim goriva još nema troškova.';

  @override
  String costsFuelLine(String amount) {
    return 'Gorivo $amount, iz točenja';
  }

  @override
  String get costAmountRequired => 'Unesi iznos.';

  @override
  String get costCategoryRegistration => 'Registracija';

  @override
  String get costCategoryInsurance => 'Osiguranje';

  @override
  String get costCategoryParking => 'Parking';

  @override
  String get costCategoryToll => 'Cestarina';

  @override
  String get costCategoryVignette => 'Vinjeta';

  @override
  String get countryAustria => 'Austrija';

  @override
  String get countryBulgaria => 'Bugarska';

  @override
  String get countryCzechia => 'Češka';

  @override
  String get countryHungary => 'Mađarska';

  @override
  String get countryRomania => 'Rumunjska';

  @override
  String get countrySlovakia => 'Slovačka';

  @override
  String get countrySlovenia => 'Slovenija';

  @override
  String get countrySwitzerland => 'Švicarska';

  @override
  String fuelAtThePump(String station, String distance) {
    return 'Preuzeto s postaje $station, $distance od tebe. Promijeni ako je cijena bila drukčija';
  }

  @override
  String get costVignetteCountry => 'Država';

  @override
  String get costVignetteValidity => 'Vrijedi';

  @override
  String get costVignetteValidityDay1 => '1 dan';

  @override
  String get costVignetteValidityDays7 => '7 dana';

  @override
  String get costVignetteValidityDays10 => '10 dana';

  @override
  String get costVignetteValidityDays30 => '30 dana';

  @override
  String get costVignetteValidityMonths2 => '2 mjeseca';

  @override
  String get costVignetteValidityDays60 => '60 dana';

  @override
  String get costVignetteValidityYear => '1 godina';

  @override
  String costVignetteBuy(String operator) {
    return 'Kupi na stranici $operator';
  }

  @override
  String costVignetteExpires(String date) {
    return 'Vrijedi do $date';
  }

  @override
  String get costVignetteRemind => 'Podsjeti me posljednjeg dana valjanosti';

  @override
  String get costCategoryWash => 'Pranje auta';

  @override
  String get costCategoryFine => 'Kazna';

  @override
  String get costCategoryEquipment => 'Oprema';

  @override
  String get costCategoryOther => 'Ostalo';

  @override
  String get settingsSignOut => 'Odjava';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Prema sustavu';

  @override
  String get settingsThemeLight => 'Svijetla';

  @override
  String get settingsThemeDark => 'Tamna';

  @override
  String get settingsLanguage => 'Jezik';

  @override
  String get settingsLanguageSystem => 'Prema sustavu';

  @override
  String get settingsBundling => 'Objedinjavanje podsjetnika';

  @override
  String get settingsBundlingWindowDays => 'Najveći razmak (dani)';

  @override
  String get settingsBundlingWindowKm => 'Najveći razmak (udaljenost)';

  @override
  String get settingsBundlingHint =>
      'Stavke koje dospijevaju u kratkom razmaku predlažu se kao jedan odlazak u servis';

  @override
  String get settingsReminders => 'Podsjetnici';

  @override
  String get settingsRemindersThisDevice =>
      'Obavijest stiže samo na ovaj uređaj';

  @override
  String get settingsRemindersThisDeviceHint =>
      'Svaki telefon sam zakazuje svoje podsjetnike, pa tko podsjetnik nije postavio, neće ni dobiti obavijest.';

  @override
  String get settingsRemindersEveryone => 'Obavijest stiže svima u ovoj garaži';

  @override
  String get settingsRemindersEveryoneHint =>
      'Podsjetnike šalje poslužitelj, pa ih dobiva svaki član, a ne samo uređaj koji ih je postavio.';

  @override
  String get settingsRemindersSchedule =>
      'Stižu 30 i 7 dana prije roka te čim očitanje kilometraže pokaže da je do roka ostalo manje od 500 km';

  @override
  String get settingsRemindersScheduleDevice =>
      'Ovaj ih uređaj šalje u 9:00 ujutro';

  @override
  String get settingsRemindersScheduleServer =>
      'Poslužitelj ih šalje rano ujutro';

  @override
  String get settingsCountry => 'Država';

  @override
  String get settingsCountryHint =>
      'Koje se stavke registracije i pregleda nude';

  @override
  String get countryElsewhere => 'Drugdje';

  @override
  String get settingsTracking => 'Razina detalja';

  @override
  String get settingsTrackingHint => 'Koliko detalja traži unos servisa';

  @override
  String get trackingBeginner => 'Osnovno';

  @override
  String get trackingIntermediate => 'Detaljno';

  @override
  String get trackingAdvanced => 'Potpuno';

  @override
  String get serviceDiy => 'Odrađeno samostalno';

  @override
  String get servicePartsCost => 'Dijelovi';

  @override
  String get serviceLaborCost => 'Rad';

  @override
  String get servicePartsDetail => 'Ugrađeni dijelovi';

  @override
  String get serviceWarrantyUntil => 'Jamstvo do';

  @override
  String get serviceFaultCodes => 'Kodovi grešaka';

  @override
  String get serviceFaultCodesHint => 'npr. P0301, P0171';

  @override
  String get serviceMeasurements => 'Očitanja';

  @override
  String get measurementBrakePadFront => 'Prednje pločice';

  @override
  String get measurementBrakePadRear => 'Stražnje pločice';

  @override
  String get measurementBrakeDiscFront => 'Prednji diskovi';

  @override
  String get measurementTreadFrontLeft => 'Profil, prednja lijeva';

  @override
  String get measurementTreadFrontRight => 'Profil, prednja desna';

  @override
  String get measurementTreadRearLeft => 'Profil, stražnja lijeva';

  @override
  String get measurementTreadRearRight => 'Profil, stražnja desna';

  @override
  String get measurementBatteryVolts => 'Napon akumulatora';

  @override
  String get measurementBatteryCca => 'CCA akumulatora';

  @override
  String get settingsData => 'Tvoji podaci';

  @override
  String get settingsExport => 'Izvezi kao tablice';

  @override
  String settingsExportDone(String file) {
    return 'Izvoz je spreman: $file';
  }

  @override
  String get settingsDeleteAccount => 'Obriši račun';

  @override
  String get settingsDeleteConfirmTitle => 'Obrisati svoj račun?';

  @override
  String get settingsDeleteConfirmBody =>
      'Ovo trajno briše tvoj račun. Ako si posljednji član garaže, brišu se i njezina vozila sa svom poviješću. Ovo se ne može poništiti.';

  @override
  String get settingsDeleteConfirmAction => 'Trajno obriši';

  @override
  String get settingsDeleteTypeName => 'Upiši naziv garaže za potvrdu';

  @override
  String get settingsDeleteNameMismatch => 'To nije naziv garaže.';

  @override
  String get apiTitle => 'API pristup';

  @override
  String get apiHint =>
      'Ključevi samo za čitanje za vlastite skripte i webhookovi koji šalju podatke ove garaže na URL po tvojem izboru';

  @override
  String get apiDocs => 'Kako se koristi';

  @override
  String get apiNewKey => 'Novi ključ';

  @override
  String get apiKeyName => 'Čemu služi?';

  @override
  String get apiKeyCreate => 'Napravi';

  @override
  String get apiKeyOnce => 'Kopiraj ključ sada: više se neće prikazati';

  @override
  String get apiKeyRevoke => 'Opozovi';

  @override
  String get apiKeyRevoked => 'Opozvan';

  @override
  String get apiKeyNeverUsed => 'Nije korišten';

  @override
  String apiKeyLastUsed(String date) {
    return 'Posljednji put korišten $date';
  }

  @override
  String get apiWebhooks => 'Webhookovi';

  @override
  String get apiWebhooksHint =>
      'Pozivaju se kad se nešto dogodi autu ili garaži';

  @override
  String get apiWebhookAdd => 'Dodaj webhook';

  @override
  String get apiWebhookFormat => 'Format';

  @override
  String get apiWebhookFormatHint =>
      'Prepoznaje se iz adrese, osim ako primatelj radi na tvom poslužitelju';

  @override
  String get apiWebhookEvents => 'Šalje';

  @override
  String get apiWebhookEventEntries =>
      'Točenja, servisi, troškovi, očitanja, putovanja i prihodi';

  @override
  String get apiWebhookEventChanges => 'Uređeni ili obrisani unosi';

  @override
  String get apiWebhookEventCars =>
      'Vozila dodana, arhivirana, posuđena ili prenesena';

  @override
  String get apiWebhookEventMembers => 'Članovi koji se pridružuju ili odlaze';

  @override
  String get apiWebhookEventReminders => 'Dospjeli podsjetnici';

  @override
  String get apiWebhookEventsNone => 'Odaberi barem jedno';

  @override
  String get apiWebhookEditEvents => 'Što ovaj webhook prima';

  @override
  String get apiWebhookFormatAuto => 'Prepoznaj iz adrese';

  @override
  String get apiWebhookFormatGeneric =>
      'Potpisani JSON (Home Assistant, skripte)';

  @override
  String get apiWebhookUrl => 'Adresa';

  @override
  String get apiWebhookInvalid => 'Unesi https:// adresu';

  @override
  String get apiWebhookAddAction => 'Dodaj';

  @override
  String apiWebhookFailing(int status) {
    return 'Posljednja isporuka nije uspjela ($status)';
  }

  @override
  String get apiWebhookName => 'Naziv';

  @override
  String get apiWebhookNameHint => 'Neobvezno. Prikazuje se umjesto adrese';

  @override
  String get apiWebhookCars => 'Vozila';

  @override
  String get apiWebhookCarsAll => 'Sva vozila';

  @override
  String apiWebhookCarsSome(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vozila',
      few: '$count vozila',
      one: '$count vozilo',
    );
    return '$_temp0';
  }

  @override
  String get apiWebhookCarsNone => 'Odaberi barem jedno vozilo';

  @override
  String get apiWebhookLanguage => 'Jezik poruka';

  @override
  String get apiWebhookLanguageHint =>
      'Za chat aplikacije. Potpisani JSON ne ovisi o jeziku';

  @override
  String get apiWebhookFormatTeams => 'Microsoft Teams';

  @override
  String get apiWebhookFormatText => 'Rocket.Chat, Matrix (običan tekst)';

  @override
  String get apiWebhookFormatPushover => 'Pushover';

  @override
  String get apiWebhookFormatPushbullet => 'Pushbullet';

  @override
  String get apiWebhookNeedsToken =>
      'Zalijepi adresu s tokenom i korisničkim ključem';

  @override
  String get apiWebhookCopied => 'Adresa je kopirana';

  @override
  String apiWebhookDelivered(String when) {
    return 'Isporučeno $when';
  }

  @override
  String apiWebhookRetrying(int attempt, int most) {
    return 'Ponovni pokušaj $attempt od $most';
  }

  @override
  String apiWebhookGivenUp(int most) {
    return 'Prekinuto nakon $most pokušaja';
  }

  @override
  String get apiWebhookQueued => 'U redu čekanja';

  @override
  String get apiWebhookPaused =>
      'Pauzirano: nijedna od posljednjih isporuka nije uspjela';

  @override
  String get apiWebhookResume => 'Nastavi';

  @override
  String get apiWebhookSendTest => 'Pošalji probnu poruku';

  @override
  String get apiWebhookTestSent =>
      'Probna poruka je poslana. Prati dnevnik ispod.';

  @override
  String get apiWebhookLog => 'Nedavne isporuke';

  @override
  String get apiWebhookGone => 'Ovaj webhook više ne postoji';

  @override
  String get apiWebhookLogEmpty => 'Još ništa nije poslano';

  @override
  String get apiWebhookNever => 'Još ništa nije poslano';

  @override
  String get commonCopy => 'Kopiraj';

  @override
  String get settingsPrivacyPolicy => 'Pravila privatnosti';

  @override
  String get vehiclesTitle => 'Vozila';

  @override
  String get vehiclesEmpty => 'Dodaj prvo vozilo i počni voditi evidenciju';

  @override
  String get vehiclesAdd => 'Dodaj vozilo';

  @override
  String vehicleAdded(String name) {
    return 'Dodano: $name';
  }

  @override
  String get vehicleNickname => 'Naziv';

  @override
  String get vehicleNameRequired => 'Unesi naziv';

  @override
  String get vehicleMake => 'Marka';

  @override
  String get vehicleModel => 'Model';

  @override
  String get vehicleYear => 'Godina';

  @override
  String get vehiclePhoto => 'Fotografija';

  @override
  String get vehiclePhotoAdd => 'Dodaj fotografiju';

  @override
  String get vehiclePhotoReplace => 'Zamijeni fotografiju';

  @override
  String get vehiclePhotoCropTitle => 'Uokviri fotografiju';

  @override
  String get vehiclePhotoRemove => 'Ukloni fotografiju';

  @override
  String get vehiclePhotoNotAPhoto =>
      'Ta datoteka nije fotografija. Odaberi sliku u formatu JPEG, PNG, WebP ili HEIC.';

  @override
  String get vehiclePlate => 'Registarska oznaka';

  @override
  String get sheetVehicleLockedByFile =>
      'Ukloni prilog ako ovo želiš premjestiti na drugi auto';

  @override
  String get sheetVehicleTapToChange => 'Dodirni za promjenu';

  @override
  String get vehicleVin => 'Broj šasije (VIN)';

  @override
  String get vehicleVinLength => 'Broj šasije ima od 11 do 17 znakova';

  @override
  String get vehicleDecodeVin => 'Dohvati';

  @override
  String get vehicleVinHint => 'Iz broja popunjava marku, model i godinu';

  @override
  String get vehicleVinNotFound =>
      'Podatke za taj broj šasije nije moguće dohvatiti';

  @override
  String get vehicleVinDecoded => 'Popunjeno prema broju šasije';

  @override
  String get vehicleFuelType => 'Vrsta goriva';

  @override
  String get vehicleOdometer => 'Trenutna kilometraža';

  @override
  String fuelCheaperNearby(String amount, String distance, String station) {
    return '$amount jeftinije na postaji $station, $distance dalje';
  }

  @override
  String get fuelCheapestNearby => 'Najjeftinije u blizini tog dana';

  @override
  String fuelWorseThanUsual(String percent) {
    return '$percent više od uobičajenog za ovaj auto';
  }

  @override
  String fuelBetterThanUsual(String percent) {
    return '$percent manje od uobičajenog za ovaj auto';
  }

  @override
  String get vehicleTankCapacity => 'Obujam spremnika';

  @override
  String get vehicleTankCapacityHint =>
      'Upozorava na točenje veće od spremnika';

  @override
  String get vehicleCurrentValue => 'Koliko sada vrijedi';

  @override
  String get vehicleCurrentValueHint =>
      'Tvoja procjena. Uz kupovnu cijenu pokazuje koliko auto košta držati, a ne samo voziti: gubitak vrijednosti najveći je trošak vlasništva.';

  @override
  String get vehiclePurchasePrice => 'Kupovna cijena';

  @override
  String get vehiclePurchasePriceHint => 'Koliko je auto koštao';

  @override
  String get vehicleArchiveTitle => 'Arhivirati ovo vozilo?';

  @override
  String get vehicleArchiveBody =>
      'Zadržava povijest, a nestaje s popisa i iz zbrojeva. Možeš ga vratiti s njegove stranice.';

  @override
  String get vehicleArchivedBanner =>
      'Arhivirano: nije na popisima, povijest je sačuvana.';

  @override
  String get vehicleSearch => 'Pretraži vozila';

  @override
  String get recallsTitle => 'Sigurnosni opozivi';

  @override
  String get recallsNone => 'Nema opoziva za ovu marku, model i godinu';

  @override
  String get recallsCheck => 'Provjeri opozive';

  @override
  String get recallsCaveat =>
      'Iz američkog NHTSA registra: za europsko vozilo potvrdi kod ovlaštenog servisa';

  @override
  String get recallsNeedsDetails =>
      'Dodaj marku, model i godinu za provjeru opoziva';

  @override
  String get tyresTitle => 'Gume';

  @override
  String get vehicleTyresHint =>
      'Kompleti, sezonska zamjena, dubina profila i starost';

  @override
  String get tyresEmpty => 'Dodaj komplete guma koje ovo vozilo koristi';

  @override
  String get tyresAdd => 'Dodaj komplet';

  @override
  String get tyresEdit => 'Uredi komplet';

  @override
  String tyresAgeAgeing(Object years) {
    return 'Stare $years god. Provjeravaj ih svake godine';
  }

  @override
  String tyresAgeAgeingEstimated(Object years) {
    return 'Stare otprilike $years god., procijenjeno prema ugradnji';
  }

  @override
  String tyresAgeExpired(Object years) {
    return 'Stare $years god. Zamijeni ih bez obzira na profil';
  }

  @override
  String tyresAgeExpiredEstimated(Object years) {
    return 'Stare otprilike $years god., procijenjeno prema ugradnji. Zamijeni ih bez obzira na profil';
  }

  @override
  String get tyresDotCode => 'DOT oznaka';

  @override
  String get tyresDotPerCorner => 'Svaka guma ima drukčiju oznaku';

  @override
  String get tyresDotSame => 'Sve su iste';

  @override
  String get tyresDotCodeHint =>
      'Četiri znamenke na boku gume, npr. 3419 za 34. tjedan 2019.';

  @override
  String get tyresDotCodeInvalid =>
      'Četiri znamenke: tjedan od 01 do 53, pa godina';

  @override
  String get tyresName => 'Naziv';

  @override
  String get tyresSeason => 'Sezona';

  @override
  String get tyresSize => 'Dimenzija';

  @override
  String get tyresStorage => 'Mjesto čuvanja';

  @override
  String get tyresFitted => 'Na vozilu';

  @override
  String get tyresFit => 'Postavi na vozilo';

  @override
  String get tyresRetire => 'Stavi izvan uporabe';

  @override
  String get tyresUnfit => 'Skini s vozila';

  @override
  String get tyresUnretire => 'Vrati u uporabu';

  @override
  String get tyresMoreActions => 'Više za ovaj komplet';

  @override
  String get tyresRetireConfirmTitle => 'Staviti ovaj komplet izvan uporabe?';

  @override
  String get tyresRetireConfirmBody =>
      'Ostaje na popisu sa svojim mjerenjima i više se ne nudi za montažu.';

  @override
  String get tyresDelete => 'Obriši komplet';

  @override
  String get tyresDeleteConfirmTitle => 'Obrisati ovaj komplet?';

  @override
  String get tyresDeleteConfirmBody =>
      'Nestaju i komplet i sva mjerenja dubine na njemu. To se ne može poništiti.';

  @override
  String get tyresRetired => 'Izvan uporabe';

  @override
  String get tyresAddReading => 'Zabilježi profil';

  @override
  String get tyresTread => 'Profil';

  @override
  String get tyresTreadNone => 'Profil nije zabilježen';

  @override
  String get tyresReadingSaved => 'Profil je zabilježen';

  @override
  String tyresMeasuredOn(String date) {
    return 'Izmjereno $date';
  }

  @override
  String tyresBelowLegalAt(String minimum) {
    return 'Na zakonskom minimumu od $minimum ili ispod';
  }

  @override
  String tyresWearEstimate(String distance, String date) {
    return 'Preostaje otprilike $distance, oko $date';
  }

  @override
  String tyresWearEstimateDistanceOnly(Object distance) {
    return 'Još otprilike $distance';
  }

  @override
  String get economyByFuelOverlap =>
      'Svako se gorivo mjeri preko vlastitih točenja, ali se rasponi preklapaju: uračunata je i kilometraža prijeđena na drugom gorivu. Uzmi ove brojke kao približne.';

  @override
  String tyresUneven(String low, String high) {
    return 'Neravnomjerno: od $low do $high';
  }

  @override
  String get tyresFront => 'Prednja';

  @override
  String get tyresRear => 'Stražnja';

  @override
  String get tyresFrontLeft => 'Prednja lijeva';

  @override
  String get tyresFrontRight => 'Prednja desna';

  @override
  String get tyresRearLeft => 'Stražnja lijeva';

  @override
  String get tyresRearRight => 'Stražnja desna';

  @override
  String get tyreSeasonSummer => 'Ljetne';

  @override
  String get tyreSeasonWinter => 'Zimske';

  @override
  String get tyreSeasonAll => 'Cjelogodišnje';

  @override
  String get vehicleTabFuel => 'Gorivo';

  @override
  String get vehicleTabUpkeep => 'Servis';

  @override
  String get vehicleTabCar => 'Auto';

  @override
  String get remindersTitle => 'Podsjetnici';

  @override
  String get vehicleArchive => 'Arhiviraj';

  @override
  String get vehicleRestore => 'Vrati iz arhive';

  @override
  String get vehicleArchived =>
      'Arhivirano. Povijest ostaje, a vozilo nestaje s popisa.';

  @override
  String get vehicleRestored => 'Vozilo je opet u garaži.';

  @override
  String get vehicleDelete => 'Obriši vozilo';

  @override
  String get vehicleDeleteTitle => 'Obrisati ovo vozilo?';

  @override
  String get vehicleDeleteBody =>
      'Sva točenja, servisi, troškovi, očitanja i dokumenti nestaju s njim i ništa se ne može vratiti. Arhiviraj ga ako želiš zadržati povijest.';

  @override
  String get vehiclesArchivedSection => 'Arhivirano';

  @override
  String get vehicleEdit => 'Uredi vozilo';

  @override
  String get vehicleNoEconomyYet =>
      'Zabilježi dva točenja do punog spremnika i pojavit će se potrošnja';

  @override
  String economyTanksProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zabilježeno $count od 2 puna spremnika',
      few: 'Zabilježena $count od 2 puna spremnika',
      one: 'Zabilježen $count od 2 puna spremnika',
    );
    return '$_temp0';
  }

  @override
  String get vehicleTrendNeedsMore =>
      'Zabilježi još točenja do punog spremnika i pojavit će se trend';

  @override
  String get plannerRestoreExcluded => 'Vrati isključene stavke';

  @override
  String get vehicleNoHistoryYet => 'Još nema zabilježenih servisa';

  @override
  String get fuelPetrol => 'Benzin';

  @override
  String get fuelDiesel => 'Dizel';

  @override
  String get fuelLpg => 'Autoplin';

  @override
  String get fuelElectric => 'Struja';

  @override
  String get fuelHybrid => 'Hibrid';

  @override
  String get fuelTitle => 'Gorivo';

  @override
  String get fuelEmpty => 'Zabilježi točenje za praćenje potrošnje';

  @override
  String fuelSaved(String amount) {
    return 'Spremljeno, $amount.';
  }

  @override
  String fuelSavedFirstFull(String amount) {
    return 'Spremljeno, $amount. Još jedan pun spremnik i pojavit će se potrošnja.';
  }

  @override
  String get fuelSavedPlain => 'Točenje je spremljeno.';

  @override
  String get serviceSaved => 'Servis je zabilježen.';

  @override
  String get costDuplicateWarning =>
      'Isti iznos u istoj kategoriji već je zabilježen tog dana';

  @override
  String get costSaved => 'Trošak je spremljen.';

  @override
  String get fuelAdd => 'Zabilježi točenje';

  @override
  String get fuelLatest => 'Posljednja točenja';

  @override
  String fuelAllFillUps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sva točenja ($count)',
      few: 'Sva točenja ($count)',
      one: 'Sva točenja ($count)',
    );
    return '$_temp0';
  }

  @override
  String get servicesTitle => 'Servisi';

  @override
  String get vehicleSectionDue => 'Rokovi';

  @override
  String get vehicleSectionHistory => 'Povijest';

  @override
  String vehicleOnLoanTo(Object date, Object label) {
    return 'Na posudbi do $date · $label';
  }

  @override
  String vehicleOnLoanUntil(Object date) {
    return 'Na posudbi do $date';
  }

  @override
  String get fuelEdit => 'Uredi točenje';

  @override
  String get fuelDate => 'Datum';

  @override
  String get fuelOdometer => 'Kilometraža';

  @override
  String get fuelVolume => 'Količina';

  @override
  String get fuelEnergy => 'Punjenje (kWh)';

  @override
  String get fuelPricePerUnit => 'Cijena po jedinici';

  @override
  String get fuelTotal => 'Ukupno';

  @override
  String get fuelFullTank => 'Pun spremnik';

  @override
  String get fuelFullTankHint =>
      'Potrošnja se računa od jednog punog spremnika do drugog';

  @override
  String get fuelMissedFill => 'Prethodno točenje nije zabilježeno';

  @override
  String get fuelMissedFillHint =>
      'Prekida lanac izračuna kako se ne bi prikazao pogrešan podatak';

  @override
  String get fuelStation => 'Postaja';

  @override
  String get attachmentsTitle => 'Prilozi';

  @override
  String get attachmentsAdd => 'Dodaj račun ili dokument';

  @override
  String get fuelNotes => 'Bilješke';

  @override
  String get fuelAverage => 'Prosjek';

  @override
  String get fuelCostPerDistance => 'Trošak goriva, posljednje točenje';

  @override
  String get fuelNeedTwoValues =>
      'Unesi barem dva podatka: količinu, cijenu ili ukupan iznos';

  @override
  String get amountNotANumber => 'Nije broj';

  @override
  String get fuelOdometerRequired => 'Unesi očitanje kilometraže';

  @override
  String fuelOdometerTooLow(String previous) {
    return 'Manje od prethodnog očitanja ($previous)';
  }

  @override
  String fuelOdometerTooHigh(String next) {
    return 'Više od sljedećeg očitanja ($next)';
  }

  @override
  String fuelOdometerLast(String previous) {
    return 'Posljednje očitanje: $previous';
  }

  @override
  String fuelOdometerEarlierToday(String reading) {
    return 'Ranije danas: $reading';
  }

  @override
  String fuelImpliedConsumption(String rate) {
    return 'To bi značilo $rate: provjeri kilometražu i količinu';
  }

  @override
  String fuelVolumeOverTank(String capacity) {
    return 'Više nego što spremnik prima ($capacity)';
  }

  @override
  String get maintenanceTitle => 'Održavanje';

  @override
  String get maintenanceEmpty => 'Dodaj podsjetnik i prati što dospijeva';

  @override
  String get maintenanceAddRule => 'Dodaj podsjetnik';

  @override
  String maintenanceRuleSaved(String type) {
    return 'Podsjetnik postavljen: $type';
  }

  @override
  String get maintenanceLogService => 'Zabilježi servis';

  @override
  String get maintenanceEditService => 'Uredi servis';

  @override
  String get maintenanceIntervalKm => 'Interval (udaljenost)';

  @override
  String get maintenanceIntervalMonths => 'Interval (mjeseci)';

  @override
  String intervalNoteMake(String make) {
    return 'Uobičajeno za marku $make: provjeri u servisnoj knjižici';
  }

  @override
  String get intervalNoteChain =>
      'Ovaj motor ima lanac razvoda, pa interval nije potreban';

  @override
  String get intervalNoteWetBelt =>
      'Remen u ulju: većina proizvođača skratila je ovaj interval';

  @override
  String get intervalNoteSetTimingDrive =>
      'Postavi vrstu razvoda na vozilu za bolju zadanu vrijednost';

  @override
  String get intervalNoteSetTransmission =>
      'Postavi vrstu mjenjača na vozilu za bolju zadanu vrijednost';

  @override
  String get intervalNoteSealed =>
      'Suhi mjenjač s dvostrukom spojkom zatvoren je za cijeli vijek';

  @override
  String get intervalNoteAdvisory =>
      'Proizvođači često kažu „doživotno”, ali ga nezavisni serviseri ipak mijenjaju';

  @override
  String get maintenanceIntervalHint =>
      'Postavi jedno ili oboje. Vrijedi ono što prije nastupi.';

  @override
  String maintenanceDueAt(String odometer) {
    return 'na $odometer';
  }

  @override
  String get maintenanceOneTime => 'Jednokratni podsjetnik';

  @override
  String get maintenanceDueDateField => 'Rok (datum)';

  @override
  String get maintenanceDueKmField => 'Rok (kilometraža)';

  @override
  String get maintenanceOneTimeNeedsTarget =>
      'Postavi rok po datumu ili kilometraži.';

  @override
  String maintenanceOtherDeadlineByDate(String date) {
    return 'Po datumu tek $date';
  }

  @override
  String maintenanceOtherDeadlineByDistance(String date) {
    return 'Po kilometraži tek $date';
  }

  @override
  String maintenanceRateMeasured(num days, String rate) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana',
      few: '$days dana',
      one: '$days dana',
    );
    return 'Datumi ispod procijenjeni su prema $rate/dan iz očitanja tijekom $_temp0';
  }

  @override
  String maintenanceRateUnmeasured(String rate) {
    return 'Još ne znamo koliko voziš pa se datumi ispod temelje na vremenskom intervalu. Nakon nekoliko tjedana očitanja pojavit će se i procjena po kilometraži; podsjetnik zadan samo udaljenošću dotad računa s $rate/dan.';
  }

  @override
  String maintenanceCostForItems(String amount, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$amount za $count stavki',
      few: '$amount za $count stavke',
      one: '$amount za $count stavku',
    );
    return '$_temp0';
  }

  @override
  String maintenancePreviously(String details) {
    return 'Prethodno: $details';
  }

  @override
  String maintenanceDueOn(String date) {
    return 'Dospijeva $date';
  }

  @override
  String maintenanceExpectedOn(String date) {
    return 'Predviđeno $date';
  }

  @override
  String get maintenanceNeedsInterval =>
      'Postavi interval po kilometraži ili vremenu';

  @override
  String get maintenanceServiceDate => 'Datum';

  @override
  String get maintenanceServiceCost => 'Trošak';

  @override
  String get maintenanceServiceShop => 'Radionica';

  @override
  String get serviceDuplicateWarning =>
      'Isti zahvat na istoj kilometraži već je zabilježen tog dana';

  @override
  String get documentsTitle => 'Dokumenti';

  @override
  String get documentsSubtitle =>
      'Registracija, tehnički pregled, osiguranje i kada kojem ističe rok';

  @override
  String get documentsEmpty =>
      'Još nema dokumenata. Zabilježi do kada vrijede registracija i tehnički pregled pa će te aplikacija upozoriti na vrijeme.';

  @override
  String get documentsSomethingExpired => 'Nešto je isteklo';

  @override
  String get documentsSomethingExpiring => 'Nešto uskoro ističe';

  @override
  String get documentAdd => 'Dodaj dokument';

  @override
  String get documentEdit => 'Uredi dokument';

  @override
  String get documentType => 'Vrsta';

  @override
  String get documentLabel => 'Naziv';

  @override
  String get documentLabelHint => 'Samo za dokument kojeg nema na popisu';

  @override
  String get documentNumber => 'Broj';

  @override
  String get documentIssuer => 'Izdavatelj';

  @override
  String get documentIssuedOn => 'Izdano';

  @override
  String get documentExpiresOn => 'Vrijedi do';

  @override
  String get documentDateNotSet => 'Nije postavljeno';

  @override
  String get documentClearDate => 'Očisti';

  @override
  String get documentNoExpiry => 'Rok nije zabilježen';

  @override
  String documentExpiredOn(String date) {
    return 'Isteklo $date';
  }

  @override
  String get documentExpiresToday => 'Ističe danas';

  @override
  String documentExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ističe za $count dana',
      few: 'Ističe za $count dana',
      one: 'Ističe za $count dan',
    );
    return '$_temp0';
  }

  @override
  String documentValidUntil(String date) {
    return 'Vrijedi do $date';
  }

  @override
  String get documentDatesOutOfOrder =>
      'Ne može isteći prije nego što je izdano';

  @override
  String get documentLabelRequired => 'Napiši o kojem se dokumentu radi';

  @override
  String get documentSaved => 'Dokument je spremljen.';

  @override
  String get documentReminderNote =>
      'Podsjetnik se postavlja prema roku, pa će se stavka pojaviti u planeru prije isteka.';

  @override
  String get documentNoReminderNote =>
      'Bez podsjetnika: aplikacija za ovo nema naziv pa ne može reći što dospijeva.';

  @override
  String get documentTypeRegistration => 'Registracija';

  @override
  String get documentTypeRoadworthiness => 'Tehnički pregled';

  @override
  String get documentTypeInsuranceLiability => 'Obvezno osiguranje';

  @override
  String get documentTypeInsuranceComprehensive => 'Kasko osiguranje';

  @override
  String get documentTypeGreenCard => 'Zelena karta';

  @override
  String get documentTypeOther => 'Ostalo';

  @override
  String get maintenanceServiceItems => 'Što je obavljeno';

  @override
  String get maintenanceRuleServiceType => 'Vrsta servisa';

  @override
  String get serviceTypeChoose => 'Odaberi vrstu servisa';

  @override
  String get serviceTypeSearch => 'Pretraži';

  @override
  String get serviceTypeCommon => 'Najčešće';

  @override
  String get serviceTypeOthers => 'Sve ostalo';

  @override
  String get serviceTypeNoMatch => 'Ništa ne odgovara';

  @override
  String get maintenanceCalendar => 'Kalendar';

  @override
  String get maintenanceList => 'Popis';

  @override
  String get serviceOilChange => 'Zamjena ulja';

  @override
  String get serviceOilFilter => 'Filtar ulja';

  @override
  String get serviceAirFilter => 'Filtar zraka';

  @override
  String get serviceCabinFilter => 'Filtar kabine';

  @override
  String get serviceSparkPlugs => 'Svjećice';

  @override
  String get serviceBrakeFluid => 'Kočiona tekućina';

  @override
  String get serviceBrakePadsFront => 'Prednje kočione pločice';

  @override
  String get serviceBrakePadsRear => 'Stražnje kočione pločice';

  @override
  String get serviceTimingBelt => 'Zupčasti remen';

  @override
  String get serviceCoolant => 'Rashladna tekućina';

  @override
  String get serviceTransmissionOil => 'Ulje mjenjača';

  @override
  String get serviceTireRotation => 'Rotacija guma';

  @override
  String get serviceTireSwapSeasonal => 'Sezonska zamjena guma';

  @override
  String get serviceBattery => 'Akumulator';

  @override
  String get serviceWipers => 'Metlice brisača';

  @override
  String get serviceIssue => 'Zabilježen kvar';

  @override
  String get serviceDiagnostics => 'Dijagnostika';

  @override
  String get serviceModification => 'Preinaka';

  @override
  String get serviceRegistration => 'Registracija';

  @override
  String get serviceTechnicalInspection => 'Tehnički pregled';

  @override
  String get servicePeriodicInspection => 'Periodični pregled';

  @override
  String get serviceTachographCalibration => 'Baždarenje tahografa';

  @override
  String get serviceInsurance => 'Osiguranje';

  @override
  String get serviceInsuranceComprehensive => 'Kasko osiguranje';

  @override
  String get serviceGreenCard => 'Zelena karta ističe';

  @override
  String get serviceVignette => 'Vinjeta ističe';

  @override
  String get maintenanceStateUpcoming => 'Uskoro';

  @override
  String get maintenanceStateDue => 'Dospijeva';

  @override
  String get maintenanceStateOverdue => 'Kasni';

  @override
  String get dashboardTitle => 'Pregled';

  @override
  String get plannerTitle => 'Planer';

  @override
  String get plannerRunway => 'Sljedećih 12 tjedana';

  @override
  String get plannerEmpty => 'Ništa ne dospijeva u sljedećih 12 tjedana';

  @override
  String get plannerAddReminder => 'Dodaj podsjetnik';

  @override
  String get plannerOverdueNote =>
      'Sve što kasni prikazano je pod današnjim danom jer to treba obaviti danas';

  @override
  String get plannerFurtherOut => 'Kasnije';

  @override
  String get plannerFurtherOutNote => 'Nakon dvanaest tjedana, po mjesecima.';

  @override
  String plannerWeekOf(String date) {
    return 'Tjedan od $date';
  }

  @override
  String get settingsTitle => 'Postavke';

  @override
  String get dashboardDueSoonest => 'Najbliže dospijeće';

  @override
  String dashboardNextUp(String what, String when) {
    return 'Sljedeće: $what · $when';
  }

  @override
  String dashboardOverdueNow(String what) {
    return 'Kasni: $what';
  }

  @override
  String dashboardDueByDistance(String rate) {
    return 'po kilometraži, oko $rate dnevno';
  }

  @override
  String dashboardDueByDistanceAssumed(String rate) {
    return 'po kilometraži, uz pretpostavku $rate dnevno';
  }

  @override
  String get dashboardDueByDateOnly =>
      'po datumu; nakon nekoliko tjedana vožnje pojavit će se procjena po kilometraži';

  @override
  String dashboardVehicleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vozila',
      few: '$count vozila',
      one: '$count vozilo',
    );
    return '$_temp0';
  }

  @override
  String bundleVisitOn(String date) {
    return 'Jedan odlazak u servis $date';
  }

  @override
  String bundleSpanDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana razmaka',
      few: '$days dana razmaka',
      one: '$days dan razmaka',
    );
    return '$_temp0';
  }

  @override
  String get bundleLogVisit => 'Zabilježi ovaj odlazak';

  @override
  String get bundleExcludeHint =>
      'Izbačena stavka mijenja samo prijedlog iznad: ništa se ne bilježi ni ne otkazuje.';

  @override
  String get bundlePutBack => 'Vrati';

  @override
  String get bundleOneVehicleOnly =>
      'Zabilježi zasebno za svako vozilo: ove stavke pripadaju različitim vozilima.';

  @override
  String get bundleExclude => 'Preskoči';

  @override
  String get bundleExplain =>
      'Ove stavke dospijevaju otprilike u isto vrijeme: obavi ih u jednom odlasku i uštedi si još jedan put';

  @override
  String notificationDueTitle(String service) {
    return '$service dospijeva';
  }

  @override
  String notificationBundleTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stavki dospijeva zajedno',
      few: '$count stavke dospijevaju zajedno',
      one: '$count stavka dospijeva zajedno',
    );
    return '$_temp0';
  }

  @override
  String notificationDueIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Za $count dana',
      few: 'Za $count dana',
      one: 'Za $count dan',
    );
    return '$_temp0';
  }

  @override
  String notificationDueInKm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Još $count km',
      few: 'Još $count km',
      one: 'Još $count km',
    );
    return '$_temp0';
  }

  @override
  String notificationOverdueByKm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count km preko roka',
      few: '$count km preko roka',
      one: '$count km preko roka',
    );
    return '$_temp0';
  }

  @override
  String bundleSuggestionTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Objedini $count stavki u jedan odlazak',
      few: 'Objedini $count stavke u jedan odlazak',
      one: 'Objedini $count stavku u jedan odlazak',
    );
    return '$_temp0';
  }

  @override
  String get aboutTitle => 'O aplikaciji';

  @override
  String get aboutTagline =>
      'Sva vozila u garaži na jednom mjestu: gorivo, servisi, troškovi i što sljedeće dolazi na red.';

  @override
  String aboutVersion(String version, String build) {
    return 'Verzija $version ($build)';
  }

  @override
  String get aboutPromises => 'Što aplikacija obećava';

  @override
  String get aboutPromiseFree =>
      'Oglasa nema i neće ih biti. Besplatno za malu garažu. Ono što je već zabilježeno ostaje dostupno bez plaćanja.';

  @override
  String get aboutPromiseData =>
      'Tvoji zapisi pripadaju tebi. Sve možeš izvesti u CSV kad god želiš: otvara se u bilo kojem programu za tablice.';

  @override
  String get aboutPromiseLeave =>
      'Odlazak je namjerno jednostavan. Obrišeš li račun, nestaje i tvoja garaža. Garaža koju dijeliš ostaje ostalima, s tvojim unosima, ali bez tvog imena.';

  @override
  String get aboutPromisePrivacy =>
      'Bez praćenja, bez analitike i bez profiliranja. Ono što upišeš ostaje u tvojoj garaži.';

  @override
  String get aboutPrivacyPolicy => 'Pravila privatnosti';

  @override
  String get aboutLicences => 'Licencije otvorenog koda';

  @override
  String get aboutLicencesHint => 'Biblioteke na kojima aplikacija počiva';

  @override
  String get aboutSourceCode => 'Izvorni kôd';

  @override
  String get aboutSourceCodeHint =>
      'Cijela je aplikacija otvorenog koda, pod licencijom AGPL-3.0';

  @override
  String get aboutSendFeedback => 'Pošalji povratnu informaciju';

  @override
  String get aboutSendFeedbackHint => 'Pogreška, ideja ili samo pozdrav';

  @override
  String get aboutFeedbackSubject => 'Povratna informacija za Garažu';

  @override
  String get aboutDiagnostics => 'Dijagnostika';

  @override
  String get aboutDiagnosticsHint =>
      'Nedavne pogreške, za slanje uz prijavu problema';

  @override
  String get diagnosticsTitle => 'Dijagnostika';

  @override
  String get diagnosticsEmpty => 'Na ovom uređaju ništa nije pošlo po zlu.';

  @override
  String get diagnosticsExplain =>
      'Čuva se samo na ovom uređaju. Ništa se nikamo ne šalje dok to ti ne podijeliš.';

  @override
  String get diagnosticsShare => 'Podijeli';

  @override
  String get diagnosticsClear => 'Obriši';

  @override
  String get diagnosticsCleared => 'Dijagnostika je obrisana';

  @override
  String get settingsTrackingBasicHint =>
      'Datum, kilometraža, što je obavljeno i koliko je koštalo';

  @override
  String get settingsTrackingDetailedHint =>
      'Dodaje dijelove, rad, samostalni popravak i jamstvo';

  @override
  String get settingsTrackingFullHint =>
      'Dodaje mjerenja: debljinu pločica, dubinu profila, napon';

  @override
  String settingsImportCreates(String name) {
    return 'U tvoju garažu dodat će se $name';
  }

  @override
  String get settingsImportNoVehicle =>
      'Ta sigurnosna kopija ne sadrži vozilo. Najprije dodaj vozilo, a zatim uvezi podatke u njega.';

  @override
  String get settingsImportStation => 'Benzinska postaja';

  @override
  String get settingsImportStationHint =>
      'Neobvezno: u ovoj datoteci ne piše gdje je točeno';

  @override
  String get settingsImportFuelType => 'Gorivo koje koristi';

  @override
  String get settingsExportNothing =>
      'Još nema ničega za izvoz: najprije zabilježi točenje ili servis';

  @override
  String get householdInvites => 'Kodovi pozivnica';

  @override
  String get householdInvitesHint =>
      'Svatko s kodom može se pridružiti ovoj garaži dok se kod ne iskoristi ili ne istekne';

  @override
  String householdInviteActiveUntil(String until) {
    return 'Spremno za slanje · vrijedi do $until';
  }

  @override
  String get householdInviteUsed => 'Iskorišten';

  @override
  String get householdInviteExpired => 'Istekao';

  @override
  String get householdInviteRevoke => 'Povuci';

  @override
  String get householdInviteRevokeTitle => 'Povući ovaj kod?';

  @override
  String get householdInviteRevokeBody =>
      'Tim se kodom više nitko neće moći pridružiti. Možeš napraviti novi.';

  @override
  String get householdInviteRevoked => 'Kod je povučen';

  @override
  String get householdInviteNew => 'Novi kod';

  @override
  String get householdInviteWhoFor => 'Za koga je kod?';

  @override
  String get householdInviteForDriver => 'Za vozača';

  @override
  String get householdInviteForDriverHint =>
      'Vidi samo vozilo koje mu je predano i bilježi ono što vozi';

  @override
  String get householdInviteForMember => 'Za člana';

  @override
  String get householdInviteForMemberHint =>
      'Vidi cijelu garažu: sva vozila, troškove i članove';

  @override
  String economyScale(String best, String worst) {
    return 'Najbolje $best · Najgore $worst na ovom vozilu';
  }

  @override
  String get economyScaleNone =>
      'Zabilježi nekoliko punih spremnika za usporedbu';

  @override
  String economyScaleDefault(String best, String worst) {
    return 'Prsten ide od $best do $worst dok ovaj auto ne dobije svoj raspon';
  }

  @override
  String get maintenanceLastDone => 'Posljednji put obavljeno (neobvezno)';

  @override
  String get maintenanceLastDoneHint =>
      'Ako je ovo već obavljeno, upiši kada: interval se tada računa od toga, a ne od dodavanja vozila';

  @override
  String get maintenanceLastDoneDate => 'Datum obavljanja';

  @override
  String get maintenanceLastDoneDatePick => 'Odaberi datum';

  @override
  String get maintenanceLastDoneKm => 'Kilometraža pri obavljanju';

  @override
  String maintenanceLastDoneFromLog(String date) {
    return 'Preuzeto iz servisa zabilježenog $date';
  }

  @override
  String get runningCostTitle => 'Koliko ovo vozilo košta';

  @override
  String runningCostFuelShare(String amount) {
    return 'Gorivo $amount';
  }

  @override
  String runningCostUpkeepShare(String amount) {
    return 'Održavanje $amount';
  }

  @override
  String get runningCostPerMonth => 'Mjesečno';

  @override
  String get runningCostPerYear => 'Godišnje';

  @override
  String get runningCostTotal => 'Otkad je dodano';

  @override
  String get runningCostSpread =>
      'U mjesečnim i godišnjim iznosima godišnje stavke, poput osiguranja i registracije, raspoređene su na godinu koju pokrivaju.';

  @override
  String runningCostToOwn(String rate) {
    return '$rate za držanje, s gubitkom vrijednosti';
  }

  @override
  String get runningCostValuationStale =>
      'Procjena je starija od godinu dana. Osvježi je na stranici vozila.';

  @override
  String get runningCostOwnership => 'Ukupni trošak vlasništva dosad';

  @override
  String get runningCostNotEnough =>
      'Zabilježi gorivo i troškove da vidiš koliko te vozilo stoji';

  @override
  String get runningCostNeedsTank =>
      'Još jedan pun spremnik i pojavit će se trošak po kilometru';

  @override
  String get runningCostBreakdown => 'Na što je otišlo';

  @override
  String get runningCostFuelTotal => 'Gorivo';

  @override
  String get runningCostServiceTotal => 'Servisi';

  @override
  String get runningCostOtherTotal => 'Registracija, osiguranje i ostalo';

  @override
  String get costCategoryInsuranceComprehensive => 'Kasko osiguranje';

  @override
  String get settingsDeleteData => 'Obriši sve podatke';

  @override
  String get settingsDeleteDataHint =>
      'Kreni ispočetka: briše sva vozila i sve zabilježeno uz njih. Račun i garaža ostaju.';

  @override
  String get settingsDeleteDataConfirm =>
      'Obrisati sva vozila i sva njihova točenja, servise, troškove i priloge? Ovo se ne može poništiti.';

  @override
  String get settingsDeleteDataDone => 'Svi podaci o vozilima su obrisani';

  @override
  String get quickAddFuel => 'Točenje';

  @override
  String get quickAddService => 'Servis';

  @override
  String get quickAddCost => 'Trošak';

  @override
  String get quickAddPickVehicle => 'Koje vozilo?';

  @override
  String get quickAddNew => 'Dodaj';

  @override
  String get settingsPumpAutofill => 'Popuni postaju i cijenu umjesto mene';

  @override
  String get settingsDataBringIn => 'Uvoz podataka';

  @override
  String get settingsDataTakeOut => 'Izvoz podataka';

  @override
  String get settingsForDevelopers => 'Za programere';

  @override
  String get settingsFillUps => 'Točenja';

  @override
  String get settingsPumpAutofillHint =>
      'Kad si na pumpi, prema tvojoj lokaciji prepoznaje postaju i upisuje današnju objavljenu cijenu tvog goriva. Ništa se ne šalje: lokacija se uspoređuje s cijenama koje su već na telefonu.';

  @override
  String get settingsPumpAutofillOn =>
      'Uključeno: cijena se sama popuni kad si na pumpi';

  @override
  String get settingsPumpAutofillDenied =>
      'Lokacija je isključena za Garažu. Uključi je u postavkama sustava.';

  @override
  String get settingsSampleData => 'Učitaj ogledne podatke';

  @override
  String get settingsSampleDataHint =>
      'Dodaje jedno vozilo s godinom točenja, servisa i troškova, da svaki zaslon ima što pokazati. Uklanja se preko Više → Postavke → Obriši sve podatke.';

  @override
  String get settingsSampleDataConfirmTitle => 'Učitati ogledne podatke?';

  @override
  String settingsSampleDataConfirmBody(String vehicle) {
    return 'U ovu garažu dodaje se ogledni auto ($vehicle) s godinom dana povijesti, uz ono što već imaš. Poslije ga možeš obrisati.';
  }

  @override
  String get settingsSampleDataDone => 'Ogledno vozilo je dodano';

  @override
  String get gettingStarted => 'Za početak';

  @override
  String get gettingStartedFirstVehicle => 'Dodaj prvo vozilo';

  @override
  String get gettingStartedImport => 'Uvezi iz druge aplikacije';

  @override
  String get gettingStartedTransfer => 'Preuzmi vozilo kodom';

  @override
  String get gettingStartedNext => 'Što dalje';

  @override
  String get gettingStartedFuel => 'Zabilježi točenje';

  @override
  String get gettingStartedReminder =>
      'Postavi podsjetnik: što vozilo treba i kada';

  @override
  String get gettingStartedSample =>
      'Ili najprije učitaj ogledne podatke i razgledaj';

  @override
  String get gettingStartedTour => 'Pogledaj što sve Garaža može';

  @override
  String get gettingStartedHide => 'Sakrij';

  @override
  String get featuresTitle => 'Što Garaža može';

  @override
  String get featuresHint =>
      'Kratak vodič kroz glavne mogućnosti i gdje se koja nalazi';

  @override
  String get featureAddVehicle => 'Dodaj vozilo';

  @override
  String get featureAddVehicleBlurb =>
      'Automobil, motocikl ili kombi. Upiši broj šasije, a marka, model i godina popune se same.';

  @override
  String get featureFuel => 'Dnevnik goriva';

  @override
  String get featureFuelBlurb =>
      'Točenje zabilježi u nekoliko sekundi s Pregleda. Potrošnja, cijena po kilometru i domet s punim spremnikom izračunavaju se automatski.';

  @override
  String get featurePlannerBlurb =>
      'Što kojem vozilu slijedi, tjedan po tjedan, i koje poslove vrijedi obaviti u jednom odlasku u servis.';

  @override
  String get featureTimelineBlurb =>
      'Sve što se dogodilo svakom vozilu, mjesec po mjesec, i koliko je koji mjesec stajao.';

  @override
  String get featureStatsBlurb =>
      'Potrošnja, troškovi i kilometri za bilo koje razdoblje, po vozilu ili za cijelu garažu.';

  @override
  String get featureStationsBlurb =>
      'Današnje cijene goriva u blizini i jesu li ovaj tjedan rasle ili padale.';

  @override
  String get featureTripsBlurb =>
      'Bilježi privatna i poslovna putovanja; udaljenost se računa iz kilometraže.';

  @override
  String get featureCalculatorBlurb =>
      'Trošak puta, domet ili potrošnja iz brojeva koje imaš.';

  @override
  String get featureTyres => 'Gume';

  @override
  String get featureTyresBlurb =>
      'Kompleti guma, sezonska zamjena, dubina profila i starost, na stranici svakog vozila.';

  @override
  String get featureDocuments => 'Dokumenti';

  @override
  String get featureDocumentsBlurb =>
      'Registracija, tehnički pregled, osiguranje i zelena karta, svaki dokument sa svojim rokom i podsjetnikom prije isteka.';

  @override
  String get featureReceipts => 'Računi i fakture';

  @override
  String get featureReceiptsBlurb =>
      'Nakon spremanja priloži unosu račun s pumpe ili iz servisa i pronađi ga godinama kasnije, kad prodaješ auto.';

  @override
  String get featureShare => 'Podijeli garažu';

  @override
  String get featureShareBlurb =>
      'Pozovi onoga s kim dijeliš auto. Svi vide isti dnevnik, a troškovi se dijele.';

  @override
  String get featureLend => 'Posudi auto';

  @override
  String get featureLendBlurb =>
      'Daj nekome kod i može bilježiti gorivo i vožnje na jednom autu nekoliko dana, bez ulaska u tvoju garažu i bez uvida u tvoju povijest.';

  @override
  String get featureData => 'Uvoz, izvoz i sigurnosna kopija';

  @override
  String get featureDataBlurb =>
      'Prenesi povijest iz Fuelija ili bilo kojeg CSV-a; izvezi je ili napravi sigurnosnu kopiju kad god želiš.';

  @override
  String get featureApiBlurb =>
      'Čitaj vlastite podatke iz skripte ili proračunske tablice pomoću ključa.';

  @override
  String get odometerTitle => 'Kilometraža';

  @override
  String get odometerAdd => 'Zabilježi očitanje';

  @override
  String get odometerEdit => 'Uredi očitanje';

  @override
  String get odometerReading => 'Kilometraža';

  @override
  String get odometerHint =>
      'Očitanje kilometraže bez troška, da održavanje zna koliko je vozilo prešlo.';

  @override
  String get quickAddOdometer => 'Kilometraža';

  @override
  String get statsPeriodAllTime => 'Od početka';

  @override
  String get statsPeriodLastTwelve => 'Posljednjih 12 mjeseci';

  @override
  String get statsPeriodCustom => 'Odaberi datume';

  @override
  String statsPeriodRange(String from, String to) {
    return '$from do $to';
  }

  @override
  String statsEntryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unosa',
      few: '$count unosa',
      one: '$count unos',
      zero: 'Nema unosa',
    );
    return '$_temp0';
  }

  @override
  String get statsPerDay => 'Po danu';

  @override
  String get statsPerDistance => 'Po udaljenosti';

  @override
  String get statsByKind => 'Kamo novac ide';

  @override
  String get statsByCategory => 'Po kategoriji';

  @override
  String get statsByStation => 'Troškovi po postaji';

  @override
  String get statsMonthlySpend => 'Troškovi po mjesecu';

  @override
  String get statsEconomyByStation => 'Potrošnja po postaji';

  @override
  String get statsEconomyByStationNote =>
      'Zapažanje, ne savjet: vožnja, vrijeme i godišnje doba mijenjaju potrošnju puno više nego gorivo';

  @override
  String statsEconomyTanks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spremnika',
      few: '$count spremnika',
      one: '$count spremnik',
    );
    return '$_temp0';
  }

  @override
  String get statsOdometerChart => 'Kilometraža tijekom vremena';

  @override
  String get statsFullTankRange => 'S punim spremnikom';

  @override
  String get statsFullTankTypical => 'Uobičajeno';

  @override
  String get statsFullTankBest => 'Najbolji spremnik';

  @override
  String get statsFullTankWorst => 'Najlošiji spremnik';

  @override
  String get statsFullTankSize => 'Spremnik';

  @override
  String statsFullTankTanks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Iz $count punih spremnika, od početka',
      few: 'Iz $count puna spremnika, od početka',
      one: 'Iz $count punog spremnika, od početka',
    );
    return '$_temp0';
  }

  @override
  String get statsOthers => 'Ostalo';

  @override
  String get statsUnlabelled => 'Nije zabilježeno';

  @override
  String get statsRecords => 'Najbolje i najgore';

  @override
  String get statsComparison => 'Godina i mjesec';

  @override
  String get statsSummary => 'Sažetak';

  @override
  String get statsCustomise => 'Odaberi što se prikazuje';

  @override
  String get statsCustomiseHint =>
      'Ono što ovdje isključiš samo se skriva. Ništa se ne briše.';

  @override
  String get statsShowAll => 'Prikaži sve';

  @override
  String get statsNothingShown =>
      'Sve je skriveno. U izborniku odaberi što želiš vidjeti.';

  @override
  String get tripsTitle => 'Putovanja';

  @override
  String get tripAdd => 'Zabilježi putovanje';

  @override
  String get tripEdit => 'Uredi putovanje';

  @override
  String get tripsEmpty => 'Još nema zabilježenih putovanja.';

  @override
  String get tripTitleField => 'Naziv';

  @override
  String get tripFrom => 'Od';

  @override
  String get tripTo => 'Do';

  @override
  String get tripDistance => 'Udaljenost';

  @override
  String tripImpliedSpeed(String speed) {
    return 'To bi značilo $speed: provjeri udaljenost i vrijeme';
  }

  @override
  String get tripDriver => 'Vozač';

  @override
  String get tripDriverHint =>
      'Tko je vozio: putni nalog traži ime vozača, a to nije uvijek onaj tko je upisao unos.';

  @override
  String get tripDistanceRequired =>
      'Unesi udaljenost ili kilometražu na početku i na kraju.';

  @override
  String get tripStartOdometer => 'Kilometraža na početku';

  @override
  String get tripEndOdometer => 'Kilometraža na kraju';

  @override
  String get tripOdometerOrder =>
      'Kilometraža na kraju ne može biti manja od početne.';

  @override
  String get tripMinutes => 'Minute';

  @override
  String get tripPurpose => 'Svrha';

  @override
  String get tripPurposePrivate => 'Privatno';

  @override
  String get tripPurposeBusiness => 'Poslovno';

  @override
  String get tripTotalTrips => 'Putovanja';

  @override
  String get tripTotalDistance => 'Udaljenost';

  @override
  String get tripTotalTime => 'Vrijeme';

  @override
  String get tripAverageSpeed => 'Prosječna brzina';

  @override
  String tripHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get tripDriveStart => 'Započni vožnju';

  @override
  String get tripDriveInProgress => 'Vožnja u tijeku';

  @override
  String tripDriveSince(String time) {
    return 'Polazak u $time';
  }

  @override
  String tripDriveElapsed(String duration) {
    return 'Zasad $duration';
  }

  @override
  String get tripDriveFinish => 'Završi vožnju';

  @override
  String get tripDriveDiscard => 'Odbaci';

  @override
  String get tripDriveDiscardConfirm =>
      'Odbaciti ovu vožnju? Ništa neće biti zabilježeno.';

  @override
  String get tripDriveOdometerNow => 'Kilometraža sada';

  @override
  String get tripDriveOdometerNowHint =>
      'Stanje na brojaču kilometara. Ostavi prazno ako ga ne vidiš.';

  @override
  String get tripDriveStarted => 'Vožnja je započela. Završi je kad parkiraš.';

  @override
  String tripDriveFinished(String distance) {
    return 'Vožnja je zabilježena: $distance';
  }

  @override
  String get tripDriveAlreadyOpen => 'Taj je auto već na vožnji.';

  @override
  String get tripDriveNeedsMeasure => 'Unesi kilometražu ili udaljenost.';

  @override
  String tripDriveStartedBy(String name) {
    return 'Vožnju bilježi $name';
  }

  @override
  String get incomeTitle => 'Prihod';

  @override
  String get incomeAdd => 'Dodaj prihod';

  @override
  String get incomeEdit => 'Uredi prihod';

  @override
  String get incomeAmount => 'Iznos';

  @override
  String get incomeCategory => 'Vrsta';

  @override
  String get incomeCategoryRide => 'Doprinos za vožnju';

  @override
  String get incomeCategoryTransportApp => 'Prijevoz putem aplikacije';

  @override
  String get incomeCategoryFreight => 'Prijevoz robe';

  @override
  String get incomeCategoryRefund => 'Povrat';

  @override
  String get incomeCategoryVehicleSale => 'Prodaja vozila';

  @override
  String get incomeCategoryOther => 'Ostalo';

  @override
  String get quickAddIncome => 'Prihod';

  @override
  String get quickAddMore => 'Više';

  @override
  String get statsBalance => 'Saldo';

  @override
  String get statsTabTrips => 'Putovanja';

  @override
  String get statsBusinessDistance => 'Poslovno';

  @override
  String get statsPrivateDistance => 'Privatno';

  @override
  String get statsIncomeByKind => 'Odakle novac dolazi';

  @override
  String joinSecondGarage(String current, String name) {
    return 'Već si u garaži $current. Pridruživanjem dodaješ i garažu $name pa se možeš prebacivati između njih.';
  }

  @override
  String joinFor(String name) {
    return 'Ova pozivnica vrijedi za garažu $name.';
  }

  @override
  String joinAlreadyMember(String name) {
    return 'Već si u garaži $name. Nema se čemu pridružiti.';
  }

  @override
  String get householdSwitch => 'Promijeni garažu';

  @override
  String get householdCreateAnother => 'Napravi još jednu garažu';

  @override
  String get householdYours => 'Tvoje garaže';

  @override
  String get householdCurrent => 'Trenutno prikazano';

  @override
  String get transferTitle => 'Prijenos vozila';

  @override
  String get transferCodeCancel => 'Otkaži ovaj prijenos';

  @override
  String get transferCodeCancelled =>
      'Prijenos je otkazan. Kod više ne vrijedi.';

  @override
  String get transferSellHint =>
      'Daj kupcu ovaj kod. Vozilo i cijela njegova povijest prelaze iz tvoje garaže u njegovu.';

  @override
  String get transferBought => 'Kupuješ vozilo?';

  @override
  String get transferBoughtHint => 'Unesi kod koji ti je dao prodavatelj.';

  @override
  String get transferGenerate => 'Izradi kod za prijenos';

  @override
  String get transferConfirmTitle => 'Prenijeti ovo vozilo?';

  @override
  String get transferRedeem => 'Iskoristi kod';

  @override
  String get transferCompletedTitle => 'Preneseno';

  @override
  String transferCompletedNamed(String nickname) {
    return '$nickname je sada u garaži novog vlasnika, zajedno s cijelom poviješću.';
  }

  @override
  String get transferCompleted =>
      'Preneseno vozilo sada je u garaži novog vlasnika.';

  @override
  String get transferCompletedDismiss => 'U redu';

  @override
  String get transferSell => 'Prodaješ vozilo?';

  @override
  String get transferCode => 'Kod za prijenos';

  @override
  String get transferCopied => 'Kod je kopiran';

  @override
  String get transferDone => 'Vozilo je sada u tvojoj garaži.';

  @override
  String get transferWarning =>
      'Ovo se odavde ne može poništiti; samo novi vlasnik može vratiti vozilo.';

  @override
  String get transferPhotoNote =>
      'Fotografija ostaje tebi, a sve ostalo prelazi novom vlasniku.';

  @override
  String get vehicleSecondFuel => 'Drugo gorivo';

  @override
  String get vehicleSecondFuelHint =>
      'Za vozilo na dva goriva, na primjer autoplin uz benzin. Pri svakom točenju odabereš koje je gorivo natočeno.';

  @override
  String get vehicleSecondFuelNone => 'Bez drugog goriva';

  @override
  String get vehicleKind => 'Vrsta vozila';

  @override
  String get vehicleSectionEngine => 'Motor i gorivo';

  @override
  String get vehicleSectionOptional => 'Neobvezni podaci';

  @override
  String get vehicleKindCar => 'Automobil';

  @override
  String get vehicleKindMotorcycle => 'Motocikl';

  @override
  String get vehicleKindVan => 'Kombi';

  @override
  String get vehicleFinalDrive => 'Završni prijenos';

  @override
  String get vehicleFinalDriveNotSet => 'Nije uneseno';

  @override
  String get finalDriveChain => 'Lanac';

  @override
  String get finalDriveBelt => 'Remen';

  @override
  String get finalDriveShaft => 'Kardan';

  @override
  String get vehicleTimingDrive => 'Zupčasti remen ili lanac';

  @override
  String get vehicleTimingDriveNotSet => 'Ne znam';

  @override
  String get vehicleTimingDriveHint =>
      'Remen u ulju (PureTech, EcoBoost, 1.0 TCe): remen radi u motornom ulju';

  @override
  String get timingDriveBelt => 'Remen';

  @override
  String get timingDriveChain => 'Lanac';

  @override
  String get timingDriveWetBelt => 'Remen u ulju';

  @override
  String get vehicleTransmission => 'Mjenjač';

  @override
  String get vehicleTransmissionNotSet => 'Nije uneseno';

  @override
  String get transmissionManual => 'Ručni';

  @override
  String get transmissionAutomatic => 'Automatski';

  @override
  String get transmissionDctDry => 'Dvostruka spojka, suha';

  @override
  String get transmissionDctWet => 'Dvostruka spojka, mokra';

  @override
  String get transmissionCvt => 'CVT';

  @override
  String get fuelWhichFuel => 'Gorivo';

  @override
  String get fuelCng => 'CNG';

  @override
  String get fuelEthanol => 'Etanol';

  @override
  String get fuelPetrolMidgrade => 'Benzin 95+';

  @override
  String get fuelPetrolPremium => 'Benzin 100';

  @override
  String get statsEconomyByFuel => 'Potrošnja po gorivu';

  @override
  String get csvImportTitle => 'Uvoz CSV datoteke';

  @override
  String get csvImportIntro =>
      'Iz Drivva, proračunske tablice ili bilo koje aplikacije koja izvozi tablicu. Odaberi datoteku, odredi koji je stupac što i provjeri pregled prije upisa.';

  @override
  String get csvPickFile => 'Odaberi datoteku';

  @override
  String get csvFileEmpty =>
      'Ta datoteka nema redaka koje aplikacija može pročitati.';

  @override
  String get csvWhatIsIt => 'Što je u datoteci';

  @override
  String get csvKindFuel => 'Točenja';

  @override
  String get csvKindCost => 'Troškovi';

  @override
  String get csvKindService => 'Servisi';

  @override
  String get csvKindOdometer => 'Očitanja kilometraže';

  @override
  String get csvKindTrip => 'Putovanja';

  @override
  String get csvKindIncome => 'Prihodi';

  @override
  String get csvWhichVehicle => 'Koje vozilo';

  @override
  String get csvColumns => 'Stupci';

  @override
  String get csvColumnNone => 'Nije u datoteci';

  @override
  String get csvRequired => 'obvezno';

  @override
  String get csvDayFirst => 'Datumi počinju danom (31. 12.)';

  @override
  String get csvMiles => 'Udaljenosti su u miljama';

  @override
  String get csvGallons => 'Količine su u galonima';

  @override
  String get csvPreview => 'Pregled';

  @override
  String csvReadyToImport(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count redaka spremno',
      few: '$count retka spremna',
      one: '$count redak spreman',
      zero: 'Nema što uvesti',
    );
    return '$_temp0';
  }

  @override
  String csvSkippedRows(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count redaka bit će preskočeno',
      few: '$count retka bit će preskočena',
      one: '$count redak bit će preskočen',
    );
    return '$_temp0';
  }

  @override
  String csvMissingColumn(String field) {
    return 'Odaberi stupac za $field';
  }

  @override
  String csvRowProblem(int line, String field) {
    return 'Redak $line: nije moguće pročitati polje $field';
  }

  @override
  String get csvImportAction => 'Uvezi';

  @override
  String csvImported(int written, int skipped) {
    return 'Uvezeno: $written, već postojalo: $skipped';
  }

  @override
  String get csvFieldDate => 'Datum';

  @override
  String get csvFieldOdometer => 'Kilometraža';

  @override
  String get csvFieldVolume => 'Količina';

  @override
  String get csvFieldPricePerUnit => 'Cijena po jedinici';

  @override
  String get csvFieldTotal => 'Ukupno';

  @override
  String get csvFieldFullTank => 'Pun spremnik';

  @override
  String get csvFieldStation => 'Postaja';

  @override
  String get csvFieldNotes => 'Bilješke';

  @override
  String get csvFieldAmount => 'Iznos';

  @override
  String get csvFieldCategory => 'Kategorija';

  @override
  String get csvFieldType => 'Vrsta';

  @override
  String get csvFieldCost => 'Trošak';

  @override
  String get csvFieldShop => 'Radionica';

  @override
  String get csvFieldDistance => 'Udaljenost';

  @override
  String get csvFieldTitle => 'Naziv';

  @override
  String get csvFieldFrom => 'Od';

  @override
  String get csvFieldTo => 'Do';

  @override
  String get csvFieldBusiness => 'Poslovno putovanje';

  @override
  String get csvFieldMinutes => 'Minute';

  @override
  String get settingsImportCsv => 'Uvezi CSV (bilo koja aplikacija)';

  @override
  String get settingsAutoBackup => 'Automatska sigurnosna kopija';

  @override
  String get settingsAutoBackupOff =>
      'Isključeno: odaberi mapu u koju će se kopija spremati jednom dnevno';

  @override
  String settingsAutoBackupOn(String when) {
    return 'Jednom dnevno, posljednja kopija $when';
  }

  @override
  String get settingsAutoBackupJustRan => 'Kopija je automatski spremljena';

  @override
  String get settingsAutoBackupNever => 'Jednom dnevno, još nije pokrenuto';

  @override
  String get settingsAutoBackupFailed =>
      'Posljednja kopija nije uspjela. Dodirni i ponovno odaberi mapu';

  @override
  String get settingsAutoBackupStop => 'Isključi automatsko kopiranje';

  @override
  String get settingsExportHint =>
      'ZIP s tablicama, po jedna datoteka za svaki auto i svaku vrstu. Otvara se bilo gdje; za vraćanje podataka koristi sigurnosnu kopiju.';

  @override
  String get settingsImportCsvHint =>
      'Iz Drivva, proračunske tablice ili bilo koje aplikacije koja izvozi tablicu. Dodaje ono što nedostaje, a postojeće ne mijenja.';

  @override
  String get settingsBackup => 'Napravi sigurnosnu kopiju svega';

  @override
  String get settingsBackupHint =>
      'Datoteka iz koje se podaci mogu vratiti, za razliku od CSV izvoza';

  @override
  String get settingsRestore => 'Vrati iz sigurnosne kopije';

  @override
  String get settingsRestoreHint =>
      'Dodaje ono što nedostaje. Ništa se ne briše ni ne mijenja.';

  @override
  String settingsBackupDone(String file) {
    return 'Sigurnosna kopija je spremljena: $file';
  }

  @override
  String settingsRestoreDone(int vehicles, int written, int skipped) {
    return 'Vozila: $vehicles, dodano unosa: $written, već postojalo: $skipped';
  }

  @override
  String get settingsRestoreNotABackup =>
      'Ta datoteka nije sigurnosna kopija Garaže.';

  @override
  String get stationsPickNearest => 'Najbliža';

  @override
  String get stationsPickCheapest => 'Najjeftinija';

  @override
  String get stationsPickBestValue => 'Najisplativija';

  @override
  String get stationsBestValueHint =>
      'Najjeftinija kad se uračuna gorivo za put onamo i natrag';

  @override
  String stationsGradeStations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postaja',
      few: '$count postaje',
      one: '$count postaja',
    );
    return '$_temp0';
  }

  @override
  String get commonClose => 'Zatvori';

  @override
  String get householdInviteCopyManually =>
      'Kopiraj ovu poruku i pošalji je kako želiš.';

  @override
  String get commonClear => 'Očisti';

  @override
  String get commonNext => 'Sljedeće';

  @override
  String get commonPrevious => 'Prethodno';

  @override
  String get commonIncrease => 'Povećaj';

  @override
  String get commonDecrease => 'Smanji';

  @override
  String get commonShowPassword => 'Prikaži lozinku';

  @override
  String get commonHidePassword => 'Sakrij lozinku';

  @override
  String get householdRename => 'Preimenuj garažu';

  @override
  String get householdRenamed => 'Garaža je preimenovana';

  @override
  String get householdRenameAdminOnly =>
      'Garažu može preimenovati samo administrator';

  @override
  String get householdDelete => 'Obriši garažu';

  @override
  String get householdDeleteTitle => 'Obrisati ovu garažu?';

  @override
  String get householdDeleteBody =>
      'Ovime garaža nestaje za sve u njoj, ne samo za tebe. S njom odlaze sva vozila, svi unosi i svi podsjetnici.';

  @override
  String get maintenanceLogServiceHint => 'Nešto što je obavljeno';

  @override
  String get maintenanceAddRuleHint => 'Nešto što se ponavlja';

  @override
  String get maintenanceAddChoice => 'Servis ili podsjetnik';

  @override
  String get quickAddInterval => 'Dodaj podsjetnik';

  @override
  String get settingsMore => 'Više';

  @override
  String get settingsPreferencesHint => 'Jedinice, valuta, tema i jezik';

  @override
  String get settingsDataHint => 'Uvoz, izvoz i sigurnosne kopije';

  @override
  String get timelineSearch => 'Pretraži povijest';

  @override
  String get timelineNoMatches => 'Ništa ne odgovara pretrazi.';

  @override
  String get timelineSearchCovers =>
      'Pretraživanje obuhvaća vrstu unosa, vozilo, osobu koja ga je unijela, datum i bilješke.';

  @override
  String get timelineFilterVehicle => 'Vozilo';

  @override
  String timelineBalanceNet(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transakcija, saldo $amount',
      few: '$count transakcije, saldo $amount',
      one: '$count transakcija, saldo $amount',
    );
    return '$_temp0';
  }

  @override
  String timelineBalanceSpent(String amount, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transakcija, potrošeno $amount',
      few: '$count transakcije, potrošeno $amount',
      one: '$count transakcija, potrošeno $amount',
    );
    return '$_temp0';
  }

  @override
  String timelineBalanceReceived(String amount, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transakcija, primljeno $amount',
      few: '$count transakcije, primljeno $amount',
      one: '$count transakcija, primljeno $amount',
    );
    return '$_temp0';
  }

  @override
  String get serviceBrakeDiscsFront => 'Prednji diskovi';

  @override
  String get serviceBrakeDiscsRear => 'Stražnji diskovi';

  @override
  String get serviceBrakeDrumsRear => 'Stražnji bubnjevi';

  @override
  String get serviceGlowPlugs => 'Grijači';

  @override
  String get serviceDpf => 'DPF filtar';

  @override
  String get serviceAdblue => 'Dopuna AdBluea';

  @override
  String get serviceFuelFilter => 'Filtar goriva';

  @override
  String get serviceClutch => 'Kvačilo';

  @override
  String get serviceDifferentialOil => 'Ulje diferencijala';

  @override
  String get serviceSerpentineBelt => 'Klinasti remen';

  @override
  String get serviceWaterPump => 'Vodena pumpa';

  @override
  String get serviceShockAbsorbers => 'Amortizeri';

  @override
  String get serviceWheelAlignment => 'Geometrija kotača';

  @override
  String get serviceAcService => 'Servis klime';

  @override
  String get serviceBulbs => 'Žarulje';

  @override
  String get serviceChainLube => 'Podmazivanje i zatezanje lanca';

  @override
  String get serviceChainSprockets => 'Lanac i lančanici';

  @override
  String get serviceForkOil => 'Ulje u vilici';

  @override
  String get serviceValveClearance => 'Zračnost ventila';

  @override
  String attachmentTooLarge(String size, String limit) {
    return 'Datoteka ima $size, a ograničenje je $limit. Pokušaj s manjom slikom ili PDF-om.';
  }

  @override
  String get authConfirmChecking => 'Potvrđujemo tvoju e-adresu…';

  @override
  String get authConfirmFailedTitle => 'Poveznica ne radi';

  @override
  String get authConfirmFailedBody =>
      'Poveznica za potvrdu vrijedi samo jednom i s vremenom istječe. Novu ćeš dobiti kad se prijaviš, a možeš i ponovno otvoriti račun.';

  @override
  String get authConfirmNoLink => 'Ovdje nema ničega za potvrdu.';

  @override
  String get authConfirmSignIn => 'Idi na prijavu';

  @override
  String get timelineHasNote => 'Ima bilješku';

  @override
  String get timelineHasAttachment => 'Ima prilog';

  @override
  String get timelineFilter => 'Filtriraj po vrsti';

  @override
  String get timelineFilterClear => 'Očisti filtre';

  @override
  String get settingsYourName => 'Tvoje ime';

  @override
  String get settingsNameChanged => 'Ime je promijenjeno';

  @override
  String get settingsSettlement => 'Zajednički troškovi';

  @override
  String get settingsSettlementHint =>
      'Sve zabilježeno dijeli na jednake dijelove među članovima i računa tko kome duguje. Korisno kad s nekim dijeliš auto, ali ne i novac.';

  @override
  String get settingsSettlementEnable => 'Računaj tko kome duguje';

  @override
  String tyreWindowFixed(String from, String to) {
    return 'Zimske gume od $from do $to, bez obzira na vrijeme';
  }

  @override
  String tyreWindowWhenWintry(String from, String to) {
    return 'Zimske gume od $from do $to, kad su na cesti zimski uvjeti';
  }

  @override
  String get tyreWindowSituational =>
      'Bez fiksnih datuma: zimske gume kad su na cesti zimski uvjeti';

  @override
  String get notificationSwapToWinter => 'Stavi zimske gume';

  @override
  String get notificationSwapToSummer => 'Vrijeme je za ljetne gume';

  @override
  String get guestLendTitle => 'Posudi ovaj auto';

  @override
  String get guestLendIntro =>
      'Daj nekome kod i do njegova isteka ta će osoba moći bilježiti unose za ovaj auto i ni za što drugo. Ne ulazi u tvoju garažu. Uvijek vidi podatke o samom autu, kilometražu, do kada vrijede dokumenti, otvorene probleme i gume; ostali tvoji zapisi ostaju skriveni dok to ne dopustiš.';

  @override
  String get guestLendLabel => 'Za koga je';

  @override
  String get guestLendLabelHint => 'Samo za tebe: ta osoba to ne vidi.';

  @override
  String get guestLendAllowFuel => 'Bilježenje točenja';

  @override
  String get guestLendAllowTrips => 'Bilježenje vožnji';

  @override
  String get guestLendAllowCosts => 'Bilježenje troškova i servisa';

  @override
  String get guestLendAllowHistory => 'Pregled dosadašnje povijesti auta';

  @override
  String get guestLendAllowHistoryHint =>
      'Zadano isključeno: osoba vidi samo ono što je sama zabilježila.';

  @override
  String get guestLendAction => 'Napravi kod';

  @override
  String get guestLendCreated => 'Proslijedi ovaj kod';

  @override
  String get guestLendCopy => 'Kopiraj kod';

  @override
  String get guestLendCopied => 'Kod je kopiran';

  @override
  String get guestPassesTitle => 'Posudbe';

  @override
  String get guestPassesEmpty => 'Ovaj auto još nikad nije bio posuđen.';

  @override
  String get guestPassesLive => 'U upotrebi';

  @override
  String get guestPassesWaiting => 'Još nije preuzet';

  @override
  String get guestPassesNotStarted => 'Počinje kasnije';

  @override
  String get guestPassesExpired => 'Završeno';

  @override
  String get guestPassesRevoked => 'Povučeno';

  @override
  String guestPassRemaining(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Još $days dana',
      few: 'Još $days dana',
      one: 'Još $days dan',
    );
    return '$_temp0';
  }

  @override
  String get guestPassEndsToday => 'Završava danas';

  @override
  String get guestPassRevoke => 'Povuci';

  @override
  String get guestPassRevokeConfirm =>
      'Povući ovaj kod? Osoba odmah gubi pristup, a sve što je zabilježila ostaje.';

  @override
  String get guestRedeemFailed =>
      'Taj kod ne vrijedi. Možda je istekao ili povučen, ili ga netko već koristi.';

  @override
  String get guestBorrowedBadge => 'Posuđeno tebi';

  @override
  String guestBorrowedUntil(String date) {
    return 'Tvoj do $date';
  }

  @override
  String get guestHistoryHidden =>
      'Vidiš samo vlastite zapise. Vlasnikovi raniji unosi ostaju privatni.';

  @override
  String get householdMakeAdmin => 'Učini administratorom';

  @override
  String get householdRemoveAdmin => 'Ukloni ulogu administratora';

  @override
  String householdRoleChanged(String name) {
    return '$name je sada administrator';
  }

  @override
  String householdRoleRemoved(String name) {
    return '$name više nije administrator';
  }

  @override
  String householdLastAdminKept(String name) {
    return 'Garaža uvijek mora imati administratora, pa je to sada $name.';
  }

  @override
  String get householdStepDownTitle => 'Prestati biti administrator?';

  @override
  String householdStepDownBody(String name) {
    return 'Ti si jedini administrator, pa će to sada postati $name. Samo administrator ti tu ulogu može vratiti.';
  }

  @override
  String get householdStepDown => 'Odstupi';

  @override
  String householdLeaveConfirmSuccessor(String name) {
    return 'Napustiti ovu garažu? Izgubit ćeš pristup njezinim vozilima, a $name postaje administrator.';
  }

  @override
  String get householdMergeTitle => 'Spoji drugu garažu s ovom';

  @override
  String get householdMergeIntro =>
      'Svako vozilo, cijela njegova povijest i svi iz druge garaže sele ovamo. Druga se garaža zatim briše. Ovo se ne može poništiti.';

  @override
  String get householdMergeNone => 'Nisi administrator nijedne druge garaže.';

  @override
  String get householdMergePick => 'Koja se garaža seli ovamo?';

  @override
  String get householdMergeAction => 'Spoji s ovom garažom';

  @override
  String householdMergeConfirm(
    String name,
    String survivor,
    String vehicles,
    String people,
  ) {
    return 'Preseliti sve iz garaže $name u garažu $survivor? Prelaze: $vehicles i $people. Garaža $name bit će obrisana i to se ne može poništiti.';
  }

  @override
  String householdMergeVehicleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vozila',
      few: '$count vozila',
      one: '$count vozilo',
      zero: 'nijedno vozilo',
    );
    return '$_temp0';
  }

  @override
  String householdMergePeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count osoba',
      few: '$count osobe',
      one: '$count osoba',
    );
    return '$_temp0';
  }

  @override
  String get householdMergeKeysWarning =>
      'Svi API ključevi i webhookovi druge garaže prestaju raditi.';

  @override
  String householdMergeDone(String vehicles) {
    return 'Spojeno. Preseljeno: $vehicles.';
  }

  @override
  String householdMergePhotosLost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotografija vozila nije bilo moguće premjestiti.',
      few: '$count fotografije vozila nije bilo moguće premjestiti.',
      one: 'Jednu fotografiju vozila nije bilo moguće premjestiti.',
    );
    return '$_temp0';
  }

  @override
  String householdMergeCurrencyClash(String absorbed, String surviving) {
    return 'Ove garaže vode novac u različitim valutama ($absorbed i $surviving). Uskladi ih prije spajanja jer bi inače svaki iznos promijenio značenje.';
  }

  @override
  String get syncPendingTitle => 'Čeka slanje';

  @override
  String syncPendingBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unosa čeka slanje',
      few: '$count unosa čekaju slanje',
      one: '$count unos čeka slanje',
    );
    return '$_temp0';
  }

  @override
  String get syncPendingIntro =>
      'Ovi su unosi spremljeni na telefonu dok nije bilo veze. Poslat će se sami čim veza bude dostupna.';

  @override
  String get syncPendingEmpty => 'Sve je poslano.';

  @override
  String syncStaleBanner(String when) {
    return 'Nema internetske veze. Prikazano je stanje od $when.';
  }

  @override
  String get syncRetryNow => 'Pokušaj sada';

  @override
  String get syncEntryQueued =>
      'Spremljeno na telefon. Poslat će se kad bude signala.';

  @override
  String syncSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Poslano $count unosa',
      few: 'Poslana $count unosa',
      one: 'Poslan $count unos',
    );
    return '$_temp0';
  }

  @override
  String get syncStillWaiting => 'Još uvijek nema veze. Ništa nije izgubljeno.';

  @override
  String syncDiscarded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unosa nije bilo moguće spremiti pa su uklonjeni',
      few: '$count unosa nije bilo moguće spremiti pa su uklonjeni',
      one: '$count unos nije bilo moguće spremiti pa je uklonjen',
    );
    return '$_temp0';
  }

  @override
  String get syncKindFuel => 'Točenje';

  @override
  String get syncKindOdometer => 'Očitanje kilometraže';

  @override
  String syncQueuedAt(String when) {
    return 'Upisano $when';
  }

  @override
  String get syncPhotoQueued =>
      'Fotografija je spremljena na telefon. Poslat će se kad bude signala.';

  @override
  String get syncKindAttachment => 'Fotografija';

  @override
  String get syncKindTrip => 'Vožnja';

  @override
  String get syncKindCost => 'Trošak';

  @override
  String get syncKindService => 'Servis';

  @override
  String get syncKindObservation => 'Zapažanje';

  @override
  String get syncKindIncident => 'Nezgoda';

  @override
  String get notFoundTitle => 'Ovdje nema ničega';

  @override
  String get notFoundMessage =>
      'Ova adresa ne vodi nikamo u aplikaciji. Možda je krivo upisana ili dolazi iz starije verzije.';

  @override
  String get notFoundHome => 'Otvori Pregled';

  @override
  String get observationsTitle => 'Problemi';

  @override
  String get observationsHint =>
      'Nešto primijećeno, a još neriješeno. Bilješka sebi i onome tko sljedeći radi na autu.';

  @override
  String get observationsEmpty =>
      'Ništa nije zabilježeno. Sve neobično, poput lupanja, lampice upozorenja ili zvuka nakon rupe na cesti, zabilježi ovdje.';

  @override
  String get observationAdd => 'Zabilježi problem';

  @override
  String get observationEdit => 'Uredi';

  @override
  String get observationNote => 'Što se događa';

  @override
  String get observationNoteHint => 'Lupa sprijeda dok je motor hladan';

  @override
  String get observationNoticedOn => 'Datum zapažanja';

  @override
  String get observationOdometer => 'Kilometraža';

  @override
  String get observationOpen => 'Nije riješeno';

  @override
  String get observationStillThere => 'I dalje traje nakon zahvata';

  @override
  String get observationResolved => 'Riješeno';

  @override
  String observationOpenFor(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dana',
      few: '$days dana',
      one: '$days dan',
      zero: 'primijećeno danas',
    );
    return '$_temp0';
  }

  @override
  String get observationMarkResolved => 'Prestalo je';

  @override
  String get observationReopen => 'Vratilo se';

  @override
  String get observationDelete => 'Obriši';

  @override
  String get observationDeleteConfirm =>
      'Obrisati ovu bilješku? Zapis o tome nestaje s njom.';

  @override
  String get observationSaved => 'Zabilježeno';

  @override
  String observationResolvedOn(String date) {
    return 'Prestalo $date';
  }

  @override
  String get observationAddressedNotResolved =>
      'Zahvat je obavljen, a nije potvrđeno da je prestalo.';

  @override
  String get observationOnTrip => 'Primijećeno tijekom vožnje';

  @override
  String get tripDriveNoteSomething => 'Zabilježi nešto';

  @override
  String get tripPrepTitle => 'Prije duge vožnje';

  @override
  String get tripPrepIntro =>
      'Što prema zapisima ove garaže dolazi na red tijekom puta. Ovo nije tehnički pregled i ne govori ništa o gumama, svjetlima ni kočnicama.';

  @override
  String get tripPrepDepart => 'Polazak';

  @override
  String get tripPrepReturn => 'Povratak';

  @override
  String get tripPrepReturnNone => 'Nije postavljeno';

  @override
  String get tripPrepDistance => 'Približna udaljenost';

  @override
  String get tripPrepCheck => 'Provjeri put';

  @override
  String get tripPrepDeadlines => 'Ističe dok si na putu';

  @override
  String get tripPrepForecast => 'Predviđeno dospijeće';

  @override
  String get tripPrepForecastNote =>
      'Procjena prema tome kako se auto u posljednje vrijeme vozi, a ne datum koji je netko zapisao.';

  @override
  String tripPrepKmAway(String distance) {
    return 'za otprilike $distance';
  }

  @override
  String get tripPrepAlreadyPast => 'rok je već prošao';

  @override
  String get tripPrepNothing =>
      'Prema tvojim zapisima ništa ne dolazi na red tijekom ovog puta.';

  @override
  String get tripPrepNoOdometer =>
      'Nema nedavnog očitanja kilometraže pa se ništa nije moglo usporediti s udaljenošću. Upiši ga i provjeri ponovno.';

  @override
  String get tripPrepOwnList => 'Tvoj popis';

  @override
  String get tripPrepOwnListHint =>
      'Ono čega se želiš sjetiti. Ostaje na ovom uređaju.';

  @override
  String get tripPrepAddItem => 'Dodaj stavku';

  @override
  String tripPrepExpiresOn(String date) {
    return 'ističe $date';
  }

  @override
  String get reportHandover => 'Za servisera';

  @override
  String get reportHandoverHint =>
      'Što ne valja, što dolazi na red i što je nedavno obavljeno';

  @override
  String get reportHandoverProblems => 'Što je vozač primijetio';

  @override
  String get reportHandoverStillThere =>
      'Zahvat je obavljen, ali problem nije nestao';

  @override
  String get reportHandoverComing => 'Dolazi na red';

  @override
  String get reportHandoverRecent => 'Nedavni zahvati';

  @override
  String get reportHandoverNoProblems => 'Ništa nije zabilježeno.';

  @override
  String reportHandoverNoticedOn(String date) {
    return 'primijećeno $date';
  }

  @override
  String get reportHandoverFooter =>
      'Sastavljeno iz vlasnikovih zapisa. Ovo nije pregled vozila i ne potvrđuje njegovo stanje.';

  @override
  String get routeLabel => 'Ruta';

  @override
  String get routeNoneOption => 'Bez rute';

  @override
  String get routeNewOption => 'Nova ruta…';

  @override
  String get routeNameLabel => 'Nazovi ovo putovanje';

  @override
  String get routeNameHint => 'Kuća → Posao';

  @override
  String get routeSaveFailed =>
      'Ruta nije spremljena pa vožnja nije ni pokrenuta.';

  @override
  String get tripNotComparable => 'Nije uobičajena vožnja';

  @override
  String get tripNotComparableHint =>
      'Obilazak, usputni posao, zatvorena cesta. Vožnja ostaje zabilježena, samo ne ulazi u trend rute.';

  @override
  String get routeTrendsTitle => 'Rute';

  @override
  String get routeTrendsSubtitle => 'Koliko zapravo traje put koji često voziš';

  @override
  String get routeTrendsEmpty =>
      'Još nema ruta. Imenuj jednu kad pokreneš vožnju i putovanja će se početi uspoređivati.';

  @override
  String get routeTrendNoTimed =>
      'Na ovoj ruti još nema izmjerenog vremena. Vožnja koju pokreneš i završiš u aplikaciji sama bilježi minute.';

  @override
  String routeTrendTypical(String duration) {
    return 'Obično $duration';
  }

  @override
  String routeTrendSpread(String low, String high) {
    return 'Srednjih 50 % vožnji: od $low do $high min';
  }

  @override
  String routeTrendSlower(String minutes, String label) {
    return '$minutes min sporije u odnosu na $label';
  }

  @override
  String routeTrendFaster(String minutes, String label) {
    return '$minutes min brže u odnosu na $label';
  }

  @override
  String routeTrendUnchanged(String label) {
    return 'Bez promjene u odnosu na $label';
  }

  @override
  String routeTrendSample(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count putovanja',
      few: '$count putovanja',
      one: '$count putovanje',
    );
    return '$_temp0';
  }

  @override
  String get routeTrendSparse =>
      'Neka se razdoblja temelje na vrlo malo putovanja pa promjena može biti slučajna.';

  @override
  String get routeTrendCaveat =>
      'Ovo govori što piše u tvojim zapisima, ne i zašto. Drugo vrijeme polaska, druga cesta ili drugi vozač izgledaju isto kao gužva.';

  @override
  String get routeTrendGroupMonth => 'Po mjesecu';

  @override
  String get routeTrendGroupQuarter => 'Po tromjesečju';

  @override
  String get routeTrendWeekdays => 'Samo radnim danima';

  @override
  String get routeTrendDeparture => 'Polazak';

  @override
  String get routeTrendDepartureAny => 'Bilo kada';

  @override
  String get routeTrendDepartureMorning => 'Ujutro';

  @override
  String get routeTrendDepartureMidday => 'Sredinom dana';

  @override
  String get routeTrendDepartureEvening => 'Navečer';

  @override
  String get routeTrendDriver => 'Vozač';

  @override
  String get routeTrendDriverAnyone => 'Bilo tko';

  @override
  String routeTrendExcluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count putovanja izostavljeno jer nisu uobičajene vožnje',
      few: '$count putovanja izostavljena jer nisu uobičajene vožnje',
      one: '$count putovanje izostavljeno jer nije uobičajena vožnja',
    );
    return '$_temp0';
  }

  @override
  String routeTrendNoStartTime(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count putovanja nema vrijeme polaska pa ih filtar ne može razvrstati',
      few:
          '$count putovanja nemaju vrijeme polaska pa ih filtar ne može razvrstati',
      one:
          '$count putovanje nema vrijeme polaska pa ga filtar ne može razvrstati',
    );
    return '$_temp0';
  }

  @override
  String get routeRename => 'Preimenuj rutu';

  @override
  String get routeDelete => 'Obriši rutu';

  @override
  String get routeDeleteConfirm =>
      'Obrisati ovu rutu? Putovanja ostaju, samo više neće biti svrstana pod nju.';

  @override
  String routeTrendExcludedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'i još $count putovanja',
      few: 'i još $count putovanja',
      one: 'i još $count putovanje',
    );
    return '$_temp0';
  }

  @override
  String routeTrendExcludedRun(String date, String minutes) {
    return '$date · $minutes min';
  }

  @override
  String get reportMileageTrail => 'Zabilježena kilometraža';

  @override
  String get reportMileageYear => 'Godina';

  @override
  String get reportMileageReading => 'Kilometraža';

  @override
  String get reportMileageDriven => 'Prijeđeno';

  @override
  String get reportMileageRecords => 'Zapisi';

  @override
  String get reportMileagePartialNote =>
      '* Zapisi počinju tijekom ove godine pa obuhvaćaju manje od cijele godine.';

  @override
  String get reportMileageGapNote =>
      '† Mjereno od posljednjeg očitanja prije godine bez ijednog zapisa.';

  @override
  String get reportSellersFooter =>
      'Sastavljeno iz vlasnikovih zapisa u ovoj aplikaciji. Ovo nije službena potvrda o kilometraži i ne može prikazati ono što se dogodilo izvan aplikacije.';

  @override
  String get featureRoutes => 'Rute';

  @override
  String get featureRoutesBlurb =>
      'Imenuj put koji često voziš i vidi koliko obično traje, koliko odstupa i na koliko se vožnji temelji svaki podatak.';

  @override
  String get featureObservations => 'Zapažanja';

  @override
  String get featureObservationsBlurb =>
      'Zvuk, lampica, lokva ispod auta, uz fotografiju. Ostaje otvoreno dok zvuk ne prestane, a papir koji predaješ serviseru počinje upravo time.';

  @override
  String get featureTripCheck => 'Prije duge vožnje';

  @override
  String get featureTripCheckBlurb =>
      'Što dolazi na red tijekom putovanja, prema datumima iz tvojih zapisa. Ovo nije tehnički pregled.';

  @override
  String get featureOffline => 'Radi i bez signala';

  @override
  String get featureOfflineBlurb =>
      'Točenje uneseno na pumpi ostaje na telefonu i šalje se kad bude veze. Više → Čeka slanje prikazuje što još čeka.';

  @override
  String get guestLendFrom => 'Od';

  @override
  String get guestLendUntil => 'Do';

  @override
  String get guestLendWindowBackwards => 'Kraj mora biti nakon početka.';

  @override
  String get guestLendStartsToday => 'Danas';

  @override
  String get guestLendAllowPrices => 'Prikaži cijene radova';

  @override
  String get guestLendAllowPricesHint =>
      'Isključeno: serviser vidi što je napravljeno i kada, ali ne i koliko je to plaćeno.';

  @override
  String get guestPassExtend => 'Produlji';

  @override
  String get guestPassExtendTitle => 'Do kada?';

  @override
  String guestPassExtended(String date) {
    return 'Produljeno do $date';
  }

  @override
  String guestPassWindow(String from, String to) {
    return 'Od $from do $to';
  }

  @override
  String get lentHistoryTitle => 'Što je obavljeno';

  @override
  String get lentHistoryEmpty => 'Za ovaj auto još ništa nije zabilježeno.';

  @override
  String get lentHistoryPricesHidden => 'Vlasnik nije podijelio cijene radova.';

  @override
  String odometerJumpWarning(String distance, String date) {
    return 'To je $distance od $date. Provjeri očitanje.';
  }

  @override
  String runningCostOwnSpan(String distance, String date) {
    return 'Izračunano na temelju $distance zabilježenih od $date, jer samo za to razdoblje aplikacija ima očitanja.';
  }

  @override
  String get partsTitle => 'Što ovaj auto treba';

  @override
  String get partsHint =>
      'Brojevi koje tražiš prije svakog posla: viskoznost ulja, oznaka filtra, žarulja, duljine metlica. Upišeš jednom, ostaje zauvijek.';

  @override
  String get partsEmpty =>
      'Još ništa nije zabilježeno. Kad idući put nešto potražiš, upiši to ovdje.';

  @override
  String get partsAdd => 'Dodaj što treba';

  @override
  String get partsEdit => 'Uredi';

  @override
  String get partsJob => 'Za koji posao';

  @override
  String get partsSpec => 'Što treba';

  @override
  String get partsSpecHint =>
      '5W-30 ACEA C3, W 712/95, H7 55W, 600 mm / 400 mm';

  @override
  String get partsSpecRequired => 'Upiši što treba.';

  @override
  String get partsNotes => 'Bilješke';

  @override
  String get partsDelete => 'Obriši';

  @override
  String get partsDeleteConfirm => 'Obrisati podatke za taj posao?';

  @override
  String partsOnService(String spec) {
    return 'Ovaj auto treba $spec';
  }

  @override
  String partsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count poslova zabilježeno',
      few: '$count posla zabilježena',
      one: '$count posao zabilježen',
    );
    return '$_temp0';
  }

  @override
  String get briefingOdometer => 'Kilometraža';

  @override
  String get briefingPapers => 'Dokumenti u autu';

  @override
  String get briefingProblems => 'Dobro je znati';

  @override
  String get briefingTyres => 'Gume';

  @override
  String briefingNoticedOn(String date) {
    return 'primijećeno $date';
  }

  @override
  String briefingTyresFitted(String date) {
    return 'montirane $date';
  }

  @override
  String get briefingNothing =>
      'Vlasnik još ništa nije zabilježio o ovom autu.';

  @override
  String get codeBoxAction => 'Imam kod';

  @override
  String get codeBoxTitle => 'Upiši dobiveni kod';

  @override
  String get codeBoxUnknown =>
      'Nema takvog koda. Provjeri ga i pokušaj ponovno.';

  @override
  String get codeBoxSpent => 'Taj je kod već iskorišten ili je istekao.';

  @override
  String codeBoxLending(String vehicle, String date) {
    return 'Posuđuju ti $vehicle do $date.';
  }

  @override
  String codeBoxTransfer(String vehicle) {
    return 'Vozilo $vehicle postat će tvoje, s cijelom poviješću. Odavde se to ne može poništiti.';
  }

  @override
  String codeBoxInvite(String subject) {
    return 'Pridružit ćeš se garaži $subject i dijeliti njezina vozila.';
  }

  @override
  String get codeBoxUse => 'Iskoristi kod';

  @override
  String get passEdit => 'Promijeni što dopušta';

  @override
  String get passEditNote =>
      'Promjene vrijede odmah, i za kod koji je osoba već dobila.';

  @override
  String passFinished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count završenih',
      few: '$count završena',
      one: '$count završen',
    );
    return '$_temp0';
  }

  @override
  String get guestPassesReturned => 'Vraćeno';

  @override
  String get guestReturn => 'Vrati auto';

  @override
  String get guestReturnConfirm =>
      'Vratiti ovaj auto? Tvoj pristup odmah prestaje. Sve zabilježeno ostaje uz auto.';

  @override
  String get guestReturned => 'Vraćeno. Hvala na vožnji.';

  @override
  String get csvCarScannerFound => 'Snimka iz Car Scannera';

  @override
  String csvCarScannerDrive(String distance, int minutes, String date) {
    return '$distance u $minutes min, $date';
  }

  @override
  String csvCarScannerDriveMinutes(int minutes) {
    return 'Snimljeno $minutes min';
  }

  @override
  String csvCarScannerFuel(String litres, String rate) {
    return 'Potrošeno $litres, $rate';
  }

  @override
  String get csvCarScannerParked =>
      'Na ovoj se snimci auto nije pomaknuo. To je skener ostavljen uključen u parkiranom autu, a ne vožnja.';

  @override
  String get csvCarScannerNoDistance =>
      'U ovoj snimci nema prijeđene udaljenosti. Upiši koliko je vožnja bila duga.';

  @override
  String get csvCarScannerNoDate =>
      'Iz naziva datoteke ne vidi se kada je vožnja bila pa datum treba upisati.';

  @override
  String get csvCarScannerPickDate => 'Odaberi datum';

  @override
  String get csvCarScannerImport => 'Uvezi kao vožnju';

  @override
  String get csvCarScannerImported => 'Vožnja je uvezena.';

  @override
  String get companyTitle => 'Tvrtka';

  @override
  String get companyTabDrivers => 'Vozači i vozila';

  @override
  String get companyTabSettings => 'Postavke';

  @override
  String get companyPlanActive => 'Na poslovnom planu.';

  @override
  String companyPlanUntil(String date) {
    return 'Na poslovnom planu do $date.';
  }

  @override
  String companyPlanLapsed(String date) {
    return 'Poslovni plan istekao je $date. Svi podaci ostaju, a predaja vozila vozaču, dodavanje vozača i vozila iznad besplatnih pet čekaju obnovu plana.';
  }

  @override
  String get companyPlanFree =>
      'Ova je garaža na besplatnom planu. Vozači, dodjele i konzola dolaze s poslovnim planom.';

  @override
  String get companyNotAdmin => 'Konzolu tvrtke vidi samo administrator.';

  @override
  String get companyName => 'Naziv tvrtke';

  @override
  String get companyOib => 'OIB';

  @override
  String get companyAddress => 'Adresa';

  @override
  String get companyDetailsHint =>
      'Ispisuje se u zaglavlju paketa za knjigovođu.';

  @override
  String get companyDetailsSaved => 'Podaci o tvrtki su spremljeni';

  @override
  String get companyOibInvalid => 'OIB ima jedanaest znamenki.';

  @override
  String get companyCurrentDriver => 'Vozač';

  @override
  String get companyNobody => 'Nitko';

  @override
  String companySince(String date) {
    return 'od $date';
  }

  @override
  String get companyUnconfirmed => 'još nije potvrđeno';

  @override
  String companyConfirmedOn(String date) {
    return 'potvrđeno $date';
  }

  @override
  String get companyHandOver => 'Predaj';

  @override
  String companyHandOverTitle(String vehicle) {
    return 'Predaja: $vehicle';
  }

  @override
  String get companyHandOverTo => 'Kome';

  @override
  String get companyHandOverNobody => 'Nikome: vozilo se vraća';

  @override
  String get companyHandOverOn => 'Datum';

  @override
  String get companyHandOverOdometer => 'Kilometraža pri predaji';

  @override
  String get companyHandOverNote => 'Napomena';

  @override
  String get companyHandedOver => 'Predano';

  @override
  String get companyHandOverNoDrivers =>
      'Nemaš kome predati vozilo: najprije pozovi nekoga i učini ga vozačem.';

  @override
  String get companyEarlierDrivers => 'Ranije';

  @override
  String companyAssignmentRange(String from, String name, String to) {
    return '$name: od $from do $to';
  }

  @override
  String companyAssignmentFrom(String from, String name) {
    return '$name: od $from';
  }

  @override
  String get companyRemoveAssignment => 'Ukloni iz dnevnika';

  @override
  String companyRemoveAssignmentBody(String from, String name) {
    return 'Iz dnevnika nestaje zaduženje: $name, od $from. Očitanja upisana pri predaji ostaju.';
  }

  @override
  String get companyAssignmentRemoved => 'Uklonjeno iz dnevnika';

  @override
  String get companyNoCars => 'Još nema vozila. Prvo dodaj vozilo u garažu.';

  @override
  String get householdMakeDriver => 'Učini vozačem';

  @override
  String get householdMakeMember => 'Učini članom';

  @override
  String get householdRoleDriver => 'Vozač';

  @override
  String householdNowDriver(String name) {
    return '$name je sada vozač';
  }

  @override
  String householdNowMember(String name) {
    return '$name je sada član';
  }

  @override
  String householdDriverCars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vozi $count vozila',
      few: 'Vozi $count vozila',
      one: 'Vozi $count vozilo',
      zero: 'Danas bez vozila',
    );
    return '$_temp0';
  }

  @override
  String get notificationReceiptMissingTitle => 'Nedostaje račun';

  @override
  String notificationReceiptMissingBody(String date, String vehicle) {
    return '$vehicle: unos od $date nema račun. Dodaj fotografiju.';
  }

  @override
  String get companyRemoveSignedBody =>
      'S njom se briše i vozačeva potvrda ove predaje.';

  @override
  String companyDriverOnDate(String name) {
    return 'Vozač na taj datum: $name';
  }

  @override
  String get companyNoDriverOnDate => 'Na taj datum nema dodijeljenog vozača';

  @override
  String get companyFormerDriverOnDate =>
      'Vozač na taj datum: bivši član garaže';

  @override
  String get companyMyCars => 'Moja vozila';

  @override
  String get companyDriverCarsTab => 'Auti';

  @override
  String get companyDriverNothingRecorded =>
      'Za ovo vozilo još ništa nije zabilježeno.';

  @override
  String get companyMyCarsEmpty =>
      'Danas ti nije dodijeljeno nijedno vozilo. Vozilo ti dodjeljuje administrator.';

  @override
  String get companyDriverNoticeTitle => 'Što vidi tvoj administrator';

  @override
  String get companyDriverNoticeBody =>
      'Sve što uneseš za službeno vozilo (točenja, vožnje, troškove, nezgode) vide administratori garaže, zajedno s time koje je vozilo bilo tvoje kojeg dana. Aplikacija bilježi mjesta koja upišeš, nikad gdje je telefon.';

  @override
  String get companyDriverNoticeDismiss => 'Razumijem';

  @override
  String companyConfirmHandoverTitle(String date, String vehicle) {
    return 'Vozilo $vehicle preuzeto je $date';
  }

  @override
  String get companyConfirmHandover => 'Potvrdi';

  @override
  String get companyHandoverConfirmed => 'Potvrđeno';

  @override
  String get companyTabDeadlines => 'Rokovi';

  @override
  String get companyDeadlinesThisMonth => 'Ovaj mjesec';

  @override
  String get companyDeadlinesAll => 'Sve što slijedi';

  @override
  String get companyDeadlinesEmpty => 'U ovom razdoblju ništa ne dospijeva.';

  @override
  String get companyPaidWith => 'Plaćeno';

  @override
  String get paidWithNotRecorded => 'Nije zabilježeno';

  @override
  String get paidWithCompanyCard => 'Karticom tvrtke';

  @override
  String get paidWithCompanyCash => 'Gotovinom tvrtke';

  @override
  String get paidWithOwnMoney => 'Vlastitim novcem';

  @override
  String get companyTabReimbursements => 'Povrati';

  @override
  String get companyReimbursementsEmpty => 'Nikome se ništa ne duguje.';

  @override
  String get companyReimbursementUnassigned => 'Bez vozača tih dana';

  @override
  String get companyMarkPaid => 'Označi kao isplaćeno';

  @override
  String companyMarkPaidTitle(String amount, String name) {
    return 'Označiti $amount kao isplaćeno osobi $name?';
  }

  @override
  String get companyMarkPaidBody =>
      'Unosi će se označiti kao isplaćeni s današnjim datumom. Aplikacija to ne može poništiti.';

  @override
  String get companyMarkedPaid => 'Označeno kao isplaćeno';

  @override
  String companyEntriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unosa',
      few: '$count unosa',
      one: '$count unos',
    );
    return '$_temp0';
  }

  @override
  String get incidentsTitle => 'Nezgode';

  @override
  String get incidentsHint =>
      'Ogrebotina, kazna, kvar. Tko je toga dana imao vozilo, vidi se iz dnevnika, pa se zna čija je kazna.';

  @override
  String get incidentAdd => 'Prijavi nezgodu';

  @override
  String get incidentEdit => 'Uredi';

  @override
  String get incidentKind => 'Što se dogodilo';

  @override
  String get incidentKindDamage => 'Šteta';

  @override
  String get incidentKindFault => 'Kvar';

  @override
  String get incidentKindFine => 'Kazna';

  @override
  String get incidentKindAccident => 'Nesreća';

  @override
  String get incidentHappenedOn => 'Kada';

  @override
  String get incidentOdometer => 'Kilometraža';

  @override
  String get incidentDescription => 'Što se dogodilo, tvojim riječima';

  @override
  String get incidentDescriptionHint =>
      'Ogreban stražnji branik pri parkiranju u skladištu';

  @override
  String get incidentAmount => 'Iznos';

  @override
  String get incidentAmountHint => 'Kazna, franšiza, popravak';

  @override
  String get incidentStatus => 'Stanje';

  @override
  String get incidentStatusOpen => 'Otvoreno';

  @override
  String get incidentStatusAtInsurer => 'Kod osiguranja';

  @override
  String get incidentStatusRepaired => 'Popravljeno';

  @override
  String get incidentStatusPaid => 'Plaćeno';

  @override
  String get incidentStatusClosed => 'Zatvoreno';

  @override
  String get incidentSaved => 'Nezgoda je zabilježena';

  @override
  String get incidentsEmpty => 'Ništa nije prijavljeno.';

  @override
  String get incidentClose => 'Zatvori';

  @override
  String get incidentReopen => 'Ponovno otvori';

  @override
  String get incidentDelete => 'Obriši';

  @override
  String get incidentDeleteConfirm =>
      'Obrisati ovu nezgodu? S njom odlaze i fotografije.';

  @override
  String get incidentsFilterAll => 'Sve';

  @override
  String get companyTabIncidents => 'Nezgode';

  @override
  String get reportHandoverIncidents => 'Otvorene nezgode';

  @override
  String get companyFormerMember => 'Bivši član';

  @override
  String get companyTabPack => 'Paket za knjigovođu';

  @override
  String get companyPackHint =>
      'Po jedan PDF za svako vozilo s unosima za taj mjesec i svim računima, izvorne datoteke i tablice. Sve je složeno po vozilu jer Porezna uprava tako odabire uzorke za provjeru.';

  @override
  String get companyPackMonth => 'Mjesec';

  @override
  String get companyPackBuild => 'Napravi paket';

  @override
  String companyPackSaved(String file) {
    return 'Spremljeno: $file';
  }

  @override
  String get companyPackNotSaved => 'Paket nije spremljen';

  @override
  String get companyMissingReceipts => 'Nedostaju računi';

  @override
  String get companyMissingReceiptsNone => 'Svaki unos ovog mjeseca ima račun.';

  @override
  String get companyRemindDriver => 'Podsjeti vozača';

  @override
  String companyReminderSent(String name) {
    return 'Podsjetnik je poslan: $name';
  }

  @override
  String get companyPhotoNow => 'Slikaj sada';

  @override
  String get reportAccountantPack => 'Paket za knjigovođu';

  @override
  String get reportPackLedger => 'Knjiga unosa';

  @override
  String get reportPackKind => 'Vrsta';

  @override
  String get reportPackReceipt => 'Račun';

  @override
  String get reportPackYes => 'da';

  @override
  String get reportPackNo => 'ne';

  @override
  String get reportPackTotal => 'Ukupno';

  @override
  String get reportPackReceipts => 'Računi';

  @override
  String get reportPackFooter =>
      'Sastavljeno iz zapisa garaže za prikazano razdoblje. Račun koji nije fotografija nalazi se u arhivi uz ovu datoteku.';

  @override
  String get incidentsNoneOpen => 'Nema otvorenih nezgoda.';

  @override
  String get exportDriverFilter => 'Vozač';

  @override
  String get exportDriverEveryone => 'Svi';

  @override
  String get reportTripLogPickDriver => 'Koji vozač?';

  @override
  String companyPackFetching(int done, int total) {
    return 'Dohvaćanje računa, $done od $total';
  }

  @override
  String get webUpdateReady => 'Nova verzija Garaže je spremna';

  @override
  String get webUpdateReload => 'Osvježi';

  @override
  String dateTypeHint(String example) {
    return 'Upiši datum, npr. $example';
  }

  @override
  String dateOutOfRange(String first, String last) {
    return 'Odaberi datum od $first do $last';
  }

  @override
  String get dateRangeStart => 'Početni datum';

  @override
  String get dateRangeEnd => 'Završni datum';

  @override
  String get dateFieldLabel => 'Datum';

  @override
  String get shortcutsTitle => 'Tipkovnički prečaci';

  @override
  String get shortcutsSearch => 'Pretraži ovu stranicu';

  @override
  String get shortcutsQuickAdd => 'Dodaj točenje, servis ili trošak';

  @override
  String get shortcutsHelp => 'Prikaži ovaj popis';

  @override
  String get shortcutsClose => 'Zatvori prozor ili izbornik';
}
