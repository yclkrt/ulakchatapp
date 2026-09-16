# FIREBASE KURULUMU (gizli bilgiler GitHub'a gitmez)

Bu repo'da gerçek Firebase key'leri YOKTUR. GitHub secret-scanning uyarısı
almamak için bu yapı kuruldu.

## Önemli not: Firebase client key'leri hakkında doğru bilgi

`AIza...` ile başlayan Firebase **client** API key'leri, Google Haritalar'daki
gizli server key'leri gibi değildir. FlutterFire'ın ürettiği
`firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`
dosyaları **uygulamayla birlikte kullanıcıya dağıtılır** (APK/IPA içinde
zaten vardır). Yani tamamen gizlemek teknik olarak mümkün değildir.

Gerçek güvenlik şunlarla sağlanır (hepsini yap):

1. **Google Cloud Console > APIs & Services > Credentials** bölümünde her
   `AIza...` key'ine:
   - **Application restriction** koy (Android: paket adı + SHA-1/SHA-256,
     iOS: bundle id, Web: HTTP referrer).
   - **API restriction** koy (sadece kullandıkların: Identity Toolkit API,
     Token Service API, gerekirse Firestore, Storage...).
2. **Firebase Console > App Check**'i aç (Android: Play Integrity,
   iOS/macOS: DeviceCheck/App Attest, Web: reCAPTCHA v3). Zorunlu yap.
3. **Firestore / Storage Security Rules**'u `allow read, write: if true;`
   bırakma. Örnek `firestore.rules.example` dosyasına bak.
4. Sızan key'leri **Rotate/Regenerate + Delete** et (aşağıda 4. adım).

Bu repo'daki `--dart-define` yapısı, key'lerin GitHub geçmişinde ve
aramalarda görünmesini engeller + yanlışlıkla server secret'ı commit'lemeyi
önler. Asıl korumayı yukarıdaki 4 madde sağlar.

## 1. İlk kurulum (her bilgisayarda 1 kez)

Firebase Console > Project Settings > General > Your apps bölümünden:

- Android `google-services.json` dosyasını indir →
  `android/app/google-services.json` olarak koy
- iOS `GoogleService-Info.plist` dosyasını indir →
  `ios/Runner/GoogleService-Info.plist` olarak koy
- macOS için aynısını → `macos/Runner/GoogleService-Info.plist` olarak koy
- Alternatif: `*.example` dosyalarını kopyalayıp içini doldur:

```bash
cp android/app/google-services.json.example android/app/google-services.json
cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
cp macos/Runner/GoogleService-Info.plist.example macos/Runner/GoogleService-Info.plist
cp .env.example .env.local
# sonra .env.local içini Firebase Console > Project Settings > General
# Web API Key, Android API Key, iOS API Key ile doldur
```

`.env.local` dosyan şöyle olmalı (JSON format,
`flutter run --dart-define-from-file` bunu okur):

```json
{
  "FIREBASE_WEB_API_KEY": "AIza...web",
  "FIREBASE_ANDROID_API_KEY": "AIza...android",
  "FIREBASE_IOS_API_KEY": "AIza...ios"
}
```

## 2. Çalıştırma

VS Code'da F5'e basman yeterli
(`.vscode/launch.json` otomatik `--dart-define-from-file=.env.local` verir).

Terminalden:

```bash
flutter run --dart-define-from-file=.env.local
flutter build apk --dart-define-from-file=.env.local
flutter build ios --dart-define-from-file=.env.local
```

`.env.local` dosyası `.gitignore`'da olduğu için ASLA push'lanmaz.

## 2b. App Check kurulumu (Firebase Console'da 10 dakika)

Kod tarafı hazır (`firebase_app_check` paketi + `main.dart` içinde
`_activateAppCheck()`). Şimdi Console tarafını yap:

### Adım 1 — Sağlayıcıları kaydet (uygulama başına 1 kez)

Firebase Console → **App Check** sayfasına git:

| Platform | Apps sekmesinde uygulamayı seç → sağlayıcı |
|---|---|
| Android (`com.example.ulakchatapp`) | **Play Integrity** |
| iOS (`com.example.ulakchatapp`) | **App Attest** (desteklenmeyen cihazlar için **DeviceCheck** fallback kodda hazır) |
| macOS | **DeviceCheck** |
| Web (kullanıyorsan) | **reCAPTCHA v3** → sana bir **site key** verir, onu `.env.local` içine `APP_CHECK_WEB_SITE_KEY` olarak yaz (secret değil, sitede görünür) |

### Adım 2 — Debug token (kendi cihazında/emülatörde test için)

Gerçek cihaz doğrulaması (Play Integrity / App Attest) emülatörde ve
debug build'de ÇALIŞMAZ. Bu yüzden:

1. Uygulamayı bir kez `--dart-define-from-file=.env.local` ile çalıştır,
   log'larda şuna benzer bir satır görürsün
   (debug provider otomatik bir secret üretir).
2. Firebase Console → **App Check → Apps → senin uygulaman → overflow menü
   (⋮) → Manage debug tokens → Add debug token** → log'daki değeri yapıştır.
