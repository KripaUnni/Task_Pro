import '../../../constants/app_strings.dart';
import '../../../constants/app_styles.dart';
import '../../../constants/goal_icons.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/widget_extension.dart';
import 'icon_select_dialog_view.dart';
import '../../../widgets/animated_dialog.dart';
import '../../../widgets/goal_widgets/quick_tags.dart';
import '../../../widgets/scaled_text.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/goal_widgets/title_with_textfield.dart';
import 'create_goal_view_model.dart';

class CreateGoalView extends StatefulWidget {
  const CreateGoalView({Key? key}) : super(key: key);

  @override
  State<CreateGoalView> createState() => _CreateGoalViewState();
}

class _CreateGoalViewState extends CreateGoalViewModel {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rippleController, 
      builder: (context, child){
        return ClipPath(
          clipper: WaveClipper(value: rippleController.value),
          child: child,
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(AppStrings.goalAppBarTitle),
          backgroundColor: Colors.white,
          leading: BackButton(onPressed: () => rippleController.reverse().then((value) => Navigator.pop(context))),
        ),
        body: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              QuickTags(tagIndex: (index) => setQuickTag(index)),
              titleTextField(),
              descriptionTextField(),
              selectIconButton(),
              selectGoalColor(),
            ],
          ),
          Column(
            children: [
              saveButton(),
              cancelButton(),
            ],
          )
        ],
      ).wrapPadding(AppPaddings.all8),
    );
  }

  TitleWithTextField titleTextField() {
    return TitleWithTextField(
      titleText: AppStrings.goalTextFieldTitle, 
      hintText: AppStrings.goalHintText, 
      controller: goalTitleController
    );
  }

  TitleWithTextField descriptionTextField() {
    return TitleWithTextField(
      titleText: AppStrings.goalTextFieldDesc, 
      hintText: AppStrings.description, 
      controller: goalDescController
    );
  }

  Widget selectIconButton() {
    return SizedBox(
      width: double.infinity,
      height: context.dynamicHeight(0.065),
      child: ElevatedButton(
        onPressed: (){      
          AnimatedDialog.showDialog(
            context: context, 
            dialogPageContent: IconSelectDialogView(
              iconIndexCallback: (index) => setState(() => selectedIconIndex = index),
            )
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(GoalIcons.goalIconList[selectedIconIndex], size: selectIconSize).wrapFitted(), 
            const ScaledText(text: AppStrings.selectIcon, style: AppTextStyles.generalTextStyle),
            Icon(Icons.chevron_right,size: selectIconSize), 
          ],
        ),
      ),
    );
  }

  Widget selectGoalColor() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
      ),
      itemCount: AppColors.goalColors.length,
      itemBuilder: (BuildContext context, int index) {
        return colorTile(index);
      },
    ).wrapPadding(AppPaddings.top8);
  }

  Widget colorTile(int index){
    return InkWell(
      onTap: () {
        setState(() {
          selectedColorIndex = index;
        });
      },
      child: Stack(
        children: [
          SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: AppRadius.all8,
                color: AppColors.goalColors[index],
              ),
            ).wrapPadding(AppPaddings.all4),
          ),
          selectedColorIndex == index 
            ? Positioned.fill(child: const Icon(Icons.task_alt, color: AppColors.white, size: 48).wrapAlign(Alignment.center)) 
            : const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget saveButton() {
    return SizedBox(
      width: double.infinity,
      height: context.dynamicHeight(0.060),
      child: ElevatedButton(
        onPressed: addGoal, 
        child: const ScaledText(text: AppStrings.save, style: AppTextStyles.generalTextStyle)),
    );
  }  
  
  Widget cancelButton() {
    return SizedBox(
      width: double.infinity,
      height: context.dynamicHeight(0.060),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cancelRed,
        ),
        onPressed: animateAndPop, 
        child: const ScaledText(text: AppStrings.cancel, style: AppTextStyles.generalTextStyle)),
    ).wrapPadding(AppPaddings.top8);
  }
  
}


