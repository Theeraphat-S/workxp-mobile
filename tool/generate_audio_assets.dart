import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  final audioDir = Directory('assets/audio');
  if (!audioDir.existsSync()) {
    audioDir.createSync(recursive: true);
  }

  stdout.writeln('Generating 16-Bit Chiptune SFX and BGM assets...');

  // 1. Button Click (Short 8-bit blip, 40ms)
  _generateWav(
    'assets/audio/sfx_button_click.wav',
    durationSec: 0.05,
    generator: (t, dur) {
      final freq = 880.0 + 440.0 * (1.0 - t / dur);
      final env = (1.0 - t / dur);
      return _squareWave(t, freq) * env * 0.4;
    },
  );

  // 2. Sword Slash (White noise burst + descending pitch tone, 150ms)
  final rand = Random(42);
  _generateWav(
    'assets/audio/sfx_sword_slash.wav',
    durationSec: 0.18,
    generator: (t, dur) {
      final freq = 600.0 * (1.0 - t / dur) + 100.0;
      final env = pow(1.0 - t / dur, 1.5).toDouble();
      final noise = (rand.nextDouble() * 2.0 - 1.0) * 0.6;
      final tone = _sawtoothWave(t, freq) * 0.4;
      return (noise + tone) * env * 0.6;
    },
  );

  // 3. Critical Strike (Heavy explosive noise + double slash, 300ms)
  _generateWav(
    'assets/audio/sfx_critical_strike.wav',
    durationSec: 0.35,
    generator: (t, dur) {
      final freq = 300.0 * (1.0 - t / dur) + 80.0;
      final env = pow(1.0 - t / dur, 1.2).toDouble();
      final noise = (rand.nextDouble() * 2.0 - 1.0) * 0.7;
      final tone = _squareWave(t, freq) * 0.5;
      return (noise + tone) * env * 0.8;
    },
  );

  // 4. Coin Collect (High pitch 2-tone arpeggio B5 -> E6, 180ms)
  _generateWav(
    'assets/audio/sfx_coin_collect.wav',
    durationSec: 0.22,
    generator: (t, dur) {
      final freq = t < 0.08 ? 987.77 : 1318.51; // B5 then E6
      final env = pow(1.0 - t / dur, 0.8).toDouble();
      return _squareWave(t, freq) * env * 0.5;
    },
  );

  // 5. Hero Hurt (Descending low pulse wave, 220ms)
  _generateWav(
    'assets/audio/sfx_hero_hurt.wav',
    durationSec: 0.25,
    generator: (t, dur) {
      final freq = 180.0 * (1.0 - t / dur) + 40.0;
      final env = pow(1.0 - t / dur, 2.0).toDouble();
      final noise = (rand.nextDouble() * 2.0 - 1.0) * 0.4;
      return (_triangleWave(t, freq) * 0.6 + noise) * env * 0.7;
    },
  );

  // 6. Level Up Fanfare (Ascending 4-tone retro arpeggio, 600ms)
  _generateWav(
    'assets/audio/sfx_level_up.wav',
    durationSec: 0.65,
    generator: (t, dur) {
      // C5 (523), E5 (659), G5 (784), C6 (1046)
      final notes = [523.25, 659.25, 783.99, 1046.50];
      final noteIdx = min((t / 0.15).floor(), notes.length - 1);
      final freq = notes[noteIdx];
      final noteT = t % 0.15;
      final env = (1.0 - noteT / 0.16);
      return _squareWave(t, freq) * env * 0.5;
    },
  );

  // 7. Boss Defeat (Majestic retro victory chime, 800ms)
  _generateWav(
    'assets/audio/sfx_boss_defeat.wav',
    durationSec: 0.85,
    generator: (t, dur) {
      final notes = [440.0, 554.37, 659.25, 880.0, 1108.73];
      final noteIdx = min((t / 0.16).floor(), notes.length - 1);
      final freq = notes[noteIdx];
      final env = (1.0 - t / dur);
      return (_squareWave(t, freq) * 0.4 + _triangleWave(t, freq / 2) * 0.3) *
          env;
    },
  );

  // 8. Buff Cast (Shimmering ascending sweep, 350ms)
  _generateWav(
    'assets/audio/sfx_buff_cast.wav',
    durationSec: 0.40,
    generator: (t, dur) {
      final freq = 400.0 + 800.0 * (t / dur);
      final env = (1.0 - t / dur);
      final vibrato = sin(t * 40.0) * 30.0;
      return _triangleWave(t, freq + vibrato) * env * 0.5;
    },
  );

  // 9. BGM: Battle Hub (Energetic 4-bar Chiptune Loop, ~3.2s)
  _generateWav(
    'assets/audio/bgm_battle_hub.wav',
    durationSec: 3.2,
    generator: (t, dur) {
      final beat = (t * 4.0).floor() % 8;
      final bassNotes = [
        110.0,
        110.0,
        130.8,
        146.8,
        164.8,
        146.8,
        130.8,
        110.0,
      ];
      final melodyNotes = [
        440.0,
        523.2,
        659.2,
        523.2,
        587.3,
        659.2,
        523.2,
        440.0,
      ];
      final bass = _triangleWave(t, bassNotes[beat]) * 0.3;
      final lead = _squareWave(t, melodyNotes[beat]) * 0.2;
      return bass + lead;
    },
  );

  // 10. BGM: Dungeon Map (Mysterious slow minor loop, ~3.6s)
  _generateWav(
    'assets/audio/bgm_dungeon_map.wav',
    durationSec: 3.6,
    generator: (t, dur) {
      final beat = (t * 2.0).floor() % 6;
      final notes = [130.8, 155.56, 174.61, 196.0, 174.61, 155.56];
      final tone = _triangleWave(t, notes[beat]) * 0.25;
      final pad = _sineWave(t, notes[beat] * 2) * 0.15;
      return tone + pad;
    },
  );

  // 11. BGM: Tavern Cozy (Warm relaxed waltz chiptune, ~3.2s)
  _generateWav(
    'assets/audio/bgm_tavern_cozy.wav',
    durationSec: 3.2,
    generator: (t, dur) {
      final beat = (t * 3.0).floor() % 9;
      final notes = [
        261.63,
        329.63,
        392.0,
        329.63,
        261.63,
        392.0,
        349.23,
        293.66,
        246.94,
      ];
      final lead = _triangleWave(t, notes[beat]) * 0.25;
      final sub = _sineWave(t, notes[beat] / 2) * 0.2;
      return lead + sub;
    },
  );

  // 12. BGM: Sanctuary (Calming ethereal loop, ~3.5s)
  _generateWav(
    'assets/audio/bgm_sanctuary.wav',
    durationSec: 3.5,
    generator: (t, dur) {
      final beat = (t * 2.0).floor() % 7;
      final notes = [329.63, 392.0, 493.88, 587.33, 493.88, 392.0, 329.63];
      final lead = _sineWave(t, notes[beat]) * 0.25;
      final echo = _triangleWave(t, notes[beat] * 1.5) * 0.1;
      return lead + echo;
    },
  );

  stdout.writeln(
    'Successfully generated all 12 Chiptune audio assets in assets/audio/!',
  );
}

