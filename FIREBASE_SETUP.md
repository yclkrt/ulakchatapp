# FIREBASE KURULUMU (gizli bilgiler GitHub'a gitmez)
Bu repo'da gerçek Firebase key'leri YOKTUR. GitHub secret-scanning uyarısı almamak için bu yapı kuruldu.

## 1. İlk kurulum (her bilgisayarda 1 kez)

1. Firebase Console > Project Settings > General > Your apps bölümünden:
   - Android `google-services.json` dosyasını indir -> `android/app/google-services.json` olarak koy
   - iOS `GoogleService-Info.plist` dosyasını indir -> `ios/Runner/GoogleService-Info.plist` olarak koy
   - macOS için aynısını -> `macos/Runner/GoogleService-Info.plist` olarak koy
   - Alternatif: `*.example` dosyalarını kopyalayıp içini doldur:
     ```bash
     cp android/app/google-services.json.example android/app/google-services.json
     cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
     cp macos/Runner/GoogleService-Info.plist.example macos/Runner/GoogleService-Info.plist
     cp .env.example .env.local
     # sonra .env.local içini Firebase Console > Project Settings > General > Web API Key
     # Android API Key, iOS API Key ile doldur
     ```

2. `.env.local` dosyan şöyle olmalı (JSON format, `flutter run --dart-define-from-file` bunu okur):
   ```json
   {
     "FIREBASE_WEB_API_KEY": "AIza...web",
     "FIREBASE_ANDROID_API_KEY": "AIza...android",
     "FIREBASE_IOS_API_KEY": "AIza...ios"
   }
   ```

## 2. Çalıştırma

VS Code'da F5'e basman yeterli (`.vscode/launch.json` otomatik `--dart-define-from-file=.env.local` verir).

Terminalden:
```bash
flutter run --dart-define-from-file=.env.local
flutter build apk --dart-define-from-file=.env.local
flutter build ios --dart-define-from-file=.env.local
```

`.env.local` dosyası `.gitignore`'da olduğu için ASLA push'lanmaz.

## 3. Neden `lib/firebase_options.dart` içinde key yok?

Eski dosyada key'ler hardcoded'tu, GitHub 3 tane "Google API Key" alert'i verdi.
Şimdi dosya `String.fromEnvironment()` ile `--dart-define`'dan okuyor. İçinde secret yok, güvenle push'lanabilir.

`flutterfire configure` komutunu tekrar çalıştırırsan bu dosya EZİLİR ve key'ler geri gelir.
Bu komutu çalıştırdıktan sonra key'leri silip `--dart-define` yapısına geri döndür.

## 4. Eski commit'lerdeki key'ler ne oldu?

`git log` geçmişi `git-filter-repo` ile temizlendi + `git push --force` yapıldı.
AMA GitHub alert ekranındaki kopya durabilir. Yapman gereken:
1. Google Cloud Console > APIs & Services > Credentials > 3 key'i de Regenerate/Rotate et
2. Eski key'leri Delete et
3. Yeni key'leri `.env.local` + `google-services.json` + `GoogleService-Info.plist` dosyalarına yaz (sadece local)
4. GitHub > Security > Secret scanning > her alert'i "Revoked" olarak işaretle
5. Key'lere Application + API restriction koy (bkz. önceki mesaj)
