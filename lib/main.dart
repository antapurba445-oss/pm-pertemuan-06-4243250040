// Tugas Rutin 6: Wisata Sumatera Utara (versi 2: Budaya & Sejarah)
// Nama: ................  NIM: ................
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

// ---------------------------------------------------------------- Model

enum Kategori {
  sejarah('Sejarah', Icons.history_edu),
  budaya('Budaya', Icons.theater_comedy),
  religi('Religi', Icons.mosque);

  const Kategori(this.label, this.ikon);
  final String label;
  final IconData ikon;
}

class Destinasi {
  const Destinasi({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.kategori,
    required this.deskripsi,
    required this.tips,
    required this.ikon,
  });

  final String id; // slug, dipakai di URL
  final String nama;
  final String lokasi;
  final Kategori kategori;
  final String deskripsi;
  final String tips;
  final IconData ikon;
}

const daftarDestinasi = <Destinasi>[
  Destinasi(
    id: 'istana-maimun',
    nama: 'Istana Maimun',
    lokasi: 'Medan',
    kategori: Kategori.sejarah,
    deskripsi:
        'Istana Kesultanan Deli dengan arsitektur perpaduan Melayu, Timur '
        'Tengah, dan Eropa.',
    tips: 'Kunjungi pagi hari saat pengunjung belum ramai.',
    ikon: Icons.castle,
  ),
  Destinasi(
    id: 'masjid-raya-al-mashun',
    nama: 'Masjid Raya Al-Mashun',
    lokasi: 'Medan',
    kategori: Kategori.religi,
    deskripsi:
        'Masjid bersejarah di pusat Kota Medan dengan kubah besar dan '
        'ornamen yang khas.',
    tips: 'Berpakaian sopan dan perhatikan waktu salat.',
    ikon: Icons.mosque,
  ),
  Destinasi(
    id: 'tjong-a-fie',
    nama: 'Rumah Tjong A Fie',
    lokasi: 'Medan',
    kategori: Kategori.sejarah,
    deskripsi:
        'Rumah peninggalan saudagar Tjong A Fie yang kini dibuka sebagai '
        'museum rumah bersejarah.',
    tips: 'Ikut tur berpemandu untuk mendengar cerita keluarganya.',
    ikon: Icons.villa,
  ),
  Destinasi(
    id: 'huta-siallagan',
    nama: 'Huta Siallagan',
    lokasi: 'Ambarita, Samosir',
    kategori: Kategori.budaya,
    deskripsi:
        'Kampung adat Batak dengan kursi batu yang dahulu dipakai untuk '
        'bermusyawarah.',
    tips: 'Minta pemandu setempat menjelaskan sejarahnya.',
    ikon: Icons.chair,
  ),
  Destinasi(
    id: 'desa-lingga',
    nama: 'Desa Lingga',
    lokasi: 'Kabupaten Karo',
    kategori: Kategori.budaya,
    deskripsi: 'Desa adat Karo dengan rumah adat tradisional yang terjaga.',
    tips: 'Hormati aturan setempat saat memasuki rumah adat.',
    ikon: Icons.cabin,
  ),
  Destinasi(
    id: 'museum-sumut',
    nama: 'Museum Negeri Sumatera Utara',
    lokasi: 'Medan',
    kategori: Kategori.sejarah,
    deskripsi:
        'Museum yang menyimpan koleksi sejarah dan budaya berbagai suku di '
        'Sumatera Utara.',
    tips: 'Cek jam buka sebelum berkunjung.',
    ikon: Icons.museum,
  ),
];

Destinasi? cariDestinasi(String? id) {
  for (final d in daftarDestinasi) {
    if (d.id == id) return d;
  }
  return null;
}

/// Warna ditentukan oleh kategori, diambil dari ColorScheme.
extension PaletKategori on ColorScheme {
  (Color, Color) palet(Kategori k) => switch (k) {
        Kategori.sejarah => (primaryContainer, onPrimaryContainer),
        Kategori.budaya => (secondaryContainer, onSecondaryContainer),
        Kategori.religi => (tertiaryContainer, onTertiaryContainer),
      };
}

// ---------------------------------------------------------------- Router

final _router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) =>
      HalamanTidakDitemukan(pesan: 'Alamat ${state.uri} tidak ada.'),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => KerangkaNavigasi(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DaftarDestinasi(),
              routes: [
                GoRoute(
                  path: 'destinasi/:id',
                  builder: (context, state) =>
                      DetailDestinasi(id: state.pathParameters['id']),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tentang',
              builder: (context, state) => const Tentang(),
            ),
          ],
        ),
      ],
    ),
  ],
);

void main() => runApp(const WisataApp());

