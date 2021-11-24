import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pizza_delivery/extensions/context_extension.dart';

class AppFonts {
  static const String georgiaFont = 'georgia';

  static get pizzaTitleFont => GoogleFonts.playfairDisplay(
    color: Colors.black,
    fontSize: 25.0,
    fontWeight: FontWeight.w500
  );

  static get pizzaDescriptionFont =>  TextStyle(
    color: Colors.grey.shade600,
    fontWeight: FontWeight.w600,
    fontFamily: georgiaFont,
    fontSize: 14.0,
  );

  static get pizzaPriceFont => const  TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontFamily: georgiaFont,
    fontSize: 28.0,
  );
}
