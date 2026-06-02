import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '龍馬の日記＆AI激励アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFFF7F5F0), // 目に優しい薄い和紙のような色
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<String> _diaries = ['5月30日：今日は天気が良かったき、近所を散歩した。'];
  final TextEditingController _diaryController = TextEditingController();

  void _addDiary() {
    if (_diaryController.text.isNotEmpty) {
      setState(() {
        _diaries.insert(0, _diaryController.text);
        _diaryController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('日記を記録したぜよ！')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDiaryPage(),
      const RyomaConsultationPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? '💻 龍馬の思い出日記帳' : '⚔️ 龍馬のAI激励おはなし室',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.amber[900],
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book, size: 30),
            label: '日記を書く',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 30),
            label: '龍馬に相談',
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '今日あったことや気持ちを書き残そう',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _diaryController,
            maxLines: 4,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'ここに文字を入力してください…',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _addDiary,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text('日記を保存する', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[600],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'これまでの思い出の一コマ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _diaries.isEmpty
                ? const Center(child: Text('まだ日記がありません', style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: _diaries.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _diaries[index],
                            style: const TextStyle(fontSize: 18, height: 1.5),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class RyomaConsultationPage extends StatefulWidget {
  const RyomaConsultationPage({super.key});

  @override
  State<RyomaConsultationPage> createState() => _RyomaConsultationPageState();
}

class _RyomaConsultationPageState extends State<RyomaConsultationPage> {
  final TextEditingController _chatController = TextEditingController();
  String _ryomaResponse = 'おう、待っとったぞ！悩みがあるなら、何でもワシに言うてみぃ！日本の夜明けは近いぜよ！';
  bool _isLoading = false; // AIが考えている最中にぐるぐるを回すための合図

  // ★ここを「キーワード反応」から「本物のAI（Gemini）」に大改造しました！
  Future<void> _getRyomaAIResponse() async {
    String text = _chatController.text;
    if (text.isEmpty) return;

    // ⚠️ ここにあなたが取得した「秘密のカギ（AI StudioのAPIキー）」を貼り付けてください！
    final String _apiKey = 'AIzaSyACHZSWr14-4DpS9j2xh7DDAa3HqgvJSZ8';

    if (_apiKey == 'ここに秘密のカギを貼り付けてね') {
      setState(() {
        _ryomaResponse = '（…おっと、プログラムに「秘密のカギ」を貼り付けるのを忘れちゅうみたいぜよ！カギを貼ってからもう一度話しかけてみぃ！）';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _chatController.clear();
    });

    try {
      // AIモデルの準備
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
        // 龍馬さんになりきってもらうための設定（プロンプト）
        systemInstruction: Content.system(
          'あなたは「坂本龍馬」です。高齢者（シニア）の方の毎日の寂しさや不安、嬉しかったことなどを優しく、豪快に聞き、全力で励ますおはなし相手です。'
          '言葉遣いは必ず温かい「土佐弁」にしてください。（例：〜ぜよ、〜ちや、〜きに、おおの！、おまん、ワシなど）'
          '相手を置いてけぼりにせず、しっかりと共感し、日本の夜明けを信じたあなたらしく、どんと構えて元気づける言葉を2〜3行で返してください。'
        ),
      );

      final content = [Content.text(text)];
      final response = await model.generateContent(content);

      setState(() {
        _ryomaResponse = response.text ?? 'ちょっと風の向きが変わったようちや。もう一度話しかけてみてくれんか？';
      });
    } catch (e) {
      setState(() {
        _ryomaResponse = 'すまん、今は少し通信の調子が悪いようぜよ。時間を置いてもう一回試してみてつかあさい！';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.brown[300]!, width: 2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.brown,
                    backgroundImage: NetworkImage(
                      'https://images.imagesverse.com/historical/ryoma_sakamoto_portrait.jpg'
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '坂本龍馬',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                        const SizedBox(height: 6),
                        // AIが考えている間は、文字の代わりに「ぐるぐる」を表示します
                        _isLoading
                            ? const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.brown, strokeWidth: 3),
                                ),
                              )
                            : Text(
                                _ryomaResponse,
                                style: const TextStyle(fontSize: 18, height: 1.4, fontWeight: FontWeight.w500),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              '龍馬にメッセージを送るぜよ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _chatController,
              enabled: !_isLoading,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: '例：今日はお孫さんが来たよ、少し寂しいな',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _getRyomaAIResponse,
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text('龍馬におはなしする', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}