import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class TavernState extends Equatable {
  const TavernState();

  @override
  List<Object?> get props => [];
}

class TavernInitial extends TavernState {
  const TavernInitial();
}

class TavernLoading extends TavernState {
  const TavernLoading();
}

class TavernLoaded extends TavernState {
  const TavernLoaded({
    required this.catalog,
    required this.inventory,
    required this.customRewards,
    required this.hero,
  });

  final List<TavernItem> catalog;
  final List<TavernItem> inventory;
  final List<TavernItem> customRewards;
  final Hero? hero;

  int get heroCoins => hero?.coins ?? 0;

  List<TavernItem> get consumables =>
      catalog.where((i) => i.category == 'consumable').toList();

  List<TavernItem> get cosmetics =>
      catalog.where((i) => i.category == 'skin' || i.category == 'theme').toList();

  @override
  List<Object?> get props => [catalog, inventory, customRewards, hero];
}

class TavernError extends TavernState {
  const TavernError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
