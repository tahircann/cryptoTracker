
# Kripto Asistan Uygulaması

Bu uygulama, kullanıcıların kripto para piyasasını takip etmelerine, popüler coin ve haber akışlarını görüntülemelerine ve yapay zeka destekli strateji önerileri alarak tartışmalara katılmalarına olanak tanır.

## 🚀 Özellikler

- 🔄 Gerçek zamanlı kripto para fiyatları
- 📈 Popüler coin listesi
- 📰 Güncel haberler
- 🤖 Yapay zeka destekli coin stratejileri (OpenRouter ile entegre)
- 💬 AI ile sohbet tabanlı coin tartışmaları
- 🌗 Karanlık ve aydınlık tema desteği

## 🛠️ Teknolojiler

- Flutter (Frontend)
- Dart
- OpenRouter API (AI Entegrasyonu)
- REST API (Coin fiyatları ve haberler için)

## 📦 Kurulum

1. Depoyu klonlayın:
```bash
git clone https://github.com/kullaniciadi/kripto-asistan.git
cd kripto-asistan
```

2. Paketleri kurun:
```bash
flutter pub get
```

3. `.env` dosyasını oluşturun:
```
OPENROUTER_API_KEY=your_api_key
COIN_API_KEY=your_coin_data_key
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## 🧠 Yapay Zeka Özelliği

OpenRouter üzerinden GPT-4, Claude, Gemini gibi büyük dil modelleri kullanılabilir. Kullanıcı bir coin ismi girerek aşağıdaki türlerde AI çıktıları alabilir:

- Coin stratejisi (Kısa/Orta/Uzun vadeli)
- Teknik analiz özetleri
- Kullanıcıların sorularına AI yanıtları (örn: "ETH almak mantıklı mı?")
- Uyarılar ve genel piyasa analizleri

## 📁 Klasör Yapısı

```
lib/
├── main.dart
├── ui/
│   ├── home_page.dart
│   ├── coin_detail_page.dart
│   └── ai_chat_page.dart
├── services/
│   ├── coin_service.dart
│   ├── news_service.dart
│   └── openrouter_service.dart
├── models/
├── widgets/
```

## 🔐 API Anahtarları

- OpenRouter: [https://openrouter.ai](https://openrouter.ai)
- CoinGecko, CoinAPI veya Binance gibi servislerden alınabilir.

## 📝 Lisans

Bu proje MIT lisansı ile lisanslanmıştır.

---

Proje katkıları, hata bildirimleri ve öneriler için PR ve issue açabilirsiniz!
