import 'package:flutter/material.dart';
import 'ursa_season.dart';

/// Complete Radix Colors palette — all 8 scales × 12 steps × light + dark.
///
/// Each scale has 12 steps (1=lightest, 12=darkest) plus a contrast
/// variant for text-on-accent use cases.
class RadixColors {
  RadixColors._(); // prevent instantiation

  // ── Sky (Winter accent / default) ───────────────────────────

  /// Light
  static const sky1 = Color(0xFFF9FEFF);
  static const sky2 = Color(0xFFF1FCFF);
  static const sky3 = Color(0xFFE4F9FF);
  static const sky4 = Color(0xFFD5F4FD);
  static const sky5 = Color(0xFFC3ECF9);
  static const sky6 = Color(0xFFAEE0F3);
  static const sky7 = Color(0xFF91D1EA);
  static const sky8 = Color(0xFF5EB9DB);
  static const sky9 = Color(0xFF68C7EC);
  static const sky10 = Color(0xFF54B5DB);
  static const sky11 = Color(0xFF1F7A9E);
  static const sky12 = Color(0xFF173E4F);
  static const skyContrast = Color(0xFF0B2029);

  /// Dark
  static const sky1Dark = Color(0xFF0D141F);
  static const sky2Dark = Color(0xFF111A27);
  static const sky3Dark = Color(0xFF112840);
  static const sky4Dark = Color(0xFF113555);
  static const sky5Dark = Color(0xFF154467);
  static const sky6Dark = Color(0xFF1B537B);
  static const sky7Dark = Color(0xFF1F6692);
  static const sky8Dark = Color(0xFF197CAE);
  static const sky9Dark = Color(0xFF7CE2FE);
  static const sky10Dark = Color(0xFFA8EEFF);
  static const sky11Dark = Color(0xFF75C7F0);
  static const sky12Dark = Color(0xFFC2F3FF);

  // ── Violet (Spring accent) ──────────────────────────────────

  /// Light
  static const violet1 = Color(0xFFFDFCFE);
  static const violet2 = Color(0xFFFBF8FF);
  static const violet3 = Color(0xFFF5F0FF);
  static const violet4 = Color(0xFFEDE3FE);
  static const violet5 = Color(0xFFE3D2FD);
  static const violet6 = Color(0xFFD4BAF9);
  static const violet7 = Color(0xFFBE9AF4);
  static const violet8 = Color(0xFF9F6EEC);
  static const violet9 = Color(0xFF8B5CF6);
  static const violet10 = Color(0xFF7C3AED);
  static const violet11 = Color(0xFF6D28D9);
  static const violet12 = Color(0xFF2E1065);
  static const violetContrast = Color(0xFF1C0637);

  /// Dark
  static const violet1Dark = Color(0xFF14121F);
  static const violet2Dark = Color(0xFF1B1525);
  static const violet3Dark = Color(0xFF291F43);
  static const violet4Dark = Color(0xFF33255B);
  static const violet5Dark = Color(0xFF3C2E69);
  static const violet6Dark = Color(0xFF473876);
  static const violet7Dark = Color(0xFF56468B);
  static const violet8Dark = Color(0xFF6958AD);
  static const violet9Dark = Color(0xFF6E56CF);
  static const violet10Dark = Color(0xFF7D66D9);
  static const violet11Dark = Color(0xFFBAA7FF);
  static const violet12Dark = Color(0xFFE2DDFE);

  // ── Green (Summer accent) ───────────────────────────────────

  /// Light
  static const green1 = Color(0xFFFBFEFC);
  static const green2 = Color(0xFFF2FCF5);
  static const green3 = Color(0xFFE6F7EB);
  static const green4 = Color(0xFFD7F1DF);
  static const green5 = Color(0xFFC2E8CF);
  static const green6 = Color(0xFFA6DBBA);
  static const green7 = Color(0xFF80CBA0);
  static const green8 = Color(0xFF46B67A);
  static const green9 = Color(0xFF30A46C);
  static const green10 = Color(0xFF29925D);
  static const green11 = Color(0xFF1F7A4A);
  static const green12 = Color(0xFF163328);
  static const greenContrast = Color(0xFF0C1F17);

