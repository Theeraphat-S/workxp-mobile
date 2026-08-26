import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workxp/domain/models/skill_buff_model.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'hero_notifier.dart';

class SkillBuffNotifier extends StateNotifier<List<SkillBuffModel>> {
  SkillBuffNotifier([List<SkillBuffModel>? initial])
    : super(initial ?? SkillBuffModel.defaultBuffs());

  void setBuffs(List<SkillBuffModel> buffs) {
    state = buffs;
  }

  /// Casts a skill buff if hero has sufficient MP
  bool castBuff(String buffId, {required HeroNotifier heroNotifier}) {
    final index = state.indexWhere((b) => b.id == buffId);
    if (index == -1) return false;

    final buff = state[index];
    if (heroNotifier.state.currentMp < buff.mpCost) return false;

    final success = heroNotifier.spendMp(buff.mpCost);
    if (!success) return false;

    final now = DateTime.now();
    final updatedBuff = buff.copyWith(
      activatedAt: now,
      expiresAt: now.add(Duration(minutes: buff.durationMinutes)),
    );

    final updatedList = List<SkillBuffModel>.from(state);
    updatedList[index] = updatedBuff;
    state = updatedList;

    SensoryService.instance.playBuff();
    return true;
  }

  bool isBuffActive(String buffId) {
    final buff = state.firstWhere(
      (b) => b.id == buffId,
      orElse: () => const SkillBuffModel(
        id: '',
        name: '',
        description: '',
        mpCost: 0,
        durationMinutes: 0,
      ),
    );
    return buff.isActive;
  }
}

final skillBuffProvider =
    StateNotifierProvider<SkillBuffNotifier, List<SkillBuffModel>>((ref) {
      return SkillBuffNotifier();
    });
