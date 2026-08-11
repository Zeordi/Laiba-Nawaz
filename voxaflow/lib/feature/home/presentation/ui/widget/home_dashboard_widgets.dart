import 'package:flutter/material.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';
import 'package:voxflow/feature/task/domain/entity/task_entity.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl; // For now acts as asset path or url
  final VoidCallback onProfileTap;

  const HomeHeader({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Good Evening,",
              fontSize: findFontSize(screenWidth, 14),
              color: const Color(0xFF5E6575), // Greyish
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: findWidth(screenWidth, 4)),
            CustomText(
              text: name,
              fontSize: findFontSize(screenWidth, 24),
              color: AppColors.textHeadline,
              fontWeight: FontWeight.w700,
              textFamily: 'Manrope', // Assuming font
            ),
            SizedBox(height: findWidth(screenWidth, 8)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: findWidth(screenWidth, 12), vertical: findWidth(screenWidth, 4)),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF), // Light indigo/purple
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomText(
                text: role,
                fontSize: findFontSize(screenWidth, 10),
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                // letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: findWidth(screenWidth, 44),
                height: findWidth(screenWidth, 44),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Fallback color
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/voxflow.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onRecordTap;

  const ActionButtonsRow({
    super.key,
    required this.onRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onRecordTap,
            child: Container(
              height: findWidth(screenWidth, 56),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x331717CF),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.mic, color: Colors.white, size: findFontSize(screenWidth, 20)),
                  SizedBox(width: findWidth(screenWidth, 8)),
                   CustomText(
                    text: "Record Voice",
                    fontSize: findFontSize(screenWidth, 14),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(findWidth(screenWidth, 24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "QUOTE OF THE DAY",
            fontSize: findFontSize(screenWidth, 10),
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            // letterSpacing: 1.0,
          ),
          SizedBox(height: findWidth(screenWidth, 16)),
          Stack(
            children: [
               CustomText(
                text: "\"The best way to predict the future is to create it through meaningful communication.\"",
                fontSize: findFontSize(screenWidth, 18),
                color: AppColors.textHeadline,
                fontWeight: FontWeight.w400, // Serif-like feel might need a font change
                textFamily: 'PlayfairDisplay', // Or similar serif font if available, fallback default
                maxLine: 4,
                // height: 1.4,
              ),
              // Could add large quote icon in background/top-right here if needed
            ],
          ),
          SizedBox(height: findWidth(screenWidth, 16)),
          CustomText(
            text: "— Management Insight",
            fontSize: findFontSize(screenWidth, 12),
            color: const Color(0xFF5E6575),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Widget icon;
  final Widget? badge;
  final Widget? footer;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.badge,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(findWidth(screenWidth, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              if (badge != null) badge!,
            ],
          ),
          const Spacer(), // Pushes content down
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: value,
              fontSize: findFontSize(screenWidth, 28),
              color: AppColors.textHeadline,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: findWidth(screenWidth, 4)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: label,
              fontSize: findFontSize(screenWidth, 12),
              color: const Color(0xFF5E6575),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (footer != null) ...[
            SizedBox(height: findWidth(screenWidth, 12)),
            footer!,
          ]
        ],
      ),
    );
  }
}

class RecentTasksList extends StatelessWidget {
  final VoidCallback onViewAllTap;
  final List<TaskEntity> tasks;

  const RecentTasksList({super.key, required this.onViewAllTap, this.tasks = const []});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(findWidth(screenWidth, 24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(findWidth(screenWidth, 8)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5), // Light purple
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Icon(Icons.assignment_turned_in, color: AppColors.primary, size: findFontSize(screenWidth, 20)),
              ),
              SizedBox(width: findWidth(screenWidth, 12)),
               Expanded( // Wrapped text in Expanded to prevent overflow
                 child: CustomText(
                  text: "Today's Tasks",
                  fontSize: findFontSize(screenWidth, 16),
                  color: AppColors.textHeadline,
                  fontWeight: FontWeight.w700,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                ),
               ),
              // const Spacer(), // Removed Spacer as Expanded takes space
              CustomText(
                text: "${tasks.where((e) => e.status == 'pending').length} Pending",
                fontSize: findFontSize(screenWidth, 12),
                color: const Color(0xFF5E6575),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(height: findWidth(screenWidth, 24)),
          if (tasks.isEmpty)
            Center(
              child: CustomText(
                text: "No tasks",
                fontSize: findFontSize(screenWidth, 14),
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            ...tasks.map((task) => Column(
              children: [
                _buildTaskItem(
                  screenWidth,
                  title: task.detailValue,
                  subtitle: "${task.departmentName} • ${task.created_at_formatted}", // Need formatting date or use raw
                  indicatorColor: task.priority == "high" ? AppColors.error : AppColors.warning,
                ),
                SizedBox(height: findWidth(screenWidth, 16)),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                SizedBox(height: findWidth(screenWidth, 16)),
              ],
            )),
        ],
      ),
    );
  }

  // actually TaskEntity has createdAt as String "2026-01-20T20:10:33.209367".

  Widget _buildTaskItem(double screenWidth, {required String title, required String subtitle, required Color indicatorColor}) {
    return Row(
      children: [
        Container(
          width: findWidth(screenWidth, 8),
          height: findWidth(screenWidth, 8),
          decoration: BoxDecoration(
            color: indicatorColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: findWidth(screenWidth, 16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontSize: findFontSize(screenWidth, 14),
                color: AppColors.textHeadline,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: findWidth(screenWidth, 4)),
              CustomText(
                text: subtitle,
                fontSize: findFontSize(screenWidth, 12),
                color: const Color(0xFF9095A0),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: Color(0xFFDDE1E6), size: findFontSize(screenWidth, 24)),
      ],
    );
  }
}

extension on TaskEntity {
  String get created_at_formatted {
     try {
       final dt = DateTime.parse(createdAt);
       return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
     } catch(e) {
       return "";
     }
  }
}
