import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/components/colors.dart';


class HandOption extends StatefulWidget {
  final void Function()? onTap;
  final String handImage;

  const HandOption({
    Key? key,
    required this.onTap,
    required this.handImage,
  }) : super(key: key);

  @override
  State<HandOption> createState() => _HandOptionState();
}

class _HandOptionState extends State<HandOption> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Stack(
            children: [
              Container(
                height: 75.0,
                width: 75.0,
                margin: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 15,
                child: Image.asset(
                  widget.handImage,
                  height: 80.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
