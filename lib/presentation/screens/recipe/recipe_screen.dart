import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/data/models/recipe.dart';
import 'package:recipe/helpers/utils.dart';
import 'package:recipe/logic/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:recipe/logic/cubits/theme/theme_cubit.dart';
import 'package:recipe/presentation/components/custom_shimmer.dart';
import 'package:recipe/presentation/components/loading.dart';
import 'package:recipe/presentation/screens/profile/profile_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  static const String routeName = '/';

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late Completer<void> _refreshCompleter;

  void _setTheme() {
    context.read<ThemeCubit>().onToggleTheme();
  }

  void _loadRecipeList() {
    context.read<RecipeListCubit>().onRecipeLoaded();
    _refreshCompleter = Completer<void>();
  }

  Future<void> _onRefresh() async {
    _loadRecipeList();
    return _refreshCompleter.future;
  }

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadRecipeList();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final IconData themeIcon = brightness == Brightness.light
        ? Icons.brightness_4
        : Icons.brightness_5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),
        actions: [
          IconButton(
            splashRadius: 20.0,
            onPressed: _setTheme,
            icon: Icon(themeIcon),
          ),
          IconButton(
            splashRadius: 20.0,
            onPressed: () =>
                Navigator.of(context).pushNamed(ProfileScreen.routeName),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: BlocConsumer<RecipeListCubit, RecipeListState>(
        listener: (context, state) {
          if (state is RecipeListLoadFailure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  duration: const Duration(seconds: 3),
                ),
              );
          }
          if (state is! RecipeListLoadInProgress) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is RecipeListLoadSuccess) {
            final recipes = state.recipes.toList();

            if (recipes.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) =>
                      _buildRecipeItem(recipes[index]),
                ),
              );
            } else {
              return const Center(child: Text('There are no recipes'));
            }
          } else if (state is RecipeListLoadFailure) {
            return GestureDetector(
              onTap: _loadRecipeList,
              child: const Center(
                child: CircleAvatar(child: Icon(Icons.refresh)),
              ),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: 12,
              itemBuilder: (context, index) => _buildRecipeItemLoading(),
            );
          }
        },
      ),
    );
  }

  Widget _buildRecipeItem(Recipe recipe) {
    final imagePath = recipe.image;
    final backgroundColor = Theme.of(context).focusColor;

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8.0)),
            child: Container(
              height: MediaQuery.of(context).size.width / 2.2,
              color: backgroundColor,
              child: imagePath != null
                  ? FutureBuilder<File>(
                      future: Utils.downloadImage(imagePath),
                      builder: (context, snapshot) {
                        final file = snapshot.data;
                        if (file != null) {
                          return Image.file(
                            file,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (context, object, error) =>
                                const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: Loading());
                        }
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: MediaQuery.of(context).size.width / 8,
                          ),
                          const SizedBox(height: 4.0),
                          const Text('No Image'),
                        ],
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${recipe.name}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text('${recipe.headline}'),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, size: 14.0),
                        const SizedBox(width: 2.0),
                        Text(
                          '${recipe.time}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0, child: VerticalDivider()),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: recipe.difficulty?.color,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Text(
                        '${recipe.difficulty?.name.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeItemLoading() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomShimmer(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Container(
                color: Colors.grey,
                height: MediaQuery.of(context).size.width / 2.2,
              ),
            ),
          ),
          CustomShimmer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      color: Colors.grey,
                      height: 16.0,
                      width: MediaQuery.of(context).size.width / 1.5,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      color: Colors.grey,
                      height: 14.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.grey,
                          height: 14.0,
                          width: 50.0,
                        ),
                      ),
                      const SizedBox(height: 20.0, child: VerticalDivider()),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.grey,
                          height: 14.0,
                          width: 50.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