class WisataApp extends StatelessWidget {
  const WisataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wisata Sumatera Utara',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Navigasi

/// MediaQuery: keputusan tingkat aplikasi (lebar seluruh jendela).
class KerangkaNavigasi extends StatelessWidget {
  const KerangkaNavigasi({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _pilih(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.sizeOf(context).width;

    if (lebar >= 840) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _pilih,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: Text('Destinasi'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info_outline),
                  selectedIcon: Icon(Icons.info),
                  label: Text('Tentang'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _pilih,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Destinasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Daftar

class DaftarDestinasi extends StatefulWidget {
  const DaftarDestinasi({super.key});

  @override
  State<DaftarDestinasi> createState() => _DaftarDestinasiState();
}

class _DaftarDestinasiState extends State<DaftarDestinasi> {
  Kategori? _dipilih; // null = semua

  @override
  Widget build(BuildContext context) {
    final tampil = _dipilih == null
        ? daftarDestinasi
        : daftarDestinasi.where((d) => d.kategori == _dipilih).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Budaya & Sejarah Sumut')),
      body: Column(
        children: [
          // Baris filter bisa digulir ke samping, jadi aman di 360 dp.
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _dipilih == null,
                  onSelected: (_) => setState(() => _dipilih = null),
                ),
                for (final k in Kategori.values) ...[
                  const SizedBox(width: 8),
                  FilterChip(
                    avatar: Icon(k.ikon, size: 18),
                    label: Text(k.label),
                    selected: _dipilih == k,
                    onSelected: (_) =>
                        setState(() => _dipilih = _dipilih == k ? null : k),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final kolom = switch (constraints.maxWidth) {
                  < 600 => 2,
                  < 900 => 3,
                  _ => 4,
                };
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kolom,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 196,
                  ),
                  itemCount: tampil.length,
                  itemBuilder: (context, i) =>
                      KartuDestinasi(destinasi: tampil[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class KartuDestinasi extends StatelessWidget {
  const KartuDestinasi({super.key, required this.destinasi});

  final Destinasi destinasi;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;
    final (latar, isi) = skema.palet(destinasi.kategori);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/destinasi/${destinasi.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: ColoredBox(color: latar)),
                  Center(child: Icon(destinasi.ikon, size: 52, color: isi)),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Icon(destinasi.kategori.ikon, size: 20, color: isi),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destinasi.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: teks.titleSmall,
                  ),
                  Text(
                    '${destinasi.kategori.label} · ${destinasi.lokasi}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: teks.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Detail

class DetailDestinasi extends StatelessWidget {
  const DetailDestinasi({super.key, required this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    final d = cariDestinasi(id);
    if (d == null) {
      return HalamanTidakDitemukan(pesan: 'Destinasi "$id" tidak ditemukan.');
    }

    return Scaffold(
      appBar: AppBar(title: Text(d.nama, overflow: TextOverflow.ellipsis)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final hero = HeroDestinasi(destinasi: d);
          final info = InfoDestinasi(destinasi: d);

          // Lebar: hero tetap 360 dp di kiri, info mengisi sisanya.
          if (constraints.maxWidth >= 720) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 360,
                  child: Padding(padding: const EdgeInsets.all(16), child: hero),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    child: info,
                  ),
                ),
              ],
            );
          }
          // Sempit: hero di atas, info di bawah, semuanya bisa digulir.
          return ListView(
            children: [
              SizedBox(height: 220, child: hero),
              Padding(padding: const EdgeInsets.all(16), child: info),
            ],
          );
        },
      ),
    );
  }
}

/// Stack: warna latar, ikon besar terpotong, ikon kategori, dan judul.
class HeroDestinasi extends StatelessWidget {
  const HeroDestinasi({super.key, required this.destinasi});

  final Destinasi destinasi;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;
    final (latar, isi) = skema.palet(destinasi.kategori);

    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: latar)),
        Positioned(
          right: -24,
          bottom: -24,
          child: Icon(
            destinasi.ikon,
            size: 200,
            color: isi.withValues(alpha: 0.2),
          ),
        ),
        Positioned(
          left: 16,
          top: 16,
          child: Icon(destinasi.kategori.ikon, color: isi),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Text(
            destinasi.nama,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: teks.headlineSmall?.copyWith(color: isi),
          ),
        ),
      ],
    );
  }
}

class InfoDestinasi extends StatelessWidget {
  const InfoDestinasi({super.key, required this.destinasi});

  final Destinasi destinasi;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: Icon(destinasi.kategori.ikon, size: 18),
              label: Text(destinasi.kategori.label),
            ),
            Chip(
              avatar: const Icon(Icons.place, size: 18),
              label: Text(destinasi.lokasi),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Sekilas', style: teks.titleMedium),
        const SizedBox(height: 8),
        Text(destinasi.deskripsi, style: teks.bodyLarge),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.tips_and_updates_outlined),
            title: const Text('Saran berkunjung'),
            subtitle: Text(destinasi.tips),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          // pop jika ada halaman sebelumnya, jika tidak (tautan langsung) ke beranda.
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Kembali'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- Tentang

class Tentang extends StatelessWidget {
  const Tentang({super.key});

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Wisata Sumatera Utara', style: teks.headlineSmall),
              const SizedBox(height: 8),
              const Text(
                'Katalog wisata budaya dan sejarah Sumatera Utara. Tugas Rutin 6 '
                'Pemrograman Mobile: layout responsif dan navigasi go_router.',
              ),
              const SizedBox(height: 16),
              const Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Nama Lengkap'),
                      subtitle: Text('Pembuat'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('4243250000'),
                      subtitle: Text('NIM'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.code),
                      title: Text('Flutter, material_ui, go_router'),
                      subtitle: Text('Teknologi'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- 404

class HalamanTidakDitemukan extends StatelessWidget {
  const HalamanTidakDitemukan({super.key, required this.pesan});

  final String pesan;

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off, size: 72),
              const SizedBox(height: 16),
              Text('Halaman tidak ditemukan', style: teks.headlineSmall),
              const SizedBox(height: 8),
              Text(pesan, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Ke beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
