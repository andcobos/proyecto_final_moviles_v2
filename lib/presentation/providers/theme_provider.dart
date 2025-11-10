import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

// Lista de colores disponible (se expone para widgets que quieran mostrar opciones)
final colorListProvider = Provider((ref) => colorList);

// Provider principal que maneja AppTheme
final themeNotifierProvider = NotifierProvider<ThemeNotifier, AppTheme>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() => AppTheme(); // estado inicial

  void toggleDarkmode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);
  }
}