  /// Dark
  static const green1Dark = Color(0xFF0E1512);
  static const green2Dark = Color(0xFF121B17);
  static const green3Dark = Color(0xFF132D21);
  static const green4Dark = Color(0xFF113B29);
  static const green5Dark = Color(0xFF174933);
  static const green6Dark = Color(0xFF20573E);
  static const green7Dark = Color(0xFF28684A);
  static const green8Dark = Color(0xFF2F7C57);
  static const green9Dark = Color(0xFF30A46C);
  static const green10Dark = Color(0xFF33B074);
  static const green11Dark = Color(0xFF3DD68C);
  static const green12Dark = Color(0xFFB1F1CB);

  // ── Orange (Autumn accent) ──────────────────────────────────

  /// Light
  static const orange1 = Color(0xFFFEFCFB);
  static const orange2 = Color(0xFFFEF8F4);
  static const orange3 = Color(0xFFFFF1E7);
  static const orange4 = Color(0xFFFFE8D7);
  static const orange5 = Color(0xFFFFDCC3);
  static const orange6 = Color(0xFFFFCCA7);
  static const orange7 = Color(0xFFFFB57D);
  static const orange8 = Color(0xFFFA934E);
  static const orange9 = Color(0xFFF57E22);
  static const orange10 = Color(0xFFE66B0C);
  static const orange11 = Color(0xFFC2560A);
  static const orange12 = Color(0xFF4C2008);
  static const orangeContrast = Color(0xFF2B1003);

  /// Dark
  static const orange1Dark = Color(0xFF17120E);
  static const orange2Dark = Color(0xFF1E160F);
  static const orange3Dark = Color(0xFF331E0B);
  static const orange4Dark = Color(0xFF462100);
  static const orange5Dark = Color(0xFF562800);
  static const orange6Dark = Color(0xFF66350C);
  static const orange7Dark = Color(0xFF7E451D);
  static const orange8Dark = Color(0xFFA35829);
  static const orange9Dark = Color(0xFFF76B15);
  static const orange10Dark = Color(0xFFFF801F);
  static const orange11Dark = Color(0xFFFFA057);
  static const orange12Dark = Color(0xFFFFE0C2);

  // ── Slate (Winter gray / default gray) ──────────────────────

  /// Light
  static const slate1 = Color(0xFFFCFCFD);
  static const slate2 = Color(0xFFF8F9FA);
  static const slate3 = Color(0xFFF1F3F5);
  static const slate4 = Color(0xFFECEEF0);
  static const slate5 = Color(0xFFE6E8EB);
  static const slate6 = Color(0xFFDFE1E5);
  static const slate7 = Color(0xFFD7DBE0);
  static const slate8 = Color(0xFFC1C7CD);
  static const slate9 = Color(0xFF89939E);
  static const slate10 = Color(0xFF7C8792);
  static const slate11 = Color(0xFF606A76);
  static const slate12 = Color(0xFF1A202C);
  static const slateContrast = Color(0xFF0D1117);

  /// Dark
  static const slate1Dark = Color(0xFF111113);
  static const slate2Dark = Color(0xFF18191B);
  static const slate3Dark = Color(0xFF212225);
  static const slate4Dark = Color(0xFF272A2D);
  static const slate5Dark = Color(0xFF2E3135);
  static const slate6Dark = Color(0xFF363A3F);
  static const slate7Dark = Color(0xFF43484E);
  static const slate8Dark = Color(0xFF5A6169);
  static const slate9Dark = Color(0xFF696E77);
  static const slate10Dark = Color(0xFF777B84);
  static const slate11Dark = Color(0xFFB0B4BA);
  static const slate12Dark = Color(0xFFEDEEF0);

  // ── Mauve (Spring gray) ─────────────────────────────────────

  /// Light
  static const mauve1 = Color(0xFFFDFCFD);
  static const mauve2 = Color(0xFFF9F8F9);
  static const mauve3 = Color(0xFFF4F2F4);
  static const mauve4 = Color(0xFFEEEDEF);
  static const mauve5 = Color(0xFFE9E7EA);
  static const mauve6 = Color(0xFFE2DFE4);
  static const mauve7 = Color(0xFFDAD6DD);
  static const mauve8 = Color(0xFFCAC4D0);
  static const mauve9 = Color(0xFF938C99);
  static const mauve10 = Color(0xFF86808C);
  static const mauve11 = Color(0xFF6A6573);
  static const mauve12 = Color(0xFF1E1B24);
  static const mauveContrast = Color(0xFF111018);