double _squareWave(double t, double freq) {
  return sin(2 * pi * freq * t) >= 0 ? 0.7 : -0.7;
}

double _triangleWave(double t, double freq) {
  return 2.0 * (t * freq - (t * freq + 0.5).floor()).abs() * 2.0 - 1.0;
}

double _sawtoothWave(double t, double freq) {
  return 2.0 * (t * freq - (t * freq).floor()) - 1.0;
}

double _sineWave(double t, double freq) {
  return sin(2 * pi * freq * t);
}

void _generateWav(
  String path, {
  required double durationSec,
  required double Function(double t, double dur) generator,
}) {
  const sampleRate = 22050;
  final numSamples = (durationSec * sampleRate).round();
  final byteData = ByteData(44 + numSamples * 2);

  // RIFF Chunk
  byteData.setUint8(0, 0x52); // R
  byteData.setUint8(1, 0x49); // I
  byteData.setUint8(2, 0x46); // F
  byteData.setUint8(3, 0x46); // F
  byteData.setUint32(4, 36 + numSamples * 2, Endian.little);
  byteData.setUint8(8, 0x57); // W
  byteData.setUint8(9, 0x41); // A
  byteData.setUint8(10, 0x56); // V
  byteData.setUint8(11, 0x45); // E

  // fmt subchunk
  byteData.setUint8(12, 0x66); // f
  byteData.setUint8(13, 0x6D); // m
  byteData.setUint8(14, 0x74); // t
  byteData.setUint8(15, 0x20); // ' '
  byteData.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
  byteData.setUint16(20, 1, Endian.little); // AudioFormat (1 = PCM)
  byteData.setUint16(22, 1, Endian.little); // NumChannels (1 = Mono)
  byteData.setUint32(24, sampleRate, Endian.little); // SampleRate
  byteData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate
  byteData.setUint16(32, 2, Endian.little); // BlockAlign
  byteData.setUint16(34, 16, Endian.little); // BitsPerSample

  // data subchunk
  byteData.setUint8(36, 0x64); // d
  byteData.setUint8(37, 0x61); // a
  byteData.setUint8(38, 0x74); // t
  byteData.setUint8(39, 0x61); // a
  byteData.setUint32(40, numSamples * 2, Endian.little);

  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final sampleValue = generator(t, durationSec).clamp(-1.0, 1.0);
    final pcm16 = (sampleValue * 32767).round().clamp(-32768, 32767);
    byteData.setInt16(44 + i * 2, pcm16, Endian.little);
  }

  File(path).writeAsBytesSync(byteData.buffer.asUint8List());
}
