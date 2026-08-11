import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


/// Theme mode provider (light/dark)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// App initialization provider
final appInitializedProvider = FutureProvider<bool>((ref) async {
  // Add any initialization logic here
  await Future.delayed(const Duration(seconds: 1));
  return true;
});