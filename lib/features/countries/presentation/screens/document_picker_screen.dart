import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/core/theme/app_colors.dart';
import 'package:photo_id/core/theme/app_typography.dart';
import 'package:photo_id/core/theme/app_spacing.dart';
import 'package:photo_id/features/countries/presentation/providers/country_provider.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

class DocumentPickerScreen extends ConsumerStatefulWidget {
  final String countryCode;

  const DocumentPickerScreen({
    super.key,
    required this.countryCode,
  });

  @override
  ConsumerState<DocumentPickerScreen> createState() => _DocumentPickerScreenState();
}

class _DocumentPickerScreenState extends ConsumerState<DocumentPickerScreen> {
  Document? _selectedDocument;

  @override
  Widget build(BuildContext context) {
    final countryAsync = ref.watch(countryProvider(widget.countryCode));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF);
    final cardColor = isDark ? const Color(0xFF1D2438) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF333D55) : const Color(0xFFE2E7FF);

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
          'Select Document',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF004AC6),
          ),
        ),
      ),
      body: countryAsync.when(
        data: (country) {
          if (country == null) {
            return const Center(
              child: Text('Country not found'),
            );
          }

          return Column(
            children: [
              // Country Info header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: dividerColor.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        country.flagEmoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              country.nameEn,
                              style: const TextStyle(
                                fontFamily: 'Hanken Grotesk',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${country.documents.length} document types available',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title label
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Text(
                    'DOCUMENT TYPES',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF004AC6),
                    ),
                  ),
                ),
              ),

              // Document list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: country.documents.length,
                  itemBuilder: (context, index) {
                    final document = country.documents[index];
                    final isSelected = _selectedDocument?.id == document.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF004AC6)
                                : dividerColor.withOpacity(0.5),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF004AC6).withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedDocument = document;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF004AC6).withOpacity(0.1)
                                          : (isDark
                                              ? const Color(0xFF2E3132)
                                              : const Color(0xFFECEEF0)),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.description_outlined,
                                      color: isSelected
                                          ? const Color(0xFF004AC6)
                                          : (isDark ? Colors.white70 : const Color(0xFF434656)),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          document.name,
                                          style: const TextStyle(
                                            fontFamily: 'Hanken Grotesk',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Dimensions: ${document.sizeString}',
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF004AC6)
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? const Color(0xFF004AC6)
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 12,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom sticky area
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131B2E) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            size: 16,
                            color: isDark ? Colors.white60 : const Color(0xFF737688),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'All photo editing is processed offline. No data leaves your device.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: isDark ? Colors.white60 : const Color(0xFF737688),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _selectedDocument != null
                              ? () {
                                  ref.read(selectedDocumentProvider.notifier).state =
                                      _selectedDocument;
                                  context.push('/camera/${_selectedDocument!.id}');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004AC6),
                            disabledBackgroundColor: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade200,
                            foregroundColor: Colors.white,
                            disabledForegroundColor: isDark
                                ? Colors.white30
                                : Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