  /// Dark
  static const mauve1Dark = Color(0xFF121113);
  static const mauve2Dark = Color(0xFF1A191B);
  static const mauve3Dark = Color(0xFF232225);
  static const mauve4Dark = Color(0xFF2B292D);
  static const mauve5Dark = Color(0xFF323035);
  static const mauve6Dark = Color(0xFF3C393F);
  static const mauve7Dark = Color(0xFF49474E);
  static const mauve8Dark = Color(0xFF625F69);
  static const mauve9Dark = Color(0xFF6F6D78);
  static const mauve10Dark = Color(0xFF7C7A85);
  static const mauve11Dark = Color(0xFFB5B2BC);
  static const mauve12Dark = Color(0xFFEEEEF0);

  // ── Sage (Summer gray) ──────────────────────────────────────

  /// Light
  static const sage1 = Color(0xFFFBFDFC);
  static const sage2 = Color(0xFFF6F9F7);
  static const sage3 = Color(0xFFEFF4F0);
  static const sage4 = Color(0xFFE7EFE8);
  static const sage5 = Color(0xFFDFE9E0);
  static const sage6 = Color(0xFFD4E0D5);
  static const sage7 = Color(0xFFC5D4C7);
  static const sage8 = Color(0xFFADC0AF);
  static const sage9 = Color(0xFF7C8C7E);
  static const sage10 = Color(0xFF707E72);
  static const sage11 = Color(0xFF5B6860);
  static const sage12 = Color(0xFF1A211C);
  static const sageContrast = Color(0xFF0F1410);

  /// Dark
  static const sage1Dark = Color(0xFF101211);
  static const sage2Dark = Color(0xFF171918);
  static const sage3Dark = Color(0xFF202221);
  static const sage4Dark = Color(0xFF272A29);
  static const sage5Dark = Color(0xFF2E3130);
  static const sage6Dark = Color(0xFF373B39);
  static const sage7Dark = Color(0xFF444947);
  static const sage8Dark = Color(0xFF5B625F);
  static const sage9Dark = Color(0xFF63706B);
  static const sage10Dark = Color(0xFF717D79);
  static const sage11Dark = Color(0xFFADB5B2);
  static const sage12Dark = Color(0xFFECEEED);

  // ── Sand (Autumn gray) ──────────────────────────────────────

  /// Light
  static const sand1 = Color(0xFFFDFDFC);
  static const sand2 = Color(0xFFF9F9F8);
  static const sand3 = Color(0xFFF2F0EE);
  static const sand4 = Color(0xFFEBE8E5);
  static const sand5 = Color(0xFFE4E0DC);
  static const sand6 = Color(0xFFDBD6D0);
  static const sand7 = Color(0xFFD1CBC2);
  static const sand8 = Color(0xFFBEB5AA);
  static const sand9 = Color(0xFF8C8276);
  static const sand10 = Color(0xFF7F776C);
  static const sand11 = Color(0xFF6A6259);
  static const sand12 = Color(0xFF1F1C18);
  static const sandContrast = Color(0xFF12100E);

  /// Dark
  static const sand1Dark = Color(0xFF111110);
  static const sand2Dark = Color(0xFF191918);
  static const sand3Dark = Color(0xFF222221);
  static const sand4Dark = Color(0xFF2A2A28);
  static const sand5Dark = Color(0xFF31312E);
  static const sand6Dark = Color(0xFF3B3A37);
  static const sand7Dark = Color(0xFF494844);
  static const sand8Dark = Color(0xFF62605B);
  static const sand9Dark = Color(0xFF6F6D66);
  static const sand10Dark = Color(0xFF7C7B74);
  static const sand11Dark = Color(0xFFB5B3AD);
  static const sand12Dark = Color(0xFFEEEEEC);

  // ── Accent/Gray selection helpers ───────────────────────────

