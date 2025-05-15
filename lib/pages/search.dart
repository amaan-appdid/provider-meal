// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search Meals'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: TextField(
              focusNode: _focusNode,
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
          ),
          const SizedBox(height: 20),
          if (mealProvider.isloading)
            Expanded(child: Center(child: const CircularProgressIndicator()))
          else if (mealProvider.searchList.isEmpty)
            const Text('No meals found.')
          else
            Expanded(
              child: ListView.builder(
                itemCount: mealProvider.searchList.length,
                itemBuilder: (ctx, i) {
                  final meal = mealProvider.searchList[i];
                  return Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        offset: Offset(4, 4),
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.03),
                      ),
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
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

                            _controller.clear();
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              meal.imageUrl,
                            ),
                          ),
                          title: Text(meal.name),
                          subtitle: Text(
                            // meal.instructions,
                            meal.instructions.length > 100 ? '${meal.instructions.substring(0, 100)}...' : meal.instructions,
                          ),
                        ),
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
