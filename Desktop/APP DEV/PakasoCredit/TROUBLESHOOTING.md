# 🔧 Pakaso Credit - Build & Troubleshooting Guide

**Generated:** May 19, 2026  
**Project:** Pakaso Credit v1.0.4  
**Status:** Production Ready

---

## 🎯 Quick Start Commands

### Clean Build (Recommended First Step)
```bash
cd "C:\Users\FRAEZYL\Desktop\APP DEV\PakasoCredit"
flutter clean
flutter pub get
flutter build apk --release
```

### If Build Fails - Recovery Steps
```bash
# 1. Kill Java processes
taskkill /F /IM java.exe

# 2. Clean Gradle cache
rm -r android\.gradle
rm -r android\app\build

# 3. Run flutter operations
flutter clean
flutter pub get

# 4. Retry build
flutter build apk --release
```

---

## 🐛 Common Build Errors & Solutions

### Error 1: "Timeout waiting to lock build logic queue"
**Cause:** Multiple Gradle instances running  
**Solution:**
```bash
# Kill all Java processes
taskkill /F /IM java.exe

# Wait 10 seconds, then retry
flutter build apk --release
```

### Error 2: "Could not find method implementation()"
**Cause:** Gradle version mismatch  
**Solution:**
```bash
# Current Gradle version: 8.6.0 (compatible)
# Update android/settings.gradle.kts if needed
# Verify: id("com.android.application") version "8.7.0"
```

### Error 3: "firebaseMessagingBackgroundHandler not found"
**Cause:** Firebase options not configured  
**Solution:**
```bash
# Regenerate Firebase configs
# 1. Go to Firebase Console
# 2. Download google-services.json
# 3. Place in android/app/
# 4. Rebuild
flutter build apk --release
```

### Error 4: "Unsupported class-file format"
**Cause:** Java version mismatch  
**Solution:**
```gradle
// In android/app/build.gradle.kts, verify:
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11  // ✓ Correct
    targetCompatibility = JavaVersion.VERSION_11
    isCoreLibraryDesugaringEnabled = true
}
```

### Error 5: "cannot find symbol class R"
**Cause:** Resource compilation issue  
**Solution:**
```bash
# Clean resources
flutter clean
rm -r android\app\build
rm -r android\.gradle

# Rebuild
flutter pub get
flutter build apk --release
```

### Error 6: "Plugin not found"
**Cause:** Plugin not installed properly  
**Solution:**
```bash
# Force reinstall plugins
flutter clean
flutter pub get
flutter pub upgrade

# Then rebuild
flutter build apk --release
```

### Error 7: "Package name mismatch"
**Cause:** Old package name in configs  
**Solution:** Verify all files updated:
```bash
# Check package names are com.pakasocredit.app
grep -r "com.pakasocredit.app" android/

# Check no old references remain
grep -r "com.digi_bank.user" android/  # Should return nothing
```

---

## 📊 Build Performance Optimization

### Gradle Performance Tuning

**File:** `android/gradle.properties`
```properties
# Current settings (optimized for 8GB RAM)
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError

# For 4GB RAM computers:
org.gradle.jvmargs=-Xmx4G

# For high-performance builds:
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.workers.max=8
```

### Build Speed Tips
1. **Enable Gradle parallel builds:**
   ```properties
   org.gradle.parallel=true
   ```

2. **Use build cache:**
   ```properties
   org.gradle.caching=true
   ```

3. **Skip tests for debug builds:**
   ```bash
   flutter build apk --release --no-tests
   ```

4. **Use incremental builds:**
   - Don't use `flutter clean` unless necessary
   - Use `flutter build apk --release` for incremental builds

---

## 📱 Android Configuration Reference

### current Settings
```kotlin
// android/app/build.gradle.kts

namespace = "com.pakasocredit.app"
applicationId = "com.pakasocredit.app"
compileSdk = 34  // Latest via flutter.compileSdkVersion
minSdk = 21      // Android 5.0+
targetSdk = 34   // Latest via flutter.targetSdkVersion
versionCode = 1
versionName = "1.0.4"

// Kotlin
kotlinOptions {
    jvmTarget = "11"
}

// Java
compileOptions {
    sourceCompatibility = VERSION_11
    targetCompatibility = VERSION_11
    isCoreLibraryDesugaringEnabled = true
}

// NDK
ndkVersion = "27.0.12077973"
```

### Dependencies
```kotlin
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

---

## 🍎 iOS Configuration Reference

### Current Settings
```xml
<!-- ios/Runner/Info.plist -->

