import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuranCompanionApp());
}

class QuranCompanionApp extends StatefulWidget {
  const QuranCompanionApp({Key? key}) : super(key: key);

  @override
  State<QuranCompanionApp> createState() => _QuranCompanionAppState();
}

class _QuranCompanionAppState extends State<QuranCompanionApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رفيق القرآن',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: AppShell(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class AppTheme {
  static const Color seed = Color(0xFF16745B);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'sans',
      scaffoldBackgroundColor: brightness == Brightness.light ? const Color(0xFFF7F9F6) : const Color(0xFF101512),
      appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0),
      cardTheme: CardTheme(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(22))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18)), borderSide: BorderSide.none),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({Key? key, required this.isDarkMode, required this.onThemeChanged}) : super(key: key);

  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomePage(),
      const QuranPage(),
      const SavedPage(),
      SettingsPage(isDarkMode: widget.isDarkMode, onThemeChanged: widget.onThemeChanged),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(index: _index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'المصحف'),
            NavigationDestination(icon: Icon(Icons.bookmark_outline_rounded), selectedIcon: Icon(Icons.bookmark_rounded), label: 'المحفوظات'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const <Widget>[
                Text('السلام عليكم', style: TextStyle(fontSize: 15)),
                SizedBox(height: 4),
                Text('رفيقك مع القرآن', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              ])),
              const CircleAvatar(backgroundColor: Color(0xFFDCEFE6), child: Icon(Icons.person_outline_rounded, color: AppTheme.seed)),
            ]),
            const SizedBox(height: 24),
            SoftCard(
              color: scheme.primary,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Row(children: <Widget>[Icon(Icons.auto_awesome_rounded, color: scheme.onPrimary), const SizedBox(width: 8), Text('مواصلة الورد', style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700))]),
                const SizedBox(height: 18),
                Text('سورة الفاتحة', style: TextStyle(color: scheme.onPrimary, fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('الآية ٣ من ٧', style: TextStyle(color: scheme.onPrimary.withOpacity(.75))),
                const SizedBox(height: 16),
                ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: .43, minHeight: 8, backgroundColor: scheme.onPrimary.withOpacity(.18), color: scheme.onPrimary)),
                const SizedBox(height: 16),
                FilledButton.tonal(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ReaderPage(surahName: 'الفاتحة'))), child: const Text('متابعة القراءة')),
              ]),
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'اختصارات سريعة'),
            const SizedBox(height: 12),
            Row(children: <Widget>[
              Expanded(child: QuickAction(icon: Icons.menu_book_rounded, title: 'ختمة جديدة', color: scheme.primaryContainer)),
              const SizedBox(width: 12),
              Expanded(child: QuickAction(icon: Icons.headphones_rounded, title: 'التلاوات', color: scheme.secondaryContainer)),
            ]),
            const SizedBox(height: 28),
            const SectionHeader(title: 'آية اليوم', action: 'المزيد'),
            const SizedBox(height: 12),
            SoftCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text('﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾', style: TextStyle(fontSize: 22, height: 1.8, color: scheme.primary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              const Text('الرعد • ٢٨', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Row(children: <Widget>[Icon(Icons.share_outlined, size: 20, color: scheme.primary), const SizedBox(width: 16), Icon(Icons.bookmark_border_rounded, size: 20, color: scheme.primary)]),
            ])),
          ],
        ),
      ),
    );
  }
}

class QuranPage extends StatelessWidget {
  const QuranPage({Key? key}) : super(key: key);

