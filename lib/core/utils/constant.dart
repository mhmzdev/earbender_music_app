import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Song Name Text Style
var kSongNameStyle = GoogleFonts.lato(
  color: Colors.grey[600],
  fontSize: 22,
  letterSpacing: 1.0,
  fontWeight: FontWeight.w500,
);

// Singer Name Style
var kSingerNameStyle = GoogleFonts.lato(
  color: Colors.grey[400],
  fontSize: 11,
  letterSpacing: 1.0,
  fontWeight: FontWeight.w500,
);

// Timer Text Style
var kTimerStyle = GoogleFonts.lato(
    color: Colors.grey[600],
    fontSize: 12.0,
    letterSpacing: 1.0,
    fontWeight: FontWeight.w500);

// Heading Text Style
var kHeadingStyle = TextStyle(
    color: Colors.grey[700],
    fontWeight: FontWeight.w600,
    letterSpacing: 2.0,
    fontSize: 18);

// Key in Shared Preferences for all saved music paths
final String CACHE_SAVED_MUSIC_PATHS = "paths";
