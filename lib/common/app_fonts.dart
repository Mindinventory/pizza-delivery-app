import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppFonts {
  static get pizzaTitleFont => GoogleFonts.poppins(
        textStyle: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 23,
            fontWeight: FontWeight.w500),
      );

  static get pizzaDescriptionFont => GoogleFonts.poppins(
        textStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14),
      );

  static get pizzaPriceFont => const TextStyle(
      color: Colors.black, fontSize: 27, fontWeight: FontWeight.w600,fontFamily: 'georgia');
}
