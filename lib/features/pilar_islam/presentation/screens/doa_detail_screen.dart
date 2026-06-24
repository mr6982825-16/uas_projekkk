import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/features/pilar_islam/data/models/doa_model.dart';
import 'package:uas_projekk/features/pilar_islam/logic/pilar_islam_provider.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';

class DoaDetailScreen extends StatefulWidget {
  final DoaModel doa;

  const DoaDetailScreen({super.key, required this.doa});

  @override
  State<DoaDetailScreen> createState() => _DoaDetailScreenState();
}

class _DoaDetailScreenState extends State<DoaDetailScreen> {
  double _localFontSizeOffset = 0; // Local adjustment for reading convenience

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final pilarProvider = Provider.of<PilarIslamProvider>(context);
    final theme = Theme.of(context);

    final int count = pilarProvider.getCount(widget.doa.id);
    final bool isCompleted = count >= widget.doa.target;
    final double progress = widget.doa.target > 0 ? count / widget.doa.target : 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: settings.isDarkMode ? Colors.white : AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.doa.category,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: settings.isDarkMode ? Colors.white : AppTheme.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_decrease, size: 20),
            onPressed: () {
              setState(() {
                if (settings.arabicFontSize + _localFontSizeOffset > 16) {
                  _localFontSizeOffset -= 2;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase, size: 20),
            onPressed: () {
              setState(() {
                if (settings.arabicFontSize + _localFontSizeOffset < 48) {
                  _localFontSizeOffset += 2;
                }
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: settings.isDarkMode
                              ? [const Color(0xFF0F4D3A).withOpacity(0.3), const Color(0xFF00796B).withOpacity(0.15)]
                              : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9).withOpacity(0.4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: settings.isDarkMode ? Colors.white10 : const Color(0xFFB2DFDB).withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doa.title,
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: settings.isDarkMode ? Colors.white : const Color(0xFF0F4D3A),
                              height: 1.3,
                            ),
                          ),
                          if (widget.doa.source != null && widget.doa.source!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.menu_book, size: 14, color: AppTheme.textGrey),
                                const SizedBox(width: 6),
                                Text(
                                  widget.doa.source!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppTheme.textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Arabic Text Text
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.doa.arabicText,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.amiri(
                          fontSize: settings.arabicFontSize + _localFontSizeOffset + 4,
                          height: 2.2,
                          fontWeight: FontWeight.bold,
                          color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF0F4D3A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Transliteration (Latin)
                    Text(
                      "Transliterasi:",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: settings.isDarkMode ? Colors.white70 : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.doa.transliteration,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: settings.isDarkMode ? Colors.white60 : Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Translation
                    if (settings.showTranslation) ...[
                      Text(
                        "Terjemahan:",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: settings.isDarkMode ? Colors.white70 : AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.doa.translation,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: settings.isDarkMode ? Colors.white70 : Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],

                    // Note/Keutamaan Card
                    if (widget.doa.note != null && widget.doa.note!.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: settings.isDarkMode ? Colors.white.withOpacity(0.03) : const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: settings.isDarkMode ? Colors.white10 : Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Keutamaan / Catatan:",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFC19E4A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.doa.note!,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: settings.isDarkMode ? Colors.white60 : Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ],
                ),
              ),
            ),

            // Large digital counter widget at the bottom
            _buildTasbihPanel(context, pilarProvider, count, isCompleted, progress, settings, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTasbihPanel(
    BuildContext context,
    PilarIslamProvider provider,
    int count,
    bool isCompleted,
    double progress,
    SettingsProvider settings,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(settings.isDarkMode ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Reset Button
          IconButton(
            iconSize: 28,
            icon: Icon(Icons.refresh_rounded, color: Colors.grey[400]),
            onPressed: () {
              HapticFeedback.mediumImpact();
              provider.resetCount(widget.doa.id);
            },
          ),

          // Main Tap Counter Circle
          GestureDetector(
            onTap: () {
              if (count < widget.doa.target) {
                HapticFeedback.lightImpact();
                provider.incrementCount(widget.doa.id, widget.doa.target);
                if (count + 1 >= widget.doa.target) {
                  // Vibrate heavily on completion
                  HapticFeedback.vibrate();
                }
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Inner Shadow circle container
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: settings.isDarkMode ? Colors.white.withOpacity(0.03) : const Color(0xFFF2F6F5),
                  ),
                ),
                // Circular Progress
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: settings.isDarkMode ? Colors.white10 : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? const Color(0xFF4CAF50) : const Color(0xFF0F4D3A),
                    ),
                  ),
                ),
                // Counter Display
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$count",
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isCompleted
                            ? (settings.isDarkMode ? const Color(0xFF81C784) : const Color(0xFF2E7D32))
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "Target: ${widget.doa.target}",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Completion Checkmark status or empty placeholder for symmetry
          SizedBox(
            width: 48,
            height: 48,
            child: isCompleted
                ? const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 32)
                : Icon(Icons.fingerprint_rounded, color: const Color(0xFF0F4D3A).withOpacity(0.2), size: 32),
          ),
        ],
      ),
    );
  }
}
