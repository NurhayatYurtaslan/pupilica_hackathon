import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/module/state.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/document_upload_view_model.dart';

class DocumentUploadView extends StatelessWidget {
  const DocumentUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    // System UI visibility management
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider(
      create: (context) {
        return DocumentUploadViewModel()
          ..add(DocumentUploadInitialEvent(context));
      },
      child: BlocBuilder<DocumentUploadViewModel, DocumentUploadState>(
        builder: (context, state) {
          return OsmeaComponents.scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.9),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.home),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: OsmeaComponents.text(
                'Upload Documents',
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: Colors.white,
              ),
              centerTitle: true,
            ),
            body: OsmeaComponents.container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF7C3AED), // Purple
                    const Color(0xFF8B5CF6), // Light purple
                    const Color(0xFFA78BFA), // Very light purple
                    const Color(0xFFC4B5FD), // Lavender
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: OsmeaComponents.padding(
                    padding: EdgeInsets.all(context.spacing20),
                    child: OsmeaComponents.column(
                      children: [
                        // Upload buttons
                        OsmeaComponents.container(
                          padding: EdgeInsets.all(context.spacing20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: context.borderWidth * 2,
                            ),
                          ),
                          child: OsmeaComponents.column(
                            children: [
                              // Pick files button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _pickDocuments(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: OsmeaComponents.text('Pick Documents'),
                                ),
                              ),

                              OsmeaComponents.sizedBox(
                                height: context.height20,
                              ),

                              // Take photo button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _takePhoto(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: OsmeaComponents.text('Take Photo'),
                                ),
                              ),

                              OsmeaComponents.sizedBox(
                                height: context.height20,
                              ),

                              // Pick from gallery button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _pickImageFromGallery(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    foregroundColor: Colors.white,
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
                                    'Pick from Gallery',
                                  ),
                                ),
                              ),

                              OsmeaComponents.sizedBox(
                                height: context.height20,
                              ),

                              // Supported formats info
                              OsmeaComponents.container(
                                padding: EdgeInsets.all(context.spacing12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: OsmeaComponents.text(
                                  'Supported formats: PNG, JPG, PDF\nCamera, Gallery, or File Picker',
                                  fontSize: context.fontSizeSmall,
                                  color: Colors.white70,
                                  textAlign: context.textCenter,
                                ),
                              ),
                            ],
                          ),
                        ),

                        OsmeaComponents.sizedBox(height: context.height20),

                        // Selected documents
                        if (state is DocumentUploadLoadedState &&
                            state.documents.isNotEmpty)
                          OsmeaComponents.container(
                            padding: EdgeInsets.all(context.spacing16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: context.borderWidth * 2,
                              ),
                            ),
                            child: OsmeaComponents.column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OsmeaComponents.text(
                                  'Selected Documents (${state.documents.length})',
                                  fontSize: context.fontSizeLarge,
                                  fontWeight: context.semiBold,
                                  color: Colors.white,
                                ),
                                OsmeaComponents.sizedBox(
                                  height: context.height12,
                                ),
                                ...state.documents
                                    .map(
                                      (doc) => _buildDocumentItem(context, doc),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),

                        // Process button
                        if (state is DocumentUploadLoadedState &&
                            state.documents.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _processDocuments(context, state.documents),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.3,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: OsmeaComponents.text('Process Documents'),
                            ),
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
          color: Colors.white.withValues(alpha: 0.2),
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
                  color: Colors.white,
                ),
                OsmeaComponents.text(
                  document.sizeString,
                  fontSize: context.fontSizeSmall,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDocuments(BuildContext context) async {
    try {
      Logger.info('Starting document picker', category: LogCategory.document);

      final documents = await DocumentService.pickMultipleDocuments();

      if (context.mounted) {
        Logger.success(
          'Documents picked successfully',
          category: LogCategory.document,
          data: {'count': documents.length},
        );

        context.read<DocumentUploadViewModel>().add(
          DocumentUploadDocumentsSelectedEvent(documents),
        );

        if (documents.isNotEmpty && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${documents.length} document(s) selected'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      Logger.error(
        'Document picker failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick documents: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    try {
      Logger.info('Starting camera capture', category: LogCategory.document);

      final document = await DocumentService.takePhoto();

      if (document != null && context.mounted) {
        Logger.success(
          'Photo captured successfully',
          category: LogCategory.document,
          data: {'documentName': document.name, 'size': document.sizeString},
        );

        context.read<DocumentUploadViewModel>().add(
          DocumentUploadDocumentsSelectedEvent([document]),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Photo captured: ${document.name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        Logger.info('No photo taken', category: LogCategory.document);
      }
    } catch (e) {
      Logger.error(
        'Camera capture failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    try {
      Logger.info(
        'Starting gallery image picker',
        category: LogCategory.document,
      );

      final document = await DocumentService.pickImageFromGallery();

      if (document != null && context.mounted) {
        Logger.success(
          'Gallery image picked successfully',
          category: LogCategory.document,
          data: {'documentName': document.name, 'size': document.sizeString},
        );

        context.read<DocumentUploadViewModel>().add(
          DocumentUploadDocumentsSelectedEvent([document]),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image picked: ${document.name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        Logger.info(
          'No image selected from gallery',
          category: LogCategory.document,
        );
      }
    } catch (e) {
      Logger.error(
        'Gallery image picker failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image from gallery: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _processDocuments(
    BuildContext context,
    List<DocumentFile> documents,
  ) async {
    try {
      Logger.info(
        'Starting document processing',
        category: LogCategory.document,
        data: {'count': documents.length},
      );

      // Navigate to lesson creation or processing screen
      // This would typically navigate to a form where user can enter lesson details
      if (context.mounted) {
        context.go(AppRouter.lessonCreation, extra: documents);
      }
    } catch (e) {
      Logger.error(
        'Document processing failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process documents: $e')),
        );
      }
    }
  }
}
