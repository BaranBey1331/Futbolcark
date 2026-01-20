# Futbol Kariyer Çarkı (Flutter)

Bu repo, “futbol kariyer çarkı” tarzı bir mobil oyunun çekirdek sürümüdür.
- Avrupa: 34 lig (iskelet)
- Çarklar: Lig / Takım / Sözleşme / Transfer / Kupa / Sezon
- Reyting + stat üretimi
- Piyasa değeri hesaplama
- Kaydet / Devam (SharedPreferences)

## APK Nasıl Alınır? (GitHub Actions)
1. GitHub repo -> **Actions**
2. En son **SUCCESS** olan run’a gir
3. Sayfanın altındaki **Artifacts** bölümünden:
   - `futbolcark-apks-<runNumber>` indir
4. Zip’i aç:
   - `app-arm64-v8a-debug.apk` (önerilen)
   - `app-armeabi-v7a-debug.apk` (eski cihazlar)

## Telefona Kurulum
- APK’ya dokun -> Yükle
- İlk kurulumda “Bilinmeyen kaynaklara izin ver” uyarısı gelirse:
  Ayarlar -> Güvenlik -> İzin ver

> Not: Debug APK bazen “üstüne güncellenmez”.
> En temiz test için: Eski uygulamayı kaldır -> yeni APK’yı kur.

## Oyun Akışı
- Yeni Kariyer -> Oyuncu oluştur -> Reyting Çarkı
- Kariyer ekranında statlar/piyasa görünür
- Çarklar ekranında: Lig/Takım/Sözleşme/Transfer/Kupa/Sezon

## Sonraki Plan
- Takım havuzlarını daha gerçekçi doldurma
- Kupa/transfer mantığını lig sonuç simülasyonuna bağlama
- UI’ı ekran görüntülerine birebir yaklaştırma
