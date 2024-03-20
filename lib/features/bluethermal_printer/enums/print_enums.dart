enum SizePrint {
  medium, //normal size text
  bold, //only bold text
  boldMedium, //bold with medium
  boldLarge, //bold with large
  extraLarge //extra large
}

enum Align {
  left, //ESC_ALIGN_LEFT
  center, //ESC_ALIGN_CENTER
  right, //ESC_ALIGN_RIGHT
}

extension PrintSize on SizePrint {
  int get val {
    switch (this) {
      case SizePrint.medium:
        return 0;
      case SizePrint.bold:
        return 1;
      case SizePrint.boldMedium:
        return 2;
      case SizePrint.boldLarge:
        return 3;
      case SizePrint.extraLarge:
        return 4;
      default:
        return 0;
    }
  }
}

extension PrintAlign on Align {
  int get val {
    switch (this) {
      case Align.left:
        return 0;
      case Align.center:
        return 1;
      case Align.right:
        return 2;
      default:
        return 0;
    }
  }
}