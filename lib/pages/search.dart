// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:meals_pro/pages/detail.dart';
import 'package:meals_pro/provider/search_provider.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Search> {
  final TextEditingController _controller = TextEditingController();

  void _search() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      Provider.of<SearchProvider>(context, listen: false).searchMeals(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Meals')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter meal name',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onChanged: (vale) {
                _search();
              },
            ),
            const SizedBox(height: 20),
            if (mealProvider.isloading)
              const CircularProgressIndicator()
            else if (mealProvider.searchList.isEmpty)
              const Text('No meals found.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: mealProvider.searchList.length,
                  itemBuilder: (ctx, i) {
                    final meal = mealProvider.searchList[i];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                id: mealProvider.searchList[i].id,
                              ),
                            ),
                          );
                        },
                        leading: Image.network(meal.imageUrl, width: 60),
                        title: Text(meal.name),
                        subtitle: Text(
                          // meal.instructions,
                          meal.instructions.length > 100 ? '${meal.instructions.substring(0, 100)}...' : meal.instructions,
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
