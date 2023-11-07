import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final double fontSize;
  final double paddingHorizontal;
  final double paddingVertical;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double? borderSize;
  final bool disabled;

  const Button(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.fontSize = 18,
      this.paddingHorizontal = 12,
      this.paddingVertical = 15,
      this.color,
      this.textColor,
      this.borderColor,
      this.borderSize,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all((onPressed != null && disabled == false)
              ? (color ?? Colors.grey[700])
              : (color != null ? color!.withOpacity(0.5) : Colors.grey[700]!.withOpacity(0.5))),
          side: MaterialStateProperty.all(
            BorderSide(
              style: borderColor != null ? BorderStyle.solid : BorderStyle.none,
              width: borderSize ?? 3.0,
              color: borderColor ?? (color ?? Colors.grey[700]!),
            ),
          )),
      onPressed: disabled
          ? null
          : onPressed != null
              ? () => onPressed!()
              : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: textColor ?? Colors.grey[200]),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ButtonIcon extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Function? onPressed;
  final double iconSize;
  final double fontSize;
  final double paddingHorizontal;
  final double paddingVertical;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderSize;
  final bool disabled;

  const ButtonIcon(
      {Key? key,
      required this.icon,
      this.text,
      required this.onPressed,
      this.iconSize = 18,
      this.fontSize = 18,
      this.paddingHorizontal = 12,
      this.paddingVertical = 15,
      this.color,
      this.iconColor,
      this.textColor,
      this.borderColor,
      this.borderSize,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all((onPressed != null && disabled == false)
              ? (color ?? Colors.grey[700])
              : (color != null ? color!.withOpacity(0.5) : Colors.grey[700]!.withOpacity(0.5))),
          side: MaterialStateProperty.all(
            BorderSide(
              style: borderColor != null ? BorderStyle.solid : BorderStyle.none,
              width: borderSize ?? 3.0,
              color: borderColor ?? (color ?? Colors.grey[700]!),
            ),
          )),
      onPressed: disabled
          ? null
          : onPressed != null
              ? () => onPressed!()
              : null,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
          child: Builder(
            builder: (context) {
              Widget iconWidget = Icon(
                icon,
                size: iconSize,
                color: iconColor ?? Colors.grey[200],
              );

              if (text != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconWidget,
                    const Padding(padding: EdgeInsets.only(right: 15)),
                    Text(
                      text!,
                      style: TextStyle(fontSize: fontSize, color: textColor ?? Colors.grey[200]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else {
                return iconWidget;
              }
            },
          )),
    );
  }
}