  /// Pick the light-mode accent color set for a given season.
  static ({Color c1, Color c2, Color c3, Color c4, Color c5,
            Color c6, Color c7, Color c8, Color c9, Color c10,
            Color c11, Color c12, Color contrast}) accentLight(Season season) {
    return switch (season) {
      Season.winter => (
        c1: sky1, c2: sky2, c3: sky3, c4: sky4, c5: sky5,
        c6: sky6, c7: sky7, c8: sky8, c9: sky9, c10: sky10,
        c11: sky11, c12: sky12, contrast: skyContrast,
      ),
      Season.spring => (
        c1: violet1, c2: violet2, c3: violet3, c4: violet4, c5: violet5,
        c6: violet6, c7: violet7, c8: violet8, c9: violet9, c10: violet10,
        c11: violet11, c12: violet12, contrast: violetContrast,
      ),
      Season.summer => (
        c1: green1, c2: green2, c3: green3, c4: green4, c5: green5,
        c6: green6, c7: green7, c8: green8, c9: green9, c10: green10,
        c11: green11, c12: green12, contrast: greenContrast,
      ),
      Season.autumn => (
        c1: orange1, c2: orange2, c3: orange3, c4: orange4, c5: orange5,
        c6: orange6, c7: orange7, c8: orange8, c9: orange9, c10: orange10,
        c11: orange11, c12: orange12, contrast: orangeContrast,
      ),
    };
  }

  /// Pick the dark-mode accent color set for a given season.
  static ({Color c1, Color c2, Color c3, Color c4, Color c5,
            Color c6, Color c7, Color c8, Color c9, Color c10,
            Color c11, Color c12, Color contrast}) accentDark(Season season) {
    return switch (season) {
      Season.winter => (
        c1: sky1Dark, c2: sky2Dark, c3: sky3Dark, c4: sky4Dark, c5: sky5Dark,
        c6: sky6Dark, c7: sky7Dark, c8: sky8Dark, c9: sky9Dark, c10: sky10Dark,
        c11: sky11Dark, c12: sky12Dark, contrast: skyContrast,
      ),
      Season.spring => (
        c1: violet1Dark, c2: violet2Dark, c3: violet3Dark, c4: violet4Dark,
        c5: violet5Dark, c6: violet6Dark, c7: violet7Dark, c8: violet8Dark,
        c9: violet9Dark, c10: violet10Dark, c11: violet11Dark, c12: violet12Dark,
        contrast: violetContrast,
      ),
      Season.summer => (
        c1: green1Dark, c2: green2Dark, c3: green3Dark, c4: green4Dark,
        c5: green5Dark, c6: green6Dark, c7: green7Dark, c8: green8Dark,
        c9: green9Dark, c10: green10Dark, c11: green11Dark, c12: green12Dark,
        contrast: greenContrast,
      ),
      Season.autumn => (
        c1: orange1Dark, c2: orange2Dark, c3: orange3Dark, c4: orange4Dark,
        c5: orange5Dark, c6: orange6Dark, c7: orange7Dark, c8: orange8Dark,
        c9: orange9Dark, c10: orange10Dark, c11: orange11Dark, c12: orange12Dark,
        contrast: orangeContrast,
      ),
    };
  }

  /// Pick the light-mode gray color set for a given season.
  static ({Color c1, Color c2, Color c3, Color c4, Color c5,
            Color c6, Color c7, Color c8, Color c9, Color c10,
            Color c11, Color c12}) grayLight(Season season) {
    return switch (season) {
      Season.winter => (
        c1: slate1, c2: slate2, c3: slate3, c4: slate4, c5: slate5,
        c6: slate6, c7: slate7, c8: slate8, c9: slate9, c10: slate10,
        c11: slate11, c12: slate12,
      ),
      Season.spring => (
        c1: mauve1, c2: mauve2, c3: mauve3, c4: mauve4, c5: mauve5,
        c6: mauve6, c7: mauve7, c8: mauve8, c9: mauve9, c10: mauve10,
        c11: mauve11, c12: mauve12,
      ),
      Season.summer => (
        c1: sage1, c2: sage2, c3: sage3, c4: sage4, c5: sage5,
        c6: sage6, c7: sage7, c8: sage8, c9: sage9, c10: sage10,
        c11: sage11, c12: sage12,
      ),
      Season.autumn => (
        c1: sand1, c2: sand2, c3: sand3, c4: sand4, c5: sand5,
        c6: sand6, c7: sand7, c8: sand8, c9: sand9, c10: sand10,
        c11: sand11, c12: sand12,
      ),
    };
  }