  static const List<Surah> surahs = <Surah>[
    Surah(1, 'الفاتحة', 'مكية', 7), Surah(2, 'البقرة', 'مدنية', 286), Surah(3, 'آل عمران', 'مدنية', 200),
    Surah(4, 'النساء', 'مدنية', 176), Surah(5, 'المائدة', 'مدنية', 120), Surah(6, 'الأنعام', 'مكية', 165),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المصحف', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 6, 20, 30), children: <Widget>[
        const TextField(decoration: InputDecoration(hintText: 'ابحث عن سورة أو آية', prefixIcon: Icon(Icons.search_rounded))),
        const SizedBox(height: 20),
        Row(children: <Widget>[const Text('السور', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)), const Spacer(), Text('${surahs.length} من 114')]),
        const SizedBox(height: 12),
        ...surahs.map((surah) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SoftCard(padding: EdgeInsets.zero, child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: CircleAvatar(child: Text('${surah.number}')),
          title: Text(surah.name, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('${surah.revelation} • ${surah.ayahs} آيات'),
          trailing: const Icon(Icons.chevron_left_rounded),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ReaderPage(surahName: surah.name))),
        )))),
      ]),
    );
  }
}

class ReaderPage extends StatelessWidget {
  const ReaderPage({Key? key, required this.surahName}) : super(key: key);
  final String surahName;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(surahName, style: const TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 32), children: <Widget>[
        SoftCard(color: scheme.primaryContainer.withOpacity(.55), child: Column(children: <Widget>[Text('سُورَةُ $surahName', style: TextStyle(color: scheme.primary, fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('مكية • 7 آيات')])),
        const SizedBox(height: 18),
        SoftCard(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          Text('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, height: 2, color: scheme.primary, fontWeight: FontWeight.w700)),
          const Divider(height: 28),
          const Text('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝١\nالرَّحْمَنِ الرَّحِيمِ ۝٢\nمَالِكِ يَوْمِ الدِّينِ ۝٣', textAlign: TextAlign.right, style: TextStyle(fontSize: 25, height: 2.1)),
          const SizedBox(height: 18),
          Row(children: <Widget>[Icon(Icons.play_circle_fill_rounded, color: scheme.primary), const SizedBox(width: 8), Text('تشغيل التلاوة', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700)), const Spacer(), IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border_rounded))]),
        ])),
      ]),
    );
  }
}

class SavedPage extends StatelessWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('المحفوظات', style: TextStyle(fontWeight: FontWeight.w800))), body: ListView(padding: const EdgeInsets.all(20), children: <Widget>[SoftCard(child: Column(children: <Widget>[Icon(Icons.bookmark_outline_rounded, size: 52, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 12), const Text('ستظهر آياتك المحفوظة هنا', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 6), const Text('احفظ آية أثناء القراءة لتعود إليها بسهولة.', textAlign: TextAlign.center)]))]));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.isDarkMode, required this.onThemeChanged}) : super(key: key);
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.w800))), body: ListView(padding: const EdgeInsets.all(20), children: <Widget>[
      const Text('التفضيلات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 10),
      Card(child: Column(children: <Widget>[SwitchListTile(value: isDarkMode, onChanged: (_) => onThemeChanged(), secondary: const Icon(Icons.dark_mode_outlined), title: const Text('الوضع الداكن'), subtitle: const Text('راحة أكبر للعين أثناء الليل')), const Divider(height: 1), ListTile(leading: const Icon(Icons.text_fields_rounded), title: const Text('حجم خط المصحف'), subtitle: const Text('متوسط'), trailing: const Icon(Icons.chevron_left_rounded), onTap: () {})])),
    ]));
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({Key? key, required this.child, this.color, this.padding = const EdgeInsets.all(20)}) : super(key: key);
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(color: color ?? Theme.of(context).colorScheme.surface, child: Padding(padding: padding, child: child));
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({Key? key, required this.title, this.action}) : super(key: key);
  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)), const Spacer(), if (action != null) TextButton(onPressed: () {}, child: Text(action!))]);
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({Key? key, required this.icon, required this.title, required this.color}) : super(key: key);
  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SoftCard(color: color, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Icon(icon, size: 28), const SizedBox(height: 16), Text(title, style: const TextStyle(fontWeight: FontWeight.w800))]);
  }
}

class Surah {
  const Surah(this.number, this.name, this.revelation, this.ayahs);
  final int number;
  final String name;
  final String revelation;
  final int ayahs;
}