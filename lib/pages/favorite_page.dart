import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/providers/favorite_provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan watch agar seluruh halaman (termasuk AppBar) 
    // diperbarui ketika jumlah favorit berubah.
    final favorite = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        actions: [
          IconButton(
            tooltip: 'Hapus Semua',
            icon: const Icon(Icons.delete_sweep),
            // Tombol nonaktif (bernilai null) saat daftar favorit kosong
            onPressed: favorite.count == 0
                ? null
                : () {
                    // Menampilkan dialog konfirmasi
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text('Hapus Semua Favorit'),
                          content: const Text(
                              'Apakah Anda yakin ingin menghapus semua resep dari daftar favorit?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Memanggil clear() untuk mengosongkan daftar
                                context.read<FavoriteProvider>().clear();
                                Navigator.pop(ctx);
                              },
                              child: const Text('Hapus'),
                            ),
                          ],
                        );
                      },
                    );
                  },
          ),
        ],
      ),
      body: favorite.count == 0
          ? const Center(
              child: Text(
                'Belum ada resep favorit.\nTekan ikon hati di daftar resep.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              children: [
                for (final recipe in favorite.items)
                  ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.cuisine),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          context.read<FavoriteProvider>().toggle(recipe),
                    ),
                  ),
              ],
            ),
    );
  }
}