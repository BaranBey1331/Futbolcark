# Futbol Çark (Kotlin + Jetpack Compose) — V0.1 Alpha (0001)

Bu proje Flutter yerine **tamamen native Android** (Kotlin + Jetpack Compose) ile yazıldı.  
Oyun mantığı: **çark çevirme** (weighted/olasılıklı), sonuç ekranı, ve kariyer başlangıç akışı.

## Proje Yapısı

- `app/src/main/java/com/baran/futbolcark/`
  - `screens/` : ekranlar (Kariyer, Oyuncu Oluştur, Çark, vb.)
  - `ui/` : ortak UI bileşenleri + çark çizimi
  - `game/` : çark konfigürasyonları ve weighted seçim motoru
  - `data/` : DataStore (kariyer kaydı)
  - `models/` : veri modelleri
  - `viewmodel/` : state + kayıt

## Çalıştırma (Android Studio)

1. ZIP'i çıkar
2. Android Studio → **Open** → `FutbolcarkCompose` klasörünü seç
3. Gradle sync bitince:
   - `Run` (▶) ile cihazda çalıştır

> Min SDK: 21 (Android 5.0) — Compose gereği.

## GitHub Actions ile APK Alma

Repo içine bu projeyi koy ve Actions sekmesinden çalıştır:

- Workflow: `.github/workflows/android.yml`
- Çıktı: `apks-debug` artifact içinde **ABI split** APK'lar:
  - `app-armeabi-v7a-debug.apk`
  - `app-arm64-v8a-debug.apk`

Telefonun mimarisine uygun olanı kur:
- Çoğu yeni cihaz: **arm64-v8a**
- Eski cihazlar: **armeabi-v7a**

## Oyun Akışı

1. **Kariyer** sekmesi → “Yeni Kariyer”
2. Oyuncu bilgilerini gir → “İlerle”
3. Çark akışı:
   - Başlangıç Reytingi → Takım → Sözleşme Süresi
4. Sonunda kariyer kaydı oluşur ve profil ekranına dönersin.

## Notlar

- Bu sürüm “alpha” ve iskelet amaçlıdır.
- İleride:
  - lig/istatistik ekranları videodaki gibi genişletilecek,
  - daha fazla çark türü ve sezon akışı eklenecek.
