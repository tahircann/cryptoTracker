import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tracker_coinmarket/mai_chat_screen.dart';

void main() {
  runApp(CryptoApp());
}

class CryptoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kripto Menüsü')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // "En Çok Kazandıran Kategoriler" tuşuna basıldığında CryptoList ekranına geçiş
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CryptoListScreen()),
                );
              },
              child: Text('En Çok Kazandıran Kategoriler'),
            ),
            SizedBox(height: 20), // Butonlar arası boşluk
            ElevatedButton(
              onPressed: () {
                // Bu yeni tuşa basıldığında çalışacak ekran
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopGainersScreen()),
                );
              },
              child: Text('En Çok Kazandıran 3 Coin'),
            ),
            SizedBox(height: 20), // Butonlar arası boşluk
            ElevatedButton(
              onPressed: () {
                // "En Çok Arama Yapılan Ülkeler" tuşuna basıldığında çalışacak ekran
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopCountriesScreen()),
                );
              },
              child: Text('En Çok Arama Yapılan Ülkeler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MaiChatScreen()),
                );
              },
              child: Text('MAI ile Sohbet'),
            ),

          ],
        ),
      ),
    );
  }
}




class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  List coins = [];
  final String apiKey = 'c07f81fd-f66a-4359-911f-4bdea302c3d0';
  Map<String, int> categoryCount = {};

  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  Future<void> fetchCoins() async {
    final url =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?limit=40';

    final headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': apiKey,
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['data'];

        setState(() {
          coins = list;
        });

        await fetchCategoriesParallel(list);
      } else {
        print("Veri alınamadı: ${response.statusCode}");
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  Future<void> fetchCategoriesParallel(List list) async {
    List<Future<void>> futures = [];

    for (var coin in list) {
      futures.add(fetchCoinDetail(coin['id']));
    }

    await Future.wait(futures);
  }

  Future<void> fetchCoinDetail(int coinId) async {
    final url =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?id=$coinId';

    final headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': apiKey,
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coinDetail = data['data']['$coinId'];
        final tags = coinDetail['tags'] ?? [];

        final index = coins.indexWhere((coin) => coin['id'] == coinId);
        if (index != -1) {
          // Sadece ilk kategoriyi alıyoruz
          final category = tags.isNotEmpty ? tags[0] : "Kategori yok";
          coins[index]['tags'] = category;

          // Kategori sayısını arttırıyoruz
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;

          setState(() {});
        }
      } else {
        print("Detay alınamadı ($coinId): ${response.statusCode}");
      }
    } catch (e) {
      print("Detay çekme hatası: $e");
    }
  }

  List<MapEntry<String, int>> getTopCategories() {
    final sortedCategories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedCategories.take(3).toList();
  }

  List<Map<String, dynamic>> getTopGainers() {
    final sortedCoins = List<Map<String, dynamic>>.from(coins);
    sortedCoins.sort((a, b) {
      final changeA = a['quote']['USD']['percent_change_24h'] ?? 0;
      final changeB = b['quote']['USD']['percent_change_24h'] ?? 0;
      return changeB.compareTo(changeA); // Büyükten küçüğe sıralama
    });
    return sortedCoins.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CoinMarketCap Kripto Listesi')),
      body: coins.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // En Çok Tekrar Eden Kategoriler
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'En Çok Tekrar Eden İlk 3 Kategori:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...getTopCategories().map((category) {
              // Kategorilere en çok kazanan coinleri eklemek
              final topCoins = coins
                  .where((coin) => coin['tags'] == category.key)
                  .toList();
              topCoins.sort((a, b) {
                final changeA = a['quote']['USD']['percent_change_24h'] ?? 0;
                final changeB = b['quote']['USD']['percent_change_24h'] ?? 0;
                return changeB.compareTo(changeA); // Büyükten küçüğe sıralama
              });

              return ListTile(
                title: Text(category.key),
                subtitle: Column(
                  children: topCoins.take(3).map((coin) {
                    return ListTile(
                      title: Text(coin['name']),
                      subtitle: Text(
                        'Değişim: ${coin['quote']['USD']['percent_change_24h']}%',
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),


          ],
        ),
      ),
    );
  }
}
class TopGainersScreen extends StatelessWidget {
  final String apiKey = 'c07f81fd-f66a-4359-911f-4bdea302c3d0';

  Future<List> fetchTopGainers() async {
    final url =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?limit=40';
    final headers = {
      'Accepts': 'application/json',
      'X-CMC_PRO_API_KEY': apiKey,
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coins = data['data'];
      coins.sort((a, b) {
        final changeA = a['quote']['USD']['percent_change_24h'] ?? 0;
        final changeB = b['quote']['USD']['percent_change_24h'] ?? 0;
        return changeB.compareTo(changeA);
      });
      return coins.take(3).toList();
    } else {
      throw Exception('Veri alınamadı: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('En Çok Kazandıran 3 Coin')),
      body: FutureBuilder<List>(
        future: fetchTopGainers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final coins = snapshot.data!;
            return ListView.builder(
              itemCount: coins.length,
              itemBuilder: (context, index) {
                final coin = coins[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(coin['symbol']),
                  ),
                  title: Text(coin['name']),
                  subtitle: Text(
                    'Fiyat: \$${coin['quote']['USD']['price'].toStringAsFixed(2)}\nDeğişim: ${coin['quote']['USD']['percent_change_24h']}%',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
class TopCountriesScreen extends StatefulWidget {
  @override
  _TopCountriesScreenState createState() => _TopCountriesScreenState();
}

class _TopCountriesScreenState extends State<TopCountriesScreen> {
  List<dynamic> topCountries = [];

  Future<void> fetchTopCountries() async {
    final url = 'http://10.0.2.2:5000/top-countries?keyword=bitcoin'; // API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          topCountries = data['top_countries'];
        });
      } else {
        print("Veri alınamadı: ${response.statusCode}");
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTopCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('En Çok Arama Yapılan Ülkeler')),
      body: topCountries.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: topCountries.length,
        itemBuilder: (context, index) {
          final country = topCountries[index];
          return ListTile(
            title: Text(country['country']),
            subtitle: Text('Arama Değeri: ${country['value']}'),
          );
        },
      ),
    );
  }
}

