import 'package:equatable/equatable.dart';
import 'package:workxp/domain/datasource/app_database.dart';

abstract class TavernEvent extends Equatable {
  const TavernEvent();

  @override
  List<Object?> get props => [];
}

class LoadTavern extends TavernEvent {
  const LoadTavern();
}

class TavernUpdated extends TavernEvent {
  const TavernUpdated({
    required this.catalog,
    required this.inventory,
    required this.customRewards,
    required this.hero,
  });

  final List<TavernItem> catalog;
  final List<TavernItem> inventory;
  final List<TavernItem> customRewards;
  final Hero? hero;

  @override
  List<Object?> get props => [catalog, inventory, customRewards, hero];
}

class PurchaseItem extends TavernEvent {
  const PurchaseItem(this.itemId);
  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class UseConsumableItem extends TavernEvent {
  const UseConsumableItem(this.itemId);
  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class CreateCustomRewardEvent extends TavernEvent {
  const CreateCustomRewardEvent({
    required this.name,
    required this.cost,
    this.description = '',
    this.iconAsset = 'coffee',
    this.id,
  });

  final String name;
  final int cost;
  final String description;
  final String iconAsset;
  final String? id;

  @override
  List<Object?> get props => [name, cost, description, iconAsset, id];
}

class RedeemCustomRewardEvent extends TavernEvent {
  const RedeemCustomRewardEvent(this.rewardId);
  final String rewardId;

  @override
  List<Object?> get props => [rewardId];
}

class DeleteCustomRewardEvent extends TavernEvent {
  const DeleteCustomRewardEvent(this.rewardId);
  final String rewardId;

  @override
  List<Object?> get props => [rewardId];
}
