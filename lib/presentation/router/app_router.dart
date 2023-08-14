import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/data/repositories/recipe_repository.dart';
import 'package:recipe/logic/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:recipe/presentation/screens/not_found/not_found_screen.dart';
import 'package:recipe/presentation/screens/profile/profile_screen.dart';
import 'package:recipe/presentation/screens/recipe/recipe_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    try {
      switch (routeSettings.name) {
        case RecipeScreen.routeName:
          return MaterialPageRoute(
            builder: (context) => BlocProvider<RecipeListCubit>(
              create: (context) => RecipeListCubit(
                recipeRepository: context.read<RecipeRepository>(),
              ),
              child: const RecipeScreen(),
            ),
          );
        case ProfileScreen.routeName:
          return MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          );
        default:
          return MaterialPageRoute(
            builder: (context) => const NotFoundScreen(),
          );
      }
    } catch (e) {
      return MaterialPageRoute(
        builder: (context) => const NotFoundScreen(),
      );
    }
  }
}
