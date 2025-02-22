import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ollamb/src/widgets/circle_button.dart';
import 'package:ollamb/src/widgets/style.dart';
import 'package:wee_kit/wee_kit.dart';

class ImagePreview extends StatelessWidget {
  final Uint8List? image;
  const ImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    if (image == null) return const SizedBox();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      color: Colors.grey,
      child: InkWell(
        onTap: () => onImageTap(context),
        child: Image.memory(
          key: key,
          image!,
          fit: BoxFit.cover,
          height: 120,
          width: 120,
          gaplessPlayback: true,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else {
              return WeeAnimated(
                transition: const WeeFadeTransition(),
                child: child,
              );
            }
          },
        ),
      ),
    );
  }

  void onImageTap(BuildContext context) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            child: SizedBox(
              child: Stack(
                children: [
                  Image.memory(
                    image!,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      } else {
                        return WeeAnimated(transition: const WeeFadeTransition(), child: child);
                      }
                    },
                  ),
                  CircleButton(
                    padding: const EdgeInsets.all(8),
                    height: 35,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close, size: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DocumentPreview extends StatelessWidget {
  final String? fileName;
  const DocumentPreview({super.key, required this.fileName});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.doc, color: Theme.of(context).colorScheme.primary, size: 16),
          const SizedBox(width: 3),
          Text(
            fileName ?? "",
            style: textStyle.copyWith(color: schemeColor(context).primary, decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
