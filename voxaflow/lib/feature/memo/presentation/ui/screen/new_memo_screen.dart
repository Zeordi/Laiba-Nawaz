import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/submit_task/presentation/state/submit_task_bloc.dart';
import 'package:voxflow/feature/submit_task/presentation/state/submit_task_event.dart';
import 'package:voxflow/feature/submit_task/presentation/state/submit_task_state.dart';
import 'package:voxflow/feature/home/presentation/state/home_bloc.dart';
import 'package:voxflow/feature/home/presentation/state/home_event.dart';

class NewMemoScreen extends StatelessWidget {
  final VoidCallback? onCancel;
  const NewMemoScreen({super.key, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return _NewMemoView(onCancel: onCancel);
  }
}

class _NewMemoView extends StatefulWidget {
  final VoidCallback? onCancel;
  const _NewMemoView({this.onCancel});

  @override
  State<_NewMemoView> createState() => _NewMemoViewState();
}

class _NewMemoViewState extends State<_NewMemoView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Responsive base
    final baseWidth = screenWidth.clamp(320.0, 600.0);
    final ringMax = (baseWidth * 0.72).clamp(240.0, 380.0);
    final micSize = (baseWidth * 0.28).clamp(120.0, 160.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<SubmitTaskBloc, SubmitTaskState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task submitted successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
              // Trigger dashboard refresh
              context.read<HomeBloc>().add(LoadHomeDataEvent());
              // Navigate back/reset
              widget.onCancel?.call();
            } else if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: BlocBuilder<SubmitTaskBloc, SubmitTaskState>(
          builder: (context, state) {
            
            // Format timer from state
            String two(int n) => n.toString().padLeft(2, '0');
            final hrs = two(state.elapsed.inHours);
            final mins = two(state.elapsed.inMinutes.remainder(60));
            final secs = two(state.elapsed.inSeconds.remainder(60));

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: findWidth(screenWidth, 20),
                vertical: findHeight(screenHeight, 10),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: CustomText(
                      text: 'Submit Task',
                      color: AppColors.textHeadline,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Voice/Text toggle
                  Container(
                    padding: EdgeInsets.all(findWidth(screenWidth, 6)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ToggleChip(
                          selected: state.isVoiceMode,
                          icon: Icons.mic,
                          label: 'Voice',
                          onTap: () => context.read<SubmitTaskBloc>().add(ToggleInputModeEvent(true)),
                        ),
                        SizedBox(width: findWidth(screenWidth, 8)),
                        _ToggleChip(
                          selected: !state.isVoiceMode,
                          icon: Icons.keyboard,
                          label: 'Text',
                          onTap: () => context.read<SubmitTaskBloc>().add(ToggleInputModeEvent(false)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: findHeight(screenHeight, 30)),

                  if (state.isVoiceMode)
                    _buildVoiceUI(context, state, hrs, mins, secs, screenWidth, screenHeight, ringMax, micSize, baseWidth)
                  else
                    _buildTextUI(context, state, screenWidth, screenHeight),
                ],
              ),
            );
          },
        ),
        ),
      ),
    );
  }

  Widget _buildVoiceUI(BuildContext context, SubmitTaskState state, String hrs, String mins, String secs, double screenWidth, double screenHeight, double ringMax, double micSize, double baseWidth) {
    return Column(
      children: [
        // Recording badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: findWidth(screenWidth, 16),
            vertical: findHeight(screenHeight, 8),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.fiber_manual_record, color: AppColors.error, size: 16),
              SizedBox(width: findWidth(screenWidth, 8)),
              const CustomText(
                text: 'RECORDING...',
                color: AppColors.textDefault,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),

        SizedBox(height: findHeight(screenHeight, 24)),

        // Timer display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimeItem(label: 'HR', value: hrs),
            SizedBox(width: findWidth(screenWidth, 18)),
            _TimeItem(label: 'MIN', value: mins),
            SizedBox(width: findWidth(screenWidth, 18)),
            _TimeItem(label: 'SEC', value: secs, highlight: true),
          ],
        ),

        SizedBox(height: findHeight(screenHeight, 40)),

        // Mic button with responsive rings
        SizedBox(
          height: ringMax + 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _Ring(size: ringMax),
              _Ring(size: ringMax * 0.82),
              _Ring(size: ringMax * 0.64),
              _Ring(size: ringMax * 0.46),
              Container(
                width: micSize,
                height: micSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(Icons.mic, color: Colors.white, size: (micSize * 0.35).clamp(44.0, 56.0)),
              ),
            ],
          ),
        ),

        SizedBox(height: findHeight(screenHeight, 16)),

        // Responsive Wave bars
        Builder(builder: (_) {
          final bars = (baseWidth / 18).floor();
          final barHeight = (baseWidth * 0.08).clamp(40.0, 72.0);
          return SizedBox(
            height: barHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(bars, (i) {
                final h = ((i % 5) + 1) * (barHeight / 6);
                return Container(
                  width: 6,
                  height: h,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          );
        }),

        SizedBox(height: findHeight(screenHeight, 30)),

        // Action Buttons
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomAction(
                icon: Icons.pause,
                label: 'Pause',
                onTap: () {}, // TODO: Implement pause event
              ),
              _BottomAction(
                icon: Icons.stop,
                label: 'Stop',
                isPrimary: true,
                onTap: widget.onCancel ?? () {},
              ),
              _BottomAction(
                icon: Icons.flag,
                label: 'Mark',
                onTap: () {},
              ),
            ],
          ),
        ),
         SizedBox(height: findHeight(screenHeight, 20)),
      ],
    );
  }

  Widget _buildTextUI(BuildContext context, SubmitTaskState state, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.5,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Type your memo here (min 50 chars)...',
                    hintStyle: TextStyle(
                      color: AppColors.textPlaceholder,
                      fontSize: 16,
                    ),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.submitting || _textController.text.length < 50 
                    ? null 
                    : () {
                       context.read<SubmitTaskBloc>().add(SubmitTextEvent(_textController.text));
                    },
                  icon: state.submitting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Icon(Icons.auto_awesome, size: 20),
                  label: Text(state.submitting ? 'Processing...' : 'Submit Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    disabledForegroundColor: Colors.white.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: findHeight(screenHeight, 30)),
        
        // Bottom Action Buttons for Text Mode
         Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               _TextAction(
                icon: Icons.delete_outline,
                label: 'Discard',
                onTap: widget.onCancel,
              ),
              _TextAction(
                icon: Icons.check,
                label: 'Save',
                isPrimary: true,
                onTap: () {
                  // TODO: Save logic
                },
              ),
              _TextAction(
                icon: Icons.ios_share,
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
        ),
         SizedBox(height: findHeight(screenHeight, 20)),
      ],
    );
  }
}

class _TextAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  const _TextAction({
    required this.icon, 
    required this.label, 
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.primary : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              color: isPrimary ? Colors.white : AppColors.textHeadline, // Based on screenshot, icons are dark or white
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomText(
          text: label,
          color: AppColors.textDefault,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}


class _ToggleChip extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ToggleChip({required this.selected, required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textDefault, size: 18),
            const SizedBox(width: 8),
            CustomText(
              text: label,
              color: selected ? AppColors.primary : AppColors.textDefault,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _TimeItem({required this.label, required this.value, this.highlight = false});
  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.primary : AppColors.textHeadline;
    return Column(
      children: [
        CustomText(
          text: value,
          color: color,
          fontSize: 48,
          fontWeight: FontWeight.w800,
        ),
        const SizedBox(height: 4),
        CustomText(
          text: label,
          color: AppColors.textDefault,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

class _Ring extends StatelessWidget {
  final double size;
  const _Ring({required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 2),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  const _BottomAction({required this.icon, required this.label, required this.onTap, this.isPrimary = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.primary : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isPrimary ? Colors.white : AppColors.textHeadline, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        CustomText(
          text: label,
          color: AppColors.textDefault,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
