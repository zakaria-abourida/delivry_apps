import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../repository/user_repository.dart' as userRepo;

class CrashlyticsService {
  static FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  static Future<void> recordNonFatalError(dynamic e, StackTrace s) async {
    await crashlytics.recordError(e, s, reason: 'non-fatal error');
  }

  static Future<void> recordFatalError(dynamic e, StackTrace s) async {
    await crashlytics.recordError(e, s, reason: 'fatal error');
  }

  static Future<void> setUser() async {
    await crashlytics.setUserIdentifier(userRepo.currentUser.value.id);
  }
}
