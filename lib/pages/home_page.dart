import 'package:flutter/material.dart';
import 'package:resepku/data/dummy_recipes.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/pages/settings_page.dart';
import 'package:resepku/widgets/favorite_badge_button.dart';
import 'package:resepku/widgets/recipe_grid_card.dart';
import 'package:resepku/widgets/recipe_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGrid = false; 
  String? _cuisine; // State untuk filter cuisine

  @override
  Widget build(BuildContext context) {
    // Mengambil daftar cuisine unik dari data
    final List<String> cuisines = ['Semua', ...dummyRecipes.map((r) => r.cuisine).toSet()];
    
    // Filter data berdasarkan chip yang dipilih
    final filteredRecipes = _cuisine == null
        ? dummyRecipes
        : dummyRecipes.where((r) => r.cuisine == _cuisine).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 8),
            const Text('ResepKu'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Tampilan list' : 'Tampilan grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          const FavoriteBadgeButton(),
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter ChoiceChip
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: cuisines.length,
              itemBuilder: (context, index) {
                final cuisine = cuisines[index];
                final isSelected = (_cuisine == null && cuisine == 'Semua') || cuisine == _cuisine;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cuisine),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _cuisine = cuisine == 'Semua' ? null : cuisine;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Expanded untuk Grid atau List
          Expanded(
            child: _isGrid ? _buildGrid(filteredRecipes) : _buildList(filteredRecipes),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Recipe> recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeTile(recipe: recipes[index]);
      },
    );
  }

  Widget _buildGrid(List<Recipe> recipes) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3 / 4,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return RecipeGridCard(recipe: recipes[index]);
      },
    );
  }
}