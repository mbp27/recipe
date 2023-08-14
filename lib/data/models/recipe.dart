import 'dart:convert';

import 'package:flutter/material.dart';

enum RecipeDifficulity {
  easy,
  medium,
  hard,
  expert,
}

extension OnRecipeDifficulity on RecipeDifficulity {
  Color? get color {
    switch (this) {
      case RecipeDifficulity.easy:
        return Colors.green;
      case RecipeDifficulity.medium:
        return Colors.blue;
      case RecipeDifficulity.hard:
        return Colors.orange;
      case RecipeDifficulity.expert:
        return Colors.red;
      default:
        return null;
    }
  }
}

class Recipe {
  final String? calories;
  final String? carbos;
  final String? description;
  final RecipeDifficulity? difficulty;
  final String? fats;
  final String? headline;
  final String? id;
  final String? image;
  final String? name;
  final String? proteins;
  final String? thumb;
  final String? time;

  Recipe({
    this.calories,
    this.carbos,
    this.description,
    this.difficulty,
    this.fats,
    this.headline,
    this.id,
    this.image,
    this.name,
    this.proteins,
    this.thumb,
    this.time,
  });

  Recipe copyWith({
    String? calories,
    String? carbos,
    String? description,
    RecipeDifficulity? difficulty,
    String? fats,
    String? headline,
    String? id,
    String? image,
    String? name,
    String? proteins,
    String? thumb,
    String? time,
  }) {
    return Recipe(
      calories: calories ?? this.calories,
      carbos: carbos ?? this.carbos,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      fats: fats ?? this.fats,
      headline: headline ?? this.headline,
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      proteins: proteins ?? this.proteins,
      thumb: thumb ?? this.thumb,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'carbos': carbos,
      'description': description,
      'difficulty': difficulty?.index,
      'fats': fats,
      'headline': headline,
      'id': id,
      'image': image,
      'name': name,
      'proteins': proteins,
      'thumb': thumb,
      'time': time,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      calories: map['calories'],
      carbos: map['carbos'],
      description: map['description'],
      difficulty: map['difficulty'] != null
          ? RecipeDifficulity.values[map['difficulty']]
          : null,
      fats: map['fats'],
      headline: map['headline'],
      id: map['id'],
      image: map['image'],
      name: map['name'],
      proteins: map['proteins'],
      thumb: map['thumb'],
      time: map['time']
          ?.toString()
          .replaceAll('PT', '')
          .replaceAll('M', ' Min')
          .replaceAll('H', ' Hour'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Recipe(calories: $calories, carbos: $carbos, description: $description, difficulty: $difficulty, fats: $fats, headline: $headline, id: $id, image: $image, name: $name, proteins: $proteins, thumb: $thumb, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recipe &&
        other.calories == calories &&
        other.carbos == carbos &&
        other.description == description &&
        other.difficulty == difficulty &&
        other.fats == fats &&
        other.headline == headline &&
        other.id == id &&
        other.image == image &&
        other.name == name &&
        other.proteins == proteins &&
        other.thumb == thumb &&
        other.time == time;
  }

  @override
  int get hashCode {
    return calories.hashCode ^
        carbos.hashCode ^
        description.hashCode ^
        difficulty.hashCode ^
        fats.hashCode ^
        headline.hashCode ^
        id.hashCode ^
        image.hashCode ^
        name.hashCode ^
        proteins.hashCode ^
        thumb.hashCode ^
        time.hashCode;
  }
}
