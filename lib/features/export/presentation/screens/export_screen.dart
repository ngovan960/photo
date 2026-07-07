import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/features/editor/presentation/providers/editor_provider.dart';

enum ExportFormat { jpeg, png }
enum ExportLayout { single, grid4, grid8 }
enum PaperSize { fourBySix, a4, a5 }

class ExportState {
  final ExportFormat format;
  final ExportLayout layout;
  final PaperSize paperSize;

  const ExportState({
    this.format = ExportFormat.jpeg,
    this.layout = ExportLayout.single,
    this.paperSize = PaperSize.fourBySix,
  });

  ExportState copyWith({
    ExportFormat? format,
    ExportLayout? layout,
    PaperSize? paperSize,
  }) {
    return ExportState(
      format: format ?? this.format,
      layout: layout ?? this.layout,
      paperSize: paperSize ?? this.paperSize,
    );
  }
}

class ExportNotifier extends StateNotifier<ExportState> {
  ExportNotifier() : super(const ExportState());

  void setFormat(ExportFormat format) {
    state = state.copyWith(format: format);
  }

  void setLayout(ExportLayout layout) {
    state = state.copyWith(layout: layout);
  }

  void setPaperSize(PaperSize paperSize) {
    state = state.copyWith(paperSize: paperSize);
  }
}

final exportProvider = StateNotifierProvider<ExportNotifier, ExportState>((ref) {
  return ExportNotifier();
});

class ExportScreen extends ConsumerWidget {
  final String photoId;

  const ExportScreen({
    super.key,
    required this.photoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportProvider);
    final editorState = ref.watch(editorProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF);
    final cardColor = isDark ? const Color(0xFF1D2438) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF333D55) : const Color(0xFFE2E7FF);

    final photoBytes = editorState.photo?.processedBytes ?? editorState.photo?.originalBytes;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF004AC6),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Export & Print',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF004AC6),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: const Color(0xFF004AC6),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 160.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Photo Preview Area with Layout overlays
            Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dividerColor.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (photoBytes != null) ...[
                          if (exportState.layout == ExportLayout.single)
                            Image.memory(
                              photoBytes,
                              fit: BoxFit.cover,
                            )
                          else if (exportState.layout == ExportLayout.grid4)
                            GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(8),
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                4,
                                (index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.memory(photoBytes, fit: BoxFit.cover),
                                ),
                              ),
                            )
                          else if (exportState.layout == ExportLayout.grid8)
                            GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(8),
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                8,
                                (index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: Image.memory(photoBytes, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                        ] else
                          Center(
                            child: Icon(
                              Icons.photo,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // 2. File Format Section
            const Text(
              'FILE FORMAT',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D2438) : const Color(0xFFF3F3F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(exportProvider.notifier).setFormat(ExportFormat.jpeg),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: exportState.format == ExportFormat.jpeg
                              ? (isDark ? const Color(0xFF004AC6) : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: exportState.format == ExportFormat.jpeg && !isDark
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          'JPEG',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: exportState.format == ExportFormat.jpeg
                                ? (isDark ? Colors.white : Colors.black)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ref.read(exportProvider.notifier).setFormat(ExportFormat.png),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: exportState.format == ExportFormat.png
                              ? (isDark ? const Color(0xFF004AC6) : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: exportState.format == ExportFormat.png && !isDark
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          'PNG',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: exportState.format == ExportFormat.png
                                ? (isDark ? Colors.white : Colors.black)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Layout Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'LAYOUT',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  exportState.layout == ExportLayout.single
                      ? 'Single'
                      : exportState.layout == ExportLayout.grid4
                          ? '4 Copies'
                          : '8 Copies',
                  style: const TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004AC6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _buildLayoutButton(
                  context: context,
                  ref: ref,
                  targetLayout: ExportLayout.single,
                  currentLayout: exportState.layout,
                  title: 'Single',
                  isDark: isDark,
                  cardColor: cardColor,
                  icon: const Icon(Icons.crop_original, size: 28, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                _buildLayoutButton(
                  context: context,
                  ref: ref,
                  targetLayout: ExportLayout.grid4,
                  currentLayout: exportState.layout,
                  title: '4 Copies',
                  isDark: isDark,
                  cardColor: cardColor,
                  icon: const Icon(Icons.grid_view, size: 28, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                _buildLayoutButton(
                  context: context,
                  ref: ref,
                  targetLayout: ExportLayout.grid8,
                  currentLayout: exportState.layout,
                  title: '8 Copies',
                  isDark: isDark,
                  cardColor: cardColor,
                  icon: const Icon(Icons.grid_on, size: 28, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4. Paper Size Section
            const Text(
              'PAPER SIZE',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildPaperChip(ref, PaperSize.fourBySix, exportState.paperSize, '4x6"'),
                const SizedBox(width: 8),
                _buildPaperChip(ref, PaperSize.a4, exportState.paperSize, 'A4'),
                const SizedBox(width: 8),
                _buildPaperChip(ref, PaperSize.a5, exportState.paperSize, 'A5'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131B2E) : Colors.white,
          border: Border(
            top: BorderSide(color: dividerColor.withOpacity(0.5)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved to device successfully!')),
                    );
                    context.go('/home');
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Save to Device'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AC6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Share and Print buttons row
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: dividerColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.print, size: 18),
                        label: const Text('Print'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: dividerColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutButton({
    required BuildContext context,
    required WidgetRef ref,
    required ExportLayout targetLayout,
    required ExportLayout currentLayout,
    required String title,
    required bool isDark,
    required Color cardColor,
    required Widget icon,
  }) {
    final isSelected = targetLayout == currentLayout;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(exportProvider.notifier).setLayout(targetLayout),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF004AC6).withOpacity(0.08)
                : cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF004AC6) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? const Color(0xFF004AC6)
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaperChip(
    WidgetRef ref,
    PaperSize targetSize,
    PaperSize currentSize,
    String label,
  ) {
    final isSelected = targetSize == currentSize;
    return GestureDetector(
      onTap: () => ref.read(exportProvider.notifier).setPaperSize(targetSize),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004AC6) : Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
