import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '龍馬の日記＆激励アプリ',
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
          _selectedIndex == 0 ? '💻 龍馬の思い出日記帳' : '⚔️ 龍馬の激励おはなし室',
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

  void _getRyomaResponse() {
    String text = _chatController.text;
    if (text.isEmpty) return;

    String response = '';

    if (text.contains('寂しい') || text.contains('さびしい') || text.contains('一人')) {
      response = '何をおうちゅう（何を言っているんだ）！おまん（あなた）は一人じゃきにない！ワシがいつでもここで話を聞くき、どんと構えておればえい。あったかいお茶でも飲んで、一息入れようや！';
    } else if (text.contains('疲れた') || text.contains('しんどい') || text.contains('辛い')) {
      response = '真っ直ぐに進んどる証拠ぜよ！よう頑張っちゅう、よう頑張っちゅう。今は大きなクジラになったつもりで、ゆったり横になって体を休める時ちや。明日になれば、また新しい風が吹くぜよ！';
    } else if (text.contains('眠れない') || text.contains('ねむれない') || text.contains('不安')) {
      response = '夜は静かすぎて色々考えてしまうものちや。そんな時は無理に寝ようとせんでえい！太平洋の大きな海を思い浮かべてみぃ。おまんの悩みなんて、あの海に比べたらちっぽけなものぜよ。大丈夫、明けない夜はないきに。';
    } else if (text.contains('元気') || text.contains('うれしい') || text.contains('楽しい')) {
      response = 'おおの！それはこじゃんと（とても）嬉しいのう！おまんが笑顔でおってくれるのが、ワシにとっては一番の喜びぜよ！その調子で、今日も一日を大いに楽しんでいこうや！';
    } else {
      response = 'なるほど、なるほど！おまんの気持ちは、この坂本龍馬がしっかりと受け止めたぜよ！世の人は我を何とも言わば言え、我が成す事は我のみぞ知る。一歩ずつ、自分を信じて進めばえいちや！';
    }

    setState(() {
      _ryomaResponse = response;
      _chatController.clear();
    });
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
                  // ★セキュリティの壁に邪魔されない、安心のテスト用画像リンクに変えました！
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey, // 万が一のときの背景色
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/id/1025/200/200' // 誰でも100%読み込めるテスト用の可愛い画像
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
                        Text(
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
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: '例：ちょっと寂しい、疲れたよ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _getRyomaResponse,
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