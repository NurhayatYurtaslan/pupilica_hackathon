import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';
import 'package:pupilica_hackathon/core/services/pdf_service.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/app/views/lesson_creation/models/lesson_creation_view_model.dart';
import 'package:pupilica_hackathon/app/views/lesson_creation/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/lesson_creation/models/module/state.dart';

class LessonCreationView extends StatelessWidget {
  final List<DocumentFile> documents;
  final String? extractedText;

  const LessonCreationView({
    super.key,
    required this.documents,
    this.extractedText,
  });

  @override
  Widget build(BuildContext context) {
    // System UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) {
        return LessonCreationViewModel()..add(
          LessonCreationInitialEvent(
            documents: documents,
            extractedText: extractedText ?? '',
          ),
        );
      },
      child: BlocBuilder<LessonCreationViewModel, LessonCreationState>(
        builder: (context, state) {
          if (state is! LessonCreationLoadedState) {
            return OsmeaComponents.scaffold(
              body: OsmeaComponents.center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(OsmeaColors.white),
                ),
              ),
            );
          }

          return OsmeaComponents.scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF38B6FF),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.documentUpload),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/rocket-lica.png',
                    height: 28,
                    width: 28,
                  ),
                  const SizedBox(width: 8),
                  OsmeaComponents.text(
                    'RocketLica',
                    fontSize: context.fontSizeLarge,
                    fontFamily: context.fontRoboto,
                    fontWeight: context.bold,
                    color: Colors.white,
                    textAlign: context.textCenter,
                  ),
                ],
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => _createNewLesson(context, state),
                  icon: const Icon(Icons.save, color: Colors.white),
                ),
              ],
            ),
            body: OsmeaComponents.container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    OsmeaColors.purple,
                    OsmeaColors.purple.withValues(alpha: 0.8),
                    OsmeaColors.purple.withValues(alpha: 0.6),
                    OsmeaColors.purple.withValues(alpha: 0.4),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: OsmeaComponents.singleChildScrollView(
                  child: OsmeaComponents.padding(
                    padding: context.paddingHigh,
                    child: OsmeaComponents.column(
                      children: [
                        // Lesson Info Card
                        _buildLessonInfoCard(context),

                        OsmeaComponents.sizedBox(height: context.height20),

                        // Documents Card
                        _buildDocumentsCard(context, state),

                        OsmeaComponents.sizedBox(height: context.height20),

                        // Extracted Text Card (only show if there's extracted text)
                        if (state.extractedText.isNotEmpty)
                          _buildExtractedTextCard(context, state),

                        OsmeaComponents.sizedBox(height: context.height20),

                        // Action Buttons (only show if there's extracted text)
                        if (state.extractedText.isNotEmpty)
                          _buildActionButtons(context, state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLessonInfoCard(BuildContext context) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing20),
      decoration: BoxDecoration(
        color: OsmeaColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: OsmeaColors.white.withValues(alpha: 0.3),
          width: context.borderWidth * 2,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Lesson Information',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: OsmeaColors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height16),

          // Title Field
          OsmeaComponents.text(
            'Title',
            fontSize: context.fontSizeMedium,
            fontWeight: context.semiBold,
            color: OsmeaColors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height8),
          TextField(
            onChanged: (value) {
              context.read<LessonCreationViewModel>().add(
                LessonCreationUpdateTitleEvent(value),
              );
            },
            style: TextStyle(
              color: OsmeaColors.white,
              fontFamily: context.fontRoboto,
              fontSize: context.fontSizeMedium,
            ),
            decoration: InputDecoration(
              hintText: 'Enter lesson title',
              hintStyle: TextStyle(
                color: OsmeaColors.white.withValues(alpha: 0.7),
                fontFamily: context.fontRoboto,
              ),
              filled: true,
              fillColor: OsmeaColors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
            ),
          ),

          OsmeaComponents.sizedBox(height: context.height16),

          // Subject Field
          OsmeaComponents.text(
            'Subject',
            fontSize: context.fontSizeMedium,
            fontWeight: context.semiBold,
            color: OsmeaColors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height8),
          TextField(
            onChanged: (value) {
              context.read<LessonCreationViewModel>().add(
                LessonCreationUpdateSubjectEvent(value),
              );
            },
            style: TextStyle(
              color: OsmeaColors.white,
              fontFamily: context.fontRoboto,
              fontSize: context.fontSizeMedium,
            ),
            decoration: InputDecoration(
              hintText: 'Enter subject (e.g., Mathematics, Science)',
              hintStyle: TextStyle(
                color: OsmeaColors.white.withValues(alpha: 0.7),
                fontFamily: context.fontRoboto,
              ),
              filled: true,
              fillColor: OsmeaColors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
            ),
          ),

          OsmeaComponents.sizedBox(height: context.height16),

          // Description Field
          OsmeaComponents.text(
            'Description (Optional)',
            fontSize: context.fontSizeMedium,
            fontWeight: context.semiBold,
            color: OsmeaColors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height8),
          TextField(
            onChanged: (value) {
              context.read<LessonCreationViewModel>().add(
                LessonCreationUpdateDescriptionEvent(value),
              );
            },
            maxLines: 3,
            style: TextStyle(
              color: OsmeaColors.white,
              fontFamily: context.fontRoboto,
              fontSize: context.fontSizeMedium,
            ),
            decoration: InputDecoration(
              hintText: 'Enter lesson description',
              hintStyle: TextStyle(
                color: OsmeaColors.white.withValues(alpha: 0.7),
                fontFamily: context.fontRoboto,
              ),
              filled: true,
              fillColor: OsmeaColors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: context.borderRadiusNormal,
                borderSide: BorderSide(
                  color: OsmeaColors.white.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard(
    BuildContext context,
    LessonCreationLoadedState state,
  ) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing20),
      decoration: BoxDecoration(
        color: OsmeaColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: OsmeaColors.white.withValues(alpha: 0.3),
          width: context.borderWidth * 2,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Uploaded Documents (${state.documents.length})',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: OsmeaColors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height12),
          ...state.documents.map((doc) => _buildDocumentItem(context, doc)),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, DocumentFile document) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.height8),
      padding: EdgeInsets.all(context.spacing12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.white.withValues(alpha: 0.2),
          width: context.borderWidth * 2,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          Icon(
            document.type == DocumentType.image
                ? Icons.image
                : Icons.picture_as_pdf,
            size: 24,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          OsmeaComponents.sizedBox(width: context.width12),
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  document.name,
                  fontSize: context.fontSizeSmall,
                  fontWeight: context.medium,
                  color: OsmeaColors.white,
                ),
                OsmeaComponents.text(
                  document.sizeString,
                  fontSize: context.fontSizeSmall,
                  color: OsmeaColors.white.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedTextCard(
    BuildContext context,
    LessonCreationLoadedState state,
  ) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing20),
      decoration: BoxDecoration(
        color: OsmeaColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: OsmeaColors.white.withValues(alpha: 0.3),
          width: context.borderWidth * 2,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OsmeaComponents.text(
                  'Extracted Text',
                  fontSize: context.fontSizeLarge,
                  fontWeight: context.bold,
                  color: OsmeaColors.white,
                ),
              ),
              IconButton(
                onPressed: () => _copyText(context, state.extractedText),
                icon: const Icon(Icons.copy, color: Colors.white70),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.height12),
          Container(
            height: 200,
            padding: EdgeInsets.all(context.spacing12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: OsmeaColors.white.withValues(alpha: 0.2),
                width: context.borderWidth * 2,
              ),
            ),
            child: TextField(
              controller: TextEditingController(text: state.extractedText),
              onChanged: (value) {
                context.read<LessonCreationViewModel>().add(
                  LessonCreationUpdateTextEvent(value),
                );
              },
              maxLines: 8,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(
                color: OsmeaColors.white,
                fontFamily: context.fontRoboto,
                fontSize: context.fontSizeSmall,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'No text extracted yet...',
                hintStyle: TextStyle(
                  color: OsmeaColors.white.withValues(alpha: 0.5),
                  fontFamily: context.fontRoboto,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    LessonCreationLoadedState state,
  ) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing20),
      decoration: BoxDecoration(
        color: OsmeaColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: OsmeaColors.white.withValues(alpha: 0.3),
          width: context.borderWidth * 2,
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.text(
            'What would you like to do?',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: OsmeaColors.white,
            textAlign: context.textCenter,
          ),
          OsmeaComponents.sizedBox(height: context.height16),

          // Option 1: Add to existing lesson
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showLessonSelection(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.8),
                foregroundColor: OsmeaColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: OsmeaComponents.text(
                'Add to Existing Lesson',
                fontSize: context.fontSizeMedium,
                fontWeight: context.semiBold,
              ),
            ),
          ),

          OsmeaComponents.sizedBox(height: context.height12),

          // Option 2: Create new lesson
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _createNewLesson(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withValues(alpha: 0.8),
                foregroundColor: OsmeaColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: OsmeaComponents.text(
                'Create New Lesson',
                fontSize: context.fontSizeMedium,
                fontWeight: context.semiBold,
              ),
            ),
          ),

          OsmeaComponents.sizedBox(height: context.height12),

          // Option 3: Download as PDF
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _downloadAsPDF(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.withValues(alpha: 0.8),
                foregroundColor: OsmeaColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: OsmeaComponents.text(
                'Download as PDF',
                fontSize: context.fontSizeMedium,
                fontWeight: context.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showLessonSelection(
    BuildContext context,
    LessonCreationLoadedState state,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: OsmeaColors.purple.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: OsmeaComponents.text(
            'Lessons',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: OsmeaColors.white,
            textAlign: context.textCenter,
          ),
          content: OsmeaComponents.text(
            'This feature will be available in the new version, please follow us for updates!',
            fontSize: context.fontSizeMedium,
            color: OsmeaColors.white,
            textAlign: context.textCenter,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: OsmeaComponents.text(
                'OK',
                color: OsmeaColors.white,
                fontWeight: context.semiBold,
              ),
            ),
          ],
        );
      },
    );
  }

  void _createNewLesson(BuildContext context, LessonCreationLoadedState state) {
    if (state.title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a lesson title'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (state.subject.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a subject'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<LessonCreationViewModel>().add(
      LessonCreationSaveEvent(
        title: state.title,
        subject: state.subject,
        description: state.description,
        extractedText: state.extractedText,
        documents: state.documents,
      ),
    );
  }

  void _downloadAsPDF(
    BuildContext context,
    LessonCreationLoadedState state,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: OsmeaColors.purple.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 16),
                OsmeaComponents.text(
                  'Creating PDF...',
                  color: OsmeaColors.white,
                  fontSize: context.fontSizeMedium,
                ),
              ],
            ),
          );
        },
      );

      // Create and share PDF
      await PDFService.sharePDF(
        title: state.title.isNotEmpty ? state.title : 'Untitled Lesson',
        subject: state.subject.isNotEmpty ? state.subject : 'General',
        extractedText: state.extractedText,
        description: state.description.isNotEmpty ? state.description : null,
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF created and ready to share!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
