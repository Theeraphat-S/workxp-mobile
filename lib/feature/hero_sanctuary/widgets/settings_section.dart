import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workxp/core/services/sensory_service.dart';
import 'package:workxp/feature/hero_sanctuary/bloc/sanctuary_bloc.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';
import 'json_backup_dialog.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool _sfx = SensoryService.instance.isSfxEnabled;
  bool _haptics = SensoryService.instance.isHapticsEnabled;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SanctuaryBloc, SanctuaryState>(
      listener: (context, state) {
        if (state is SanctuaryLoaded && state.exportedBackupJson != null) {
          showDialog(
            context: context,
            builder: (ctx) => JsonBackupDialog(
              isExport: true,
              exportedJson: state.exportedBackupJson!,
            ),
          );
        }
      },
      child: PixelCard(
        borderColor: PixelColors.borderHighlight,
        backgroundColor: PixelColors.backgroundCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'SETTINGS & STORAGE BACKUP',
              style: PixelTypography.pixelHeader(
                fontSize: 12,
                color: PixelColors.coinGold,
              ),
            ),
            const SizedBox(height: 12),
            // SFX Switch
            SwitchListTile(
              key: const Key('settings_sfx_switch'),
              title: Text(
                '8-BIT SOUND EFFECTS (SFX)',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textBright,
                ),
              ),
              subtitle: Text(
                'Chiptune sword swings, victory fanfares, and chimes',
                style: PixelTypography.pixelBody(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              value: _sfx,
              activeThumbColor: PixelColors.coinGold,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                setState(() => _sfx = val);
                context.read<SanctuaryBloc>().add(ToggleSfxEvent(val));
              },
            ),
            const Divider(color: PixelColors.borderHighlight),
            // Haptics Switch
            SwitchListTile(
              key: const Key('settings_haptics_switch'),
              title: Text(
                'TACTILE HAPTIC FEEDBACK',
                style: PixelTypography.pixelSubheader(
                  fontSize: 10,
                  color: PixelColors.textBright,
                ),
              ),
              subtitle: Text(
                'Physical device vibrations on strike and rewards',
                style: PixelTypography.pixelBody(
                  fontSize: 10,
                  color: PixelColors.textMuted,
                ),
              ),
              value: _haptics,
              activeThumbColor: PixelColors.coinGold,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                setState(() => _haptics = val);
                context.read<SanctuaryBloc>().add(ToggleHapticsEvent(val));
              },
            ),
            const SizedBox(height: 14),
            Text(
              'DATA SAVE FILE MANAGEMENT',
              style: PixelTypography.pixelSubheader(
                fontSize: 10,
                color: PixelColors.coinGold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PixelButton(
                    key: const Key('export_json_btn'),
                    text: 'EXPORT (JSON)',
                    icon: Icons.upload,
                    fontSize: 9,
                    backgroundColor: PixelColors.backgroundSurface,
                    textColor: PixelColors.coinGold,
                    onPressed: () {
                      context.read<SanctuaryBloc>().add(
                        const ExportBackupEvent(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PixelButton(
                    key: const Key('import_json_btn'),
                    text: 'IMPORT (JSON)',
                    icon: Icons.download,
                    fontSize: 9,
                    backgroundColor: PixelColors.backgroundSurface,
                    textColor: PixelColors.hpGreen,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => JsonBackupDialog(
                          isExport: false,
                          onImport: (jsonStr) {
                            context.read<SanctuaryBloc>().add(
                              ImportBackupEvent(jsonStr),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
