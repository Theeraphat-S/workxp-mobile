import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workxp/shared/theme/pixel_colors.dart';
import 'package:workxp/shared/theme/pixel_typography.dart';
import 'package:workxp/shared/widgets/pixel_button.dart';
import 'package:workxp/shared/widgets/pixel_card.dart';

class JsonBackupDialog extends StatefulWidget {
  const JsonBackupDialog({
    super.key,
    required this.isExport,
    this.exportedJson = '',
    this.onImport,
  });

  final bool isExport;
  final String exportedJson;
  final void Function(String jsonContent)? onImport;

  @override
  State<JsonBackupDialog> createState() => _JsonBackupDialogState();
}

class _JsonBackupDialogState extends State<JsonBackupDialog> {
  late TextEditingController _jsonController;
  bool _isCopied = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _jsonController = TextEditingController(text: widget.exportedJson);
  }

  @override
  void dispose() {
    _jsonController.dispose();
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
                widget.isExport
                    ? 'EXPORT SAVE FILE (JSON)'
                    : 'IMPORT SAVE FILE (JSON)',
                style: PixelTypography.pixelHeader(
                  fontSize: 12,
                  color: PixelColors.coinGold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                widget.isExport
                    ? 'Copy this JSON save backup to restore your progress anytime on any device.'
                    : 'Paste your valid WorkXP save JSON backup below to restore your progress.',
                style: PixelTypography.pixelBody(
                  fontSize: 11,
                  color: PixelColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('json_backup_text_field'),
                controller: _jsonController,
                maxLines: 8,
                readOnly: widget.isExport,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: PixelColors.textBright,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: PixelColors.backgroundDark,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PixelColors.coinGold),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: PixelTypography.pixelSubheader(
                    fontSize: 9,
                    color: PixelColors.hpRed,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PixelButton(
                    text: 'CLOSE',
                    backgroundColor: PixelColors.backgroundSurface,
                    textColor: PixelColors.textMuted,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  if (widget.isExport)
                    PixelButton(
                      key: const Key('copy_json_btn'),
                      text: _isCopied ? 'COPIED!' : 'COPY JSON',
                      backgroundColor: PixelColors.coinGold,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: _jsonController.text),
                        );
                        setState(() => _isCopied = true);
                      },
                    )
                  else
                    PixelButton(
                      key: const Key('restore_game_btn'),
                      text: 'RESTORE GAME',
                      backgroundColor: PixelColors.hpGreen,
                      textColor: Colors.black,
                      onPressed: () {
                        final text = _jsonController.text.trim();
                        if (text.isEmpty) {
                          setState(
                            () => _errorMessage = 'Please enter JSON data.',
                          );
                          return;
                        }
                        widget.onImport?.call(text);
                        Navigator.of(context).pop();
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