  /// Pick the dark-mode gray color set for a given season.
  static ({Color c1, Color c2, Color c3, Color c4, Color c5,
            Color c6, Color c7, Color c8, Color c9, Color c10,
            Color c11, Color c12}) grayDark(Season season) {
    return switch (season) {
      Season.winter => (
        c1: slate1Dark, c2: slate2Dark, c3: slate3Dark, c4: slate4Dark,
        c5: slate5Dark, c6: slate6Dark, c7: slate7Dark, c8: slate8Dark,
        c9: slate9Dark, c10: slate10Dark, c11: slate11Dark, c12: slate12Dark,
      ),
      Season.spring => (
        c1: mauve1Dark, c2: mauve2Dark, c3: mauve3Dark, c4: mauve4Dark,
        c5: mauve5Dark, c6: mauve6Dark, c7: mauve7Dark, c8: mauve8Dark,
        c9: mauve9Dark, c10: mauve10Dark, c11: mauve11Dark, c12: mauve12Dark,
      ),
      Season.summer => (
        c1: sage1Dark, c2: sage2Dark, c3: sage3Dark, c4: sage4Dark,
        c5: sage5Dark, c6: sage6Dark, c7: sage7Dark, c8: sage8Dark,
        c9: sage9Dark, c10: sage10Dark, c11: sage11Dark, c12: sage12Dark,
      ),
      Season.autumn => (
        c1: sand1Dark, c2: sand2Dark, c3: sand3Dark, c4: sand4Dark,
        c5: sand5Dark, c6: sand6Dark, c7: sand7Dark, c8: sand8Dark,
        c9: sand9Dark, c10: sand10Dark, c11: sand11Dark, c12: sand12Dark,
      ),
    };
  }
}

/// Custom theme extension providing semantic tokens beyond Material's defaults.
///
/// Access via: `Theme.of(context).extension<UrsaColors>()!`
class UrsaColors extends ThemeExtension<UrsaColors> {
  /// Canvas background (gray-1)
  final Color backgroundCanvas;

  /// Subtle surface (gray-2)
  final Color backgroundSubtle;

  /// High-contrast text (gray-12)
  final Color textHighContrast;

  /// Low-contrast text (gray-11)
  final Color textLowContrast;

  /// Subtle border (gray-6)
  final Color borderSubtle;

  /// Hover border (gray-7)
  final Color borderHover;

  /// Subtle solid surface (gray-3)
  final Color solidDefault;

  /// Interactive hover state (accent-3) — maps to --color-interactive-default
  final Color interactiveDefault;

  /// Accent color (step 9)
  final Color accent9;

  /// Accent color (step 11)
  final Color accent11;

  /// Contrast text for accent backgrounds
  final Color accentContrast;

  /// Subtle shadow
  final Color shadowSubtle;

  /// Current season label
  final String seasonLabel;

  /// Current season emoji
  final String seasonEmoji;

  const UrsaColors({
    required this.backgroundCanvas,
    required this.backgroundSubtle,
    required this.textHighContrast,
    required this.textLowContrast,
    required this.borderSubtle,
    required this.borderHover,
    required this.solidDefault,
    required this.interactiveDefault,
    required this.accent9,
    required this.accent11,
    required this.accentContrast,
    required this.shadowSubtle,
    this.seasonLabel = '',
    this.seasonEmoji = '',
  });

  /// Light-mode instance for the given season.
  factory UrsaColors.light(Season season) {
    final a = RadixColors.accentLight(season);
    final g = RadixColors.grayLight(season);
    return UrsaColors(
      backgroundCanvas: g.c1,
      backgroundSubtle: g.c2,
      textHighContrast: g.c12,
      textLowContrast: g.c11,
      borderSubtle: g.c3,
      borderHover: g.c7,
      solidDefault: g.c4,
      interactiveDefault: a.c3,
      accent9: a.c9,
      accent11: a.c11,
      accentContrast: a.contrast,
      shadowSubtle: const Color(0x14000000),
      seasonLabel: season.label,
      seasonEmoji: season.emoji,
    );
  }

