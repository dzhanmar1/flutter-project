# 💰 Kişisel Finans Takip Uygulaması

Bu proje, **Flutter** kullanılarak geliştirilmiş, modern ve "Production-ready" bir kişisel finans ve bütçe takip uygulamasıdır. 

Uygulama geliştirilirken **üçüncü parti State Management paketleri kullanılmamış**, tamamen Flutter'ın yerel (native) çözümleriyle inşa edilmiştir.

## ✨ Özellikler (Features)

* **🎨 Premium Tasarım:** Glassmorphism detayları, yumuşak gölgelendirmeler ve Google Fonts (Inter) ile modern UI/UX.
* **🧠 Native State Management:** `Bloc`, `Riverpod` veya `GetX` yok! Tüm durum yönetimi tamamen `ValueNotifier`, `ValueListenableBuilder` ve `InheritedWidget` ile sağlanmaktadır.
* **🗄️ SQLite Veritabanı:** Tüm veriler cihazda yerel ve güvenli bir şekilde `sqflite` ile saklanır (Web için `sqflite_common_ffi_web` desteği içerir).
* **📊 Özel Grafik Motoru (Native Pie Chart):** Dışa bağımlılığı sıfıra indirmek için, istatistik grafikleri tamamen `CustomPaint` kullanılarak sıfırdan yazılmıştır.
* **⚙️ Gelişmiş Fonksiyonlar:** 
  * "Swipe-to-delete" (Kaydırarak silme) özelliği.
  * Kategori yönetimi (Yeni kategori ekleme, ikon seçme, silme).
  * Tarih seçici (Date Picker) ile geçmişe dönük işlem ekleme.
  * Aylar arası geçiş ve dinamik bakiye hesaplama.
* **🌍 Dil:** Arayüz tamamen Türkçe olarak tasarlanmıştır.

## 🏗️ Mimari (Architecture)

Proje katmanlı mimariye (Separation of Concerns) sıkı sıkıya bağlıdır:
* `lib/models/`: Veri modelleri (Category, Transaction).
* `lib/database/`: SQLite veritabanı kurulumu ve sorguları.
* `lib/services/`: İş mantığı ve Uygulama Durumu (FinanceState).
* `lib/ui/screens/`: Bağımsız ekranlar (Ana Sayfa, İstatistikler, Kategoriler).
* `lib/ui/widgets/`: Tekrar kullanılabilir UI bileşenleri (Kartlar, Listeler, Grafikler).

## 🚀 Kurulum (Getting Started)

Projeyi bilgisayarınızda çalıştırmak için:

1. Repoyu klonlayın:
   ```bash
   git clone https://github.com/dzhanmar1/flutter-project.git
   ```
2. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
3. Uygulamayı çalıştırın (Örn: Chrome üzerinde):
   ```bash
   flutter run -d chrome
   ```