<key>CFBundleName</key>
<string>Pakaso Credit</string>

<key>CFBundleDisplayName</key>
<string>Pakaso Credit</string>

<key>CFBundleShortVersionString</key>
<string>1.0.4</string>

<key>CFBundleVersion</key>
<string>1</string>

<!-- Deployment Target -->
<key>LSRequiresIPhoneOS</key>
<true/>

<!-- Permissions -->
<key>NSFaceIDUsageDescription</key>
<string>Why is my app authenticating using face id?</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Allow access to photo library to select photos</string>

<key>NSCameraUsageDescription</key>
<string>Allow access to camera to take photos</string>

<key>NSMicrophoneUsageDescription</key>
<string>Allow access to microphone for video recording</string>

<!-- Background Modes -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### iOS Deployment Target
```
IPHONEOS_DEPLOYMENT_TARGET = 12.0  // ✓ Correct
```

---

## 🔐 Security Checklist

### App Security
- [x] API uses HTTPS (`https://pakasocredit.com/api`)
- [x] Bearer token authentication implemented
- [x] Token stored in secure storage (SharedPreferences)
- [x] No hardcoded secrets in code
- [x] Null safety enabled (type-safe)
- [x] Input validation present
- [x] Error messages don't expose secrets

### Firebase Security
- [ ] Firestore rules configured (if using)
- [ ] Firebase Auth enabled
- [ ] No public access to data
- [ ] Firebase Messaging properly configured

### Android Security
- [x] Manifest permissions specified
- [x] Biometric permission added
- [x] Camera permission added
- [x] Storage permissions configured
- [x] INTERNET permission required

### iOS Security
- [x] Face ID usage description added
- [x] Photo library access justified
- [x] Camera access justified
- [x] Microphone access justified

---

## 📈 Build Output Locations

### After Build Completion

**APK (for testing):**
```
build/app/outputs/flutter-apk/app-release.apk
Size: ~50-80 MB (typical)
```

**App Bundle (for Play Store):**
```
build/app/outputs/bundle/release/app-release.aab
Size: ~30-50 MB (optimized with split APKs)
```

**iOS Archive:**
```
build/ios/archive/Runner.xcarchive/
```

**Debug Info:**
```
build/app/intermediates/flutter/debug/
```

---

## ✅ Verification Checklist After Build

Once build completes, verify:

- [ ] APK exists at `build/app/outputs/flutter-apk/app-release.apk`
- [ ] APK size is reasonable (50-100 MB)
- [ ] App Bundle exists at `build/app/outputs/bundle/release/app-release.aab`
- [ ] No build warnings in output
- [ ] All dependencies resolved
- [ ] Kotlin compilation successful
- [ ] Resources compiled successfully
- [ ] APK signed correctly

---

## 🚀 Next Steps After Successful Build

1. **Test on Android Device:**
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Test on iOS Device:**
   - Build in Xcode from Archive
   - Test on physical device

3. **Version & Deploy:**
   - Tag release in Git
   - Upload to Play Store
   - Submit to App Store

4. **Monitor:**
   - Track crashes in Firebase Crashlytics
   - Monitor analytics
   - Respond to user feedback

---

## 📚 Reference Links

### Documentation
- [Flutter Build Release](https://flutter.dev/docs/deployment/android)
- [Gradle User Guide](https://docs.gradle.org/current/userguide/userguide.html)
- [Android Developers](https://developer.android.com/)
- [Apple Developer](https://developer.apple.com/)

### Tools
- [Gradle Wrapper](https://gradle.org/releases/)
- [Android Studio SDK Manager](https://developer.android.com/studio)
- [Xcode](https://developer.apple.com/xcode/)

---

## 💬 Support Resources

### If Build Still Fails

1. **Check Flutter Doctor:**
   ```bash
   flutter doctor -v
   ```

2. **Check Java Version:**
   ```bash
   java -version
   ```

3. **Check Gradle Version:**
   ```bash
   cd android && gradle --version
   ```

4. **Review Build Output:**
   ```bash
   flutter build apk --release --verbose
   ```

5. **Check Stack Trace:**
   ```bash
   flutter build apk --release --stacktrace
   ```

---

## 📝 Version History

### v1.0.4 (Current - May 19, 2026)
- ✅ Rebranded to "Pakaso Credit"
- ✅ Updated package name to com.pakasocredit.app
- ✅ Updated API base URL
- ✅ All configurations optimized
- ✅ Production ready

---

**End of Troubleshooting Guide**

*For more help, check the main PRODUCTION_GUIDE.md file.*

