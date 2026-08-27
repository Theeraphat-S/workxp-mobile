import 'package:flutter/material.dart';
import 'package:workxp/domain/models/tavern_model.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class CreateCustomRewardDialog extends StatefulWidget {
  const CreateCustomRewardDialog({super.key, this.rewardToEdit});

  final CustomRewardModel? rewardToEdit;

  @override
  State<CreateCustomRewardDialog> createState() =>
      _CreateCustomRewardDialogState();
}

class _CreateCustomRewardDialogState extends State<CreateCustomRewardDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.rewardToEdit?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.rewardToEdit?.description ?? '',
    );
    _costController = TextEditingController(
      text: widget.rewardToEdit?.coinCost.toString() ?? '50',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: PixelCard(
        borderColor: PixelColors.coinGold,
        backgroundColor: PixelColors.backgroundCard,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.rewardToEdit == null
                    ? 'NEW CUSTOM REWARD'
                    : 'EDIT REWARD',
                style: PixelTypography.pixelHeader(
                  fontSize: 13,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'REWARD NAME',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                key: const Key('custom_reward_title_input'),
                controller: _titleController,
                style: PixelTypography.standardBody(
                  color: PixelColors.textBright,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: PixelColors.backgroundSurface,
                  hintText: 'e.g. 1 Bubble Tea, Movie Night',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.coinGold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'DESCRIPTION',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                key: const Key('custom_reward_desc_input'),
                controller: _descController,
                maxLines: 2,
                style: PixelTypography.standardBody(
                  color: PixelColors.textBright,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: PixelColors.backgroundSurface,
                  hintText: 'Reward details or conditions',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.coinGold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'COIN PRICE',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                key: const Key('custom_reward_cost_input'),
                controller: _costController,
                keyboardType: TextInputType.number,
                style: PixelTypography.standardBody(
                  color: PixelColors.textBright,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: PixelColors.backgroundSurface,
                  hintText: '50',
                  hintStyle: TextStyle(color: PixelColors.textMuted),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.coinGold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    text: 'CANCEL',
                    backgroundColor: PixelColors.backgroundSurface,
                    textColor: PixelColors.textMuted,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  PixelButton(
                    key: const Key('submit_custom_reward_btn'),
                    text: widget.rewardToEdit == null ? 'FORGE' : 'SAVE',
                    backgroundColor: PixelColors.coinGold,
                    onPressed: () {
                      final title = _titleController.text.trim();
                      final cost = int.tryParse(_costController.text) ?? 50;
                      if (title.isEmpty) return;

                      final reward = widget.rewardToEdit != null
                          ? widget.rewardToEdit!.copyWith(
                              title: title,
                              description: _descController.text.trim(),
                              coinCost: cost,
                            )
                          : CustomRewardModel(
                              title: title,
                              description: _descController.text.trim(),
                              coinCost: cost,
                            );

                      Navigator.of(context).pop(reward);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