  /// Dark-mode instance for the given season.
  factory UrsaColors.dark(Season season) {
    final a = RadixColors.accentDark(season);
    final g = RadixColors.grayDark(season);
    return UrsaColors(
      backgroundCanvas: g.c1,
      backgroundSubtle: g.c2,
      textHighContrast: g.c12,
      textLowContrast: g.c11,
      borderSubtle: g.c3,
      borderHover: g.c7,
      solidDefault: g.c5,
      interactiveDefault: a.c3,
      accent9: a.c9,
      accent11: a.c11,
      accentContrast: a.contrast,
      shadowSubtle: const Color(0x66000000),
      seasonLabel: season.label,
      seasonEmoji: season.emoji,
    );
  }

  @override
  UrsaColors copyWith({
    Color? backgroundCanvas,
    Color? backgroundSubtle,
    Color? textHighContrast,
    Color? textLowContrast,
    Color? borderSubtle,
    Color? borderHover,
    Color? solidDefault,
    Color? interactiveDefault,
    Color? accent9,
    Color? accent11,
    Color? accentContrast,
    Color? shadowSubtle,
    String? seasonLabel,
    String? seasonEmoji,
  }) {
    return UrsaColors(
      backgroundCanvas: backgroundCanvas ?? this.backgroundCanvas,
      backgroundSubtle: backgroundSubtle ?? this.backgroundSubtle,
      textHighContrast: textHighContrast ?? this.textHighContrast,
      textLowContrast: textLowContrast ?? this.textLowContrast,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderHover: borderHover ?? this.borderHover,
      solidDefault: solidDefault ?? this.solidDefault,
      interactiveDefault: interactiveDefault ?? this.interactiveDefault,
      accent9: accent9 ?? this.accent9,
      accent11: accent11 ?? this.accent11,
      accentContrast: accentContrast ?? this.accentContrast,
      shadowSubtle: shadowSubtle ?? this.shadowSubtle,
      seasonLabel: seasonLabel ?? this.seasonLabel,
      seasonEmoji: seasonEmoji ?? this.seasonEmoji,
    );
  }

  @override
  UrsaColors lerp(ThemeExtension<UrsaColors>? other, double t) {
    if (other is! UrsaColors) return this;
    return UrsaColors(
      backgroundCanvas: Color.lerp(backgroundCanvas, other.backgroundCanvas, t)!,
      backgroundSubtle: Color.lerp(backgroundSubtle, other.backgroundSubtle, t)!,
      textHighContrast: Color.lerp(textHighContrast, other.textHighContrast, t)!,
      textLowContrast: Color.lerp(textLowContrast, other.textLowContrast, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderHover: Color.lerp(borderHover, other.borderHover, t)!,
      solidDefault: Color.lerp(solidDefault, other.solidDefault, t)!,
      interactiveDefault: Color.lerp(interactiveDefault, other.interactiveDefault, t)!,
      accent9: Color.lerp(accent9, other.accent9, t)!,
      accent11: Color.lerp(accent11, other.accent11, t)!,
      accentContrast: Color.lerp(accentContrast, other.accentContrast, t)!,
      shadowSubtle: Color.lerp(shadowSubtle, other.shadowSubtle, t)!,
      seasonLabel: t < 0.5 ? seasonLabel : other.seasonLabel,
      seasonEmoji: t < 0.5 ? seasonEmoji : other.seasonEmoji,
    );
  }
}

/// Infrastructure status colors — orthogonal to the seasonal Radix system.
///
/// Used by status indicators, badges, and alerts in the launcher and service UIs.
abstract final class UrsaStatusColors {
  UrsaStatusColors._();

  /// Online / success — green
  static const success = Color(0xFF3FB950);
  static const successMuted = Color(0xFF238636);
  static const successSubtle = Color(0xFF0B2E1A);

  /// Degraded / warning — orange
  static const warning = Color(0xFFDB6D28);
  static const warningMuted = Color(0xFF9E6A03);
  static const warningSubtle = Color(0xFF3D2E00);

  /// Offline / error — red
  static const error = Color(0xFFF85149);
  static const errorMuted = Color(0xFFDA3633);
  static const errorSubtle = Color(0xFF3D1117);

  /// Unknown / tertiary text
  static const unknown = Color(0xFF484F58);
}
