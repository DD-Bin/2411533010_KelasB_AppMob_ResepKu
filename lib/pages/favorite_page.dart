import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/providers/favorite_provider.dart';
import 'package:resepku/widgets/recipe_image.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau jumlah favorit untuk menyembunyikan tombol "Hapus Semua" jika kosong
    final favoriteCount = context.watch<FavoriteProvider>().count;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        actions: [
          // Tombol Hapus Semua dari Modul 6 Latihan 2
          if (favoriteCount > 0)
            IconButton(
              tooltip: 'Hapus Semua Favorit',
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                // Menampilkan dialog konfirmasi
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Semua?'),
                    content: const Text('Yakin ingin menghapus semua resep dari daftar favorit?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Memanggil fungsi clear() dari provider
                          context.read<FavoriteProvider>().clear();
                          Navigator.pop(context); // Tutup dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Semua resep favorit berhasil dihapus')),
                          );
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favorite, child) {
          if (favorite.count == 0) {
            return const Center(
              child: Text(
                'Belum ada resep favorit.\nTekan ikon hati di daftar resep.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            itemCount: favorite.items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final recipe = favorite.items[index];
              
              // Fitur swipe-to-delete dari Latihan 2 Modul 7
              return Dismissible(
                key: ValueKey(recipe.id), // Wajib unik untuk Dismissible
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  favorite.toggle(recipe); // Hapus dari favorit
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${recipe.name} dihapus dari favorit')),
                  );
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: RecipeImage(url: recipe.image, cacheWidth: 168),
                    ),
                  ),
                  title: Text(recipe.name),
                  subtitle: Text(recipe.cuisine),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      favorite.toggle(recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${recipe.name} dihapus dari favorit')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}