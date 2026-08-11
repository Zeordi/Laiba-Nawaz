import 'package:flutter/material.dart';
import 'package:voxflow/core/color/app_colors.dart';
import 'package:voxflow/core/utility/find_size.dart';
import 'package:voxflow/core/widget/custom_text.dart';

class TaskFilterList extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const TaskFilterList({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final List<String> filters = const [
    "All",
    "Pending",
    "Completed",
    "Rejected",
    "My Task"
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: findWidth(screenWidth, 12)),
            child: InkWell(
              onTap: () => onFilterSelected(filter),
              borderRadius: BorderRadius.circular(findWidth(screenWidth, 24)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: findWidth(screenWidth, 24),
                  vertical: findWidth(screenWidth, 12),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(findWidth(screenWidth, 24)),
                  border: isSelected ? null : Border.all(color: AppColors.border),
                ),
                child: CustomText(
                  text: filter,
                  fontSize: findFontSize(screenWidth, 14),
                  color: isSelected ? AppColors.white : AppColors.textDefault,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
