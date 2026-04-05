# Flutter App TODO - Zan Local Store

## Current Status: Fixing compilation errors to run app

**Steps to complete (BLACKBOXAI plan):**
- [x] 1. Add `permission_handler` to pubspec.yaml
- [x] 2. Update Android package name in android/app/build.gradle.kts (already com.zanlocaltour.appstore)
- [x] 3. Run `flutter clean && flutter pub get`
- [x] 4. Run `cd android && gradlew.bat clean && cd ..` (Windows)
- [ ] 5. Test `flutter run -d windows` or `flutter run -d chrome`
- [ ] 6. Test on Android phone (USB debugging)
- [x] Firebase setup (google-services.json, firebase_options.dart, main.dart update)

**Original Firebase TODO:**
- [x] Create `android/app/google-services.json` 
- [x] Create `lib/firebase_options.dart`
- [ ] Update `android/app/build.gradle.kts` package → com.zanlocaltour.appstore
- [x] Update `lib/main.dart` Firebase
- [x] Run clean/pub get/gradle clean
- [ ] Test run

**Next:** Test app functionality after fixes.

