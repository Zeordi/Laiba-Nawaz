import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String name;
  final String role;
  final String textToSpeak;

  const AudioPlayerWidget({
    super.key,
    required this.name,
    required this.role,
    required this.textToSpeak,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late FlutterTts flutterTts;
  bool isPlaying = false;
  double progress = 0.0;
  // Web voice preparation state
  bool _webVoicesReady = false;
  String? _webVoiceName;
  String? _webVoiceLocale;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initTts();
  }

  // Helper helper to ignore errors in setup
  Future<void> _safeSet(Future<dynamic> Function() msg) async {
    try {
      await msg();
    } catch (e) {
      print("TTS SafeSet Error: $e");
    }
  }

  // Prepare a usable voice on Web to avoid synthesis-failed
  Future<void> _prepareWebVoice() async {
    try {
      final voices = await flutterTts.getVoices;
      if (voices is List && voices.isNotEmpty) {
        Map<dynamic, dynamic>? pick;
        for (final v in voices) {
          final locale = (v is Map && (v['locale'] ?? v['lang']))?.toString().toLowerCase() ?? '';
          final name = (v is Map && v['name'])?.toString().toLowerCase() ?? '';
          if (locale.contains('en') || name.contains('english')) {
            pick = v as Map<dynamic, dynamic>;
            break;
          }
        }
        pick ??= voices.first as Map<dynamic, dynamic>;
        _webVoiceName = pick['name']?.toString();
        _webVoiceLocale = (pick['locale'] ?? pick['lang'])?.toString();
        if (_webVoiceName != null || _webVoiceLocale != null) {
          await _safeSet(() => flutterTts.setVoice({
            if (_webVoiceName != null) 'name': _webVoiceName!,
            if (_webVoiceLocale != null) 'locale': _webVoiceLocale!,
          }));
        }
        _webVoicesReady = true;
      } 
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  Future<void> _initTts() async {
    try {
      if (!kIsWeb) {
        await flutterTts.awaitSpeakCompletion(true);
        await _safeSet(() => flutterTts.setLanguage("en-US"));
        await flutterTts.setSpeechRate(0.3);
        await _safeSet(() => flutterTts.setVolume(1.0));
        await _safeSet(() => flutterTts.setPitch(1.0));
      } else {
        // Web: Prepare voice list once so we don't do async work inside user gesture.
        await _prepareWebVoice();
      }
      
      // Ensure iOS audio plays through speaker
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        await flutterTts.setIosAudioCategory(
            IosTextToSpeechAudioCategory.playback,
            [
              IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
              IosTextToSpeechAudioCategoryOptions.allowBluetooth,
              IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            ],
        );
      }

      flutterTts.setStartHandler(() {
        print("TTS: Start Handler Triggered");
        if (mounted) {
          setState(() {
            isPlaying = true;
          });
        }
      });

      flutterTts.setCompletionHandler(() {
        print("TTS: Completion Handler Triggered");
        if (mounted) {
          setState(() {
            isPlaying = false;
            progress = 0.0;
          });
        }
      });

      flutterTts.setErrorHandler((msg) {
        print("TTS: Error Handler Triggered: $msg");
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
        }
      });
    } catch (e) {
      print("TTS: Initialization Error: $e");
    }
    
    // Attempt to track progress, though accuracy varies by engine
    flutterTts.setProgressHandler((text, start, end, word) {
      // Simply visual feedback if needed
    });
  }

  Future<void> _speak() async {
    print("TTS: Speak called with text: ${widget.textToSpeak}");
    if (widget.textToSpeak.isNotEmpty) {
      if (!kIsWeb) {
         await flutterTts.stop(); // Only stop on mobile
      }

      // On Web, we MUST call speak() as part of the direct user interaction chain.
      // Do not await other futures or set state (which triggers rebuilds) before this.
      // Voice is prepared during init; if not ready, attempt a best-effort set without awaiting.
      if (kIsWeb && _webVoicesReady) {
        try {
          await _safeSet(() => flutterTts.setVoice({
            if (_webVoiceName != null) 'name': _webVoiceName!,
            if (_webVoiceLocale != null) 'locale': _webVoiceLocale!,
          }));
        } catch (e) {
          print('Web TTS: setVoice at speak failed: $e');
        }
      }
      try {
        var result = await flutterTts.speak(widget.textToSpeak);
        print("TTS: Speak Result: $result");
        
        // Update UI only after initiating
        if (kIsWeb) {
           setState(() => isPlaying = true);
        }
      } catch (e) {
        print("TTS: Error speaking: $e");
        if (kIsWeb) {
           setState(() => isPlaying = false);
        }
      }
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(findWidth(screenWidth, 16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: findWidth(screenWidth, 48),
                height: findWidth(screenWidth, 48),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/voxflow.png'), // Placeholder
                    fit: BoxFit.cover,
                  ),
                ),
                // Fallback
              ),
              SizedBox(width: findWidth(screenWidth, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: widget.name,
                      color: AppColors.textDefault,
                      fontSize: findFontSize(screenWidth, 16),
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: findHeight(screenHeight, 4)),
                    CustomText(
                      text: widget.role,
                      color: AppColors.primary,
                      fontSize: findFontSize(screenWidth, 12),
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("TTS: Play/Pause Tapped. IsPlaying: $isPlaying");
                  if (isPlaying) {
                    _stop();
                  } else {
                    _speak();
                  }
                },
                child: Container(
                  width: findWidth(screenWidth, 40),
                  height: findWidth(screenWidth, 40),
                  decoration: const BoxDecoration(
                    color: AppColors.primary, // Blue color from image
                    shape: BoxShape.circle,
                  ),
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                ),
              ),
            ],
          ),
          if (isPlaying) ...[
            SizedBox(height: findWidth(screenWidth, 20)),
             CustomText(
              text: "Playing Audio...",
              color: AppColors.primary,
              fontSize: findFontSize(screenWidth, 12),
              fontWeight: FontWeight.w600,
            ),
          ],
        ],
      ),
    );
  }
}

class InfoCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(findWidth(screenWidth, 16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(findWidth(screenWidth, 8)),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: findFontSize(screenWidth, 20)),
          ),
          SizedBox(width: findWidth(screenWidth, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: label,
                  color: const Color(0xFF5E6575), // Specifically distinct from AppColors.textGrey
                  fontSize: findFontSize(screenWidth, 11),
                  fontWeight: FontWeight.w600,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: findHeight(screenHeight, 2)), // Small gap
                CustomText(
                  text: value,
                  color: AppColors.textDefault,
                  fontSize: findFontSize(screenWidth, 14),
                  fontWeight: FontWeight.w600,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TranscriptionWidget extends StatelessWidget {
  final String text;
  final List<String> keywords;

  const TranscriptionWidget({
    super.key,
    required this.text,
    required this.keywords,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(findWidth(screenWidth, 20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.primary, size: findFontSize(screenWidth, 18)),
                  SizedBox(width: findWidth(screenWidth, 8)),
                  CustomText(
                    text: "AI TRANSCRIPTION",
                    color: AppColors.textDefault,
                    fontSize: findFontSize(screenWidth, 12),
                    fontWeight: FontWeight.w700,
                    // letterSpacing: 1.0, 
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: CustomText(
                  text: "COPY",
                  color: AppColors.primary,
                  fontSize: findFontSize(screenWidth, 12),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: findWidth(screenWidth, 16)),
          CustomText(
            text: text,
            color: AppColors.textDefault,
            fontSize: findFontSize(screenWidth, 14),
            fontWeight: FontWeight.w400,
            maxLine: 10,
            // height: 1.6,
          ),
          SizedBox(height: findWidth(screenWidth, 24)),
          CustomText(
            text: "DETECTED KEYWORDS",
            color: const Color(0xFF5E6575), // Darker grey/blue
            fontSize: findFontSize(screenWidth, 11),
            fontWeight: FontWeight.w700,
            // letterSpacing: 0.5,
          ),
          SizedBox(height: findWidth(screenWidth, 12)),
          Wrap(
            spacing: findWidth(screenWidth, 8),
            runSpacing: findWidth(screenWidth, 8),
            children: keywords.map((keyword) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: findWidth(screenWidth, 12), vertical: findWidth(screenWidth, 6)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: CustomText(
                  text: "#$keyword",
                  color: AppColors.textDefault,
                  fontSize: findFontSize(screenWidth, 12),
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
