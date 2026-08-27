import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/domain/datasource/app_database.dart';
import 'package:workxp/domain/repositories/hero_repository.dart';
import 'package:workxp/domain/repositories/tavern_repository.dart';
import 'tavern_event.dart';
import 'tavern_state.dart';

export 'tavern_event.dart';
export 'tavern_state.dart';

class TavernBloc extends Bloc<TavernEvent, TavernState> {
  TavernBloc({
    required TavernRepository tavernRepository,
    required HeroRepository heroRepository,
  }) : _tavernRepository = tavernRepository,
       _heroRepository = heroRepository,
       super(const TavernInitial()) {
    on<LoadTavern>(_onLoadTavern);
    on<TavernUpdated>(_onTavernUpdated);
    on<PurchaseItem>(_onPurchaseItem);
    on<UseConsumableItem>(_onUseConsumableItem);
    on<CreateCustomRewardEvent>(_onCreateCustomReward);
    on<RedeemCustomRewardEvent>(_onRedeemCustomReward);
    on<DeleteCustomRewardEvent>(_onDeleteCustomReward);
  }

  final TavernRepository _tavernRepository;
  final HeroRepository _heroRepository;

  StreamSubscription? _catalogSub;
  StreamSubscription? _inventorySub;
  StreamSubscription? _customRewardsSub;
  StreamSubscription? _heroSub;

  List<TavernItem> _cachedCatalog = [];
  List<TavernItem> _cachedInventory = [];
  List<TavernItem> _cachedCustomRewards = [];
  Hero? _cachedHero;

  Future<void> _onLoadTavern(
    LoadTavern event,
    Emitter<TavernState> emit,
  ) async {
    emit(const TavernLoading());
    await _cancelSubscriptions();

    _catalogSub = _tavernRepository.watchCatalog().listen((catalog) {
      _cachedCatalog = catalog;
      _dispatchUpdated();
    });

    _inventorySub = _tavernRepository.watchInventory().listen((inventory) {
      _cachedInventory = inventory;
      _dispatchUpdated();
    });

    _customRewardsSub = _tavernRepository.watchCustomRewards().listen((
      customRewards,
    ) {
      _cachedCustomRewards = customRewards;
      _dispatchUpdated();
    });

    _heroSub = _heroRepository.watchHero().listen((hero) {
      _cachedHero = hero;
      _dispatchUpdated();
    });
  }

  void _dispatchUpdated() {
    if (isClosed) return;
    add(
      TavernUpdated(
        catalog: _cachedCatalog,
        inventory: _cachedInventory,
        customRewards: _cachedCustomRewards,
        hero: _cachedHero,
      ),
    );
  }

  void _onTavernUpdated(TavernUpdated event, Emitter<TavernState> emit) {
    emit(
      TavernLoaded(
        catalog: event.catalog,
        inventory: event.inventory,
        customRewards: event.customRewards,
        hero: event.hero,
      ),
    );
  }

  Future<void> _onPurchaseItem(
    PurchaseItem event,
    Emitter<TavernState> emit,
  ) async {
    try {
      final success = await _tavernRepository.purchaseItem(event.itemId);
      if (success) {
        SensoryService.instance.playCoin();
      } else {
        SensoryService.instance.playHurt();
      }
    } catch (e) {
      emit(TavernError('Failed to purchase item: $e'));
    }
  }

  Future<void> _onUseConsumableItem(
    UseConsumableItem event,
    Emitter<TavernState> emit,
  ) async {
    try {
      final success = await _tavernRepository.useConsumable(event.itemId);
      if (success) {
        SensoryService.instance.playLevelUp();
      }
    } catch (e) {
      emit(TavernError('Failed to use consumable: $e'));
    }
  }

  Future<void> _onCreateCustomReward(
    CreateCustomRewardEvent event,
    Emitter<TavernState> emit,
  ) async {
    try {
      await _tavernRepository.createCustomReward(
        name: event.name,
        cost: event.cost,
        description: event.description,
        iconAsset: event.iconAsset,
        id: event.id,
      );
      SensoryService.instance.playCoin();
    } catch (e) {
      emit(TavernError('Failed to create custom reward: $e'));
    }
  }

  Future<void> _onRedeemCustomReward(
    RedeemCustomRewardEvent event,
    Emitter<TavernState> emit,
  ) async {
    try {
      final success = await _tavernRepository.redeemCustomReward(
        event.rewardId,
      );
      if (success) {
        SensoryService.instance.playVictory();
      } else {
        SensoryService.instance.playHurt();
      }
    } catch (e) {
      emit(TavernError('Failed to redeem reward: $e'));
    }
  }

  Future<void> _onDeleteCustomReward(
    DeleteCustomRewardEvent event,
    Emitter<TavernState> emit,
  ) async {
    try {
      await _tavernRepository.deleteCustomReward(event.rewardId);
    } catch (e) {
      emit(TavernError('Failed to delete custom reward: $e'));
    }
  }

  Future<void> _cancelSubscriptions() async {
    await _catalogSub?.cancel();
    await _inventorySub?.cancel();
    await _customRewardsSub?.cancel();
    await _heroSub?.cancel();
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();
    return super.close();
  }
}
