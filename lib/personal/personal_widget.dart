import 'package:flutter/material.dart';

class PersonalWidget extends StatelessWidget {
  const PersonalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black, // Xのダークモード風にする場合
      body: CustomScrollView(
        slivers: [
          // 1. プロフィールヘッダーエリア（ヘッダー画像 + アバター + 編集ボタン）
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none, // アイコンが画像からはみ出るのを許可
                  children: [
                    // ヘッダー背景画像
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Image.asset(
                        'images/skytree.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 丸形プロフィールアイコン（画像の下辺にまたがる位置）
                    Positioned(
                      left: 16,
                      bottom: -40, // 半分だけ下にはみ出させる
                      child: Container(
                        padding: const EdgeInsets.all(4), // 白（黒）の縁取り枠
                        decoration: const BoxDecoration(
                          color: Colors.black, // 背景色と合わせる
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 40, // アイコンサイズ
                          backgroundImage: AssetImage('images/junichi.jpg'), // プロフィール画像
                        ),
                      ),
                    ),
                    // 右上の「プロフィールを編集」ボタン
                    Positioned(
                      right: 16,
                      bottom: -45,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text(
                          'プロフィールを編集',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // アイコンが食い込んだ分だけ下に余白を確保
                const SizedBox(height: 50),
                
                // 2. ユーザー情報テキストエリア
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text(
                            'Jboy(AI × Mobile Developer)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.verified, color: Colors.blue, size: 20),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        '@JBOY83062526',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'AI-native Mobile Developer 🤖📱\nBuilding the next generation of mobile apps powered by AI.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 3. タイムライン（リスト）部分
          SliverList.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: index.isOdd ? Colors.grey[900] : Colors.black,
                height: 100.0,
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}