3. O değeri `.env.local` içine `APP_CHECK_DEBUG_TOKEN` olarak da yaz
   (`.env.example`'da alanı hazır). Artık debug çalışmalarda App Check
   doğrulanır.

Windows'ta debug token ZORUNLUDUR (başka provider yok) — aynı adımla ekle.

### Adım 3 — Zorunlu yap (enforcement)

Her şey çalışıyor, login/register sorunsuz ise:

Firebase Console → **App Check → APIs** (veya ilgili ürün: Auth,
Firestore, Storage) → **Enforce**'u aç.

ÖNEMLİ: Enforcement'ı açmadan önce debug token'ını eklediğinden emin ol,
yoksa kendi debug build'in bile reddedilir. Önce monitor modda
(request sayıları App Check konsolunda görünür), sonra enforce.

### Adım 4 — Sahte istemci testi

- Yanlış/eksik token ile istek atan bir istemci → `401 / permission-denied`.
- Enforcement kapalıyken metrikleri izle: **App Check → Metrics**.
- Release build'de log'larda `✅ App Check (Android Play Integrity) aktif.`
  gibi satırları görmelisin.

## 3. Neden `lib/firebase_options.dart` içinde key yok?

Eski dosyada key'ler hardcoded'tu, GitHub 3 tane "Google API Key" alert'i verdi.
Şimdi dosya `String.fromEnvironment()` ile `--dart-define`'dan okuyor.
İçinde secret yok, güvenle push'lanabilir.

`flutterfire configure` komutunu tekrar çalıştırırsan bu dosya EZİLİR ve
key'ler geri gelir. Bu komutu çalıştırdıktan sonra key'leri silip
`--dart-define` yapısına geri döndür (veya bu dosyayı geri al:
`git checkout -- lib/firebase_options.dart` demeden önce yedekle).

## 4. Sızan 3 key için yapılması gerekenler (sen yapacaksın, terminal değil)

1. Google Cloud Console > APIs & Services > Credentials >
   3 key'i de **Regenerate/Rotate** et (ya da silip yeniden oluştur).
2. Eski key'leri **Delete** et.
3. Yeni key'leri `.env.local` + `google-services.json` +
   `GoogleService-Info.plist` dosyalarına yaz (sadece local, push yok).
4. GitHub > Security > Secret scanning > her alert'i "Revoked" olarak işaretle.
5. Key'lere Application + API restriction koy (yukarıdaki nota bak).
6. Geçmişi temizle: `git log`'da eski key'ler durduğu sürece alert kapanmaz.
   Bunun için geçmişi temizlemen gerekir (aşağıya bak).

## 5. Git geçmişini temizleme (alert'lerin kapanması için şart)

Uyarı: Geçmişi yeniden yazar, `push --force` gerektirir. Başkası bu repo'yu
clone'ladıysa onu da etkiler. Tek başına çalışıyorsan sorun yok.

```bash
# 1) Önce bu düzeltme commit'ini push'la (aşağıdaki "6. adım"daki gibi)
# 2) Geçmişten secret'ları sil:
pip install git-filter-repo
cd /Users/yclkrt/Documents/GitHub/ulakchatapp
git filter-repo --path lib/firebase_options.dart \
  --path android/app/google-services.json \
  --path ios/Runner/GoogleService-Info.plist \
  --path macos/Runner/GoogleService-Info.plist \
  --invert-paths --force

# 3) Remote'u geri ekle (filter-repo remote'u siler):
git remote add origin https://github.com/yclkrt/ulakchatapp.git

# 4) Force push:
git push --force --set-upstream origin main
```

Alternatif (daha seçici, sadece key string'lerini silir — gerçek key'leri
bu dosyaya ASLA yazmayın, aşağıdaki komut eski commit'lerden otomatik bulur):

```bash
# Eski commit'lerdeki gerçek key'leri otomatik çıkarıp replace listesi yap:
cd /Users/yclkrt/Documents/GitHub/ulakchatapp
git log -p --all -S 'AIza' -- lib/firebase_options.dart \
  android/app/google-services.json \
  | grep -oE 'AIza[0-9A-Za-z_-]{35}' | sort -u > /tmp/leaked_keys.txt
# Kontrol et (ekranda görünecek, bu dosyayı commit'LEME):
cat /tmp/leaked_keys.txt
awk '{print $1"==>***REMOVED***"}' /tmp/leaked_keys.txt > /tmp/replace.txt
git filter-repo --replace-text /tmp/replace.txt --force
git remote add origin https://github.com/yclkrt/ulakchatapp.git
git push --force --set-upstream origin main
# İşin bitince geçici dosyaları sil:
rm /tmp/leaked_keys.txt /tmp/replace.txt
```

Bundan sonra GitHub'daki 3 alert kendiliğinden "fixed" olur veya sen
"Revoked" işaretlersin.

## 6. Bundan sonra her commit'ten önce

`scripts/pre-commit` otomatik kontrol eder (`AIza...` yakalarsa commit'i
durdurur). Kurulum:

```bash
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```
