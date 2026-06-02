import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '日記＆激励アプリ',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 24),
        ),
      ),
      home: const MainBottomNavigation(),
    );
  }
}

// -----------------------------------------
// アプリの土台：下のボタンで画面を切り替える仕組み
// -----------------------------------------
class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

List<Map<String, String>> savedDiaries = [];

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DiaryInputScreen(),
    const DiaryHistoryScreen(),
    const ConsultationScreen(), // おはなし相談画面
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedFontSize: 16,
        unselectedFontSize: 13,
        selectedItemColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit, size: 28), label: '日記を書く'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month, size: 28), label: '振り返る'),
          BottomNavigationBarItem(icon: Icon(Icons.chat, size: 28), label: '相談する'),
        ],
      ),
    );
  }
}

// -----------------------------------------
// 画面1：日記を書く ＆ ランダム激励画面
// -----------------------------------------
class DiaryInputScreen extends StatefulWidget {
  const DiaryInputScreen({super.key});

  @override
  State<DiaryInputScreen> createState() => _DiaryInputScreenState();
}

class _DiaryInputScreenState extends State<DiaryInputScreen> {
  final TextEditingController _controller = TextEditingController();
  String _praiseMessage = '';

  final List<String> _praiseList = [
    '素晴らしい日記ですね！今日も一日、本当にお疲れ様でした。😊',
    '今日も一歩前進ですね！あなたのペースで歩む姿、とても素敵です。✨',
    '日記に書いた素敵な思い出、宝物ですね。明日も良い日になりますように。🍀',
    '今日も日記を続けられたあなたに大拍手です！素晴らしい継続力ですね！👏',
    '心温まるお話をありがとうございます。今夜はゆっくり休んでくださいね。🌙',
  ];

  void _saveDiary() {
    setState(() {
      if (_controller.text.isEmpty) {
        _praiseMessage = '一文字でも書くと、素敵な思い出になりますよ。';
      } else {
        DateTime now = DateTime.now();
        String dateStr = '${now.month}月${now.day}日';

        savedDiaries.insert(0, {
          'date': dateStr,
          'content': _controller.text,
        });

        final random = Random();
        _praiseMessage = _praiseList[random.nextInt(_praiseList.length)];
        
        _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日の日記', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('今日あったことや、嬉しかったことを\n自由に書いてみてくださいね。',
                style: TextStyle(fontSize: 20, color: Colors.black87), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                maxLines: 6,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  hintText: '例：今日は孫から電話が来て嬉しかった。',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: _saveDiary,
                icon: const Icon(Icons.check_circle, size: 30, color: Colors.white),
                label: const Text('書き終わった（保存）', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 30),
              if (_praiseMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Text(_praiseMessage, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange), textAlign: TextAlign.center),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------
// 画面2：過去の日記を振り返る画面
// -----------------------------------------
class DiaryHistoryScreen extends StatelessWidget {
  const DiaryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('思い出の記録', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Card(
              color: Colors.teal.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.teal, size: 30),
                    const SizedBox(width: 10),
                    Text(
                      '${now.year}年 ${now.month}月の日記帳',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text('これまでに書いた日記の一覧です', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 10),
            
            if (savedDiaries.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('まだ日記がありません。\n最初の１ページを書いてみましょう！',
                    style: TextStyle(fontSize: 20, color: Colors.black38), textAlign: TextAlign.center),
                ),
              ),
            
            if (savedDiaries.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: savedDiaries.length,
                  itemBuilder: (context, index) {
                    final diary = savedDiaries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(diary['date']!.split('月')[1].replaceAll('日', ''),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(diary['date']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(diary['content']!, style: const TextStyle(fontSize: 22, color: Colors.black87)),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------
// 画面3：【AI風】言葉を理解して返事をくれる相談画面
// -----------------------------------------
class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController _adviceController = TextEditingController();
  String _answerMessage = 'こんにちは！おはなし相手のくまさんです。不安なこと、眠れないこと、嬉しかったこと、何でもお話ししてくださいね。';

  void _getAdvice() {
    setState(() {
      String userInput = _adviceController.text;
      if (userInput.isEmpty) {
        _answerMessage = '何かお話ししたいことを書いてみてくださいね。いつでも聴きますよ。🐻';
        return;
      }

      // 言葉を判定する仕組み
      if (userInput.contains('眠れない') || userInput.contains('ねむれない') || userInput.contains('睡眠')) {
        _answerMessage = '夜に眠れないのは辛いですね…。温かい白湯を飲んだり、軽いストレッチをすると体がリラックスしますよ。今夜はゆっくり休めますように。';
      } else if (userInput.contains('寂しい') || userInput.contains('さびしい') || userInput.contains('一人')) {
        _answerMessage = '寂しい時はいつでも私に話しかけてください。私はずっとここにいて、あなたのお話を楽しみに待っていますよ。一人じゃないですからね。🐻';
      } else if (userInput.contains('疲れた') || userInput.contains('つかれた') || userInput.contains('しんどい')) {
        _answerMessage = '今日まで一生懸命がんばった証拠ですね。本当にお疲れ様です。今は荷物を全部おろして、のんびり美味しいものでも食べてくださいね。☕';
      } else if (userInput.contains('嬉しい') || userInput.contains('うれしい') || userInput.contains('楽し')) {
        _answerMessage = 'わぁ、それを聞いて私まで心がポカポカ嬉しくなっちゃいました！素敵な出来事を教えてくれてありがとうございます！✨';
      } else {
        _answerMessage = 'お話ししてくれてありがとうございます。あなたの言葉、しっかり届きましたよ。どんな時も私はあなたの味方ですからね。';
      }
      
      _adviceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('おはなし相談室', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple.shade400,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF9F6F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple.shade200, width: 2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.purple.shade100,
                      radius: 25,
                      child: const Text('🐻', style: TextStyle(fontSize: 30)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        _answerMessage,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              TextField(
                controller: _adviceController,
                maxLines: 4,
                style: const TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  hintText: '例：最近眠れない、寂しい、こんな嬉しいことがあった、など',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple.shade400, width: 2)),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: _getAdvice,
                icon: const Icon(Icons.favorite, size: 28, color: Colors.white),
                label: const Text('くまさんに話してみる', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}