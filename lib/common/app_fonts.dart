import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppFonts {
  static get pizzaTitleFont => GoogleFonts.playfairDisplay(
    color: Colors.black,
    fontSize: 25.0,
      fontWeight: FontWeight.w500
  );

  static get pizzaDescriptionFont =>  GoogleFonts.playfairDisplay(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
  );

  static get pizzaPriceFont => const TextStyle(fontSize: 30.0,fontFamily: 'georgia',fontWeight: FontWeight.w500);
}
