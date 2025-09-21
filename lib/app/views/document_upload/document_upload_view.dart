import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';
import 'package:pupilica_hackathon/core/services/pdf_service.dart';
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
              backgroundColor: const Color(0xFF38B6FF),
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go(AppRouter.home),
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
                    fontWeight: context.bold,
                    color: Colors.white,
                  ),
                ],
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
                                ...state.documents.map(
                                  (doc) => _buildDocumentItem(context, doc),
                                ),
                              ],
                            ),
                          ),

                        // Process button
                        if (state is DocumentUploadLoadedState &&
                            state.documents.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _processDocuments(context, state.documents);
                              },
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

                        // Success state - show extracted text
                        if (state is DocumentUploadSuccessState)
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
                                  'Extracted Text (${state.extractedText.length} characters)',
                                  fontSize: context.fontSizeLarge,
                                  fontWeight: context.semiBold,
                                  color: Colors.white,
                                ),
                                OsmeaComponents.sizedBox(
                                  height: context.height12,
                                ),
                                OsmeaComponents.container(
                                  padding: EdgeInsets.all(context.spacing12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: OsmeaComponents.text(
                                    state.extractedText,
                                    fontSize: context.fontSizeSmall,
                                    color: Colors.white,
                                  ),
                                ),
                                OsmeaComponents.sizedBox(
                                  height: context.height16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _showPDFPreview(context, state),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange.withValues(
                                        alpha: 0.8,
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
                                      'Preview PDF',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Debug info
                        if (state is DocumentUploadLoadedState ||
                            state is DocumentUploadSuccessState)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OsmeaComponents.text(
                                  'DEBUG INFO:',
                                  color: Colors.white,
                                  fontWeight: context.bold,
                                ),
                                OsmeaComponents.sizedBox(height: 8),
                                OsmeaComponents.text(
                                  'State: ${state.runtimeType}',
                                  color: Colors.white,
                                  fontSize: context.fontSizeSmall,
                                ),
                                if (state is DocumentUploadLoadedState) ...[
                                  OsmeaComponents.text(
                                    'Documents count: ${state.documents.length}',
                                    color: Colors.white,
                                    fontSize: context.fontSizeSmall,
                                  ),
                                  OsmeaComponents.text(
                                    'Is processing: ${state.isProcessing}',
                                    color: Colors.white,
                                    fontSize: context.fontSizeSmall,
                                  ),
                                ],
                                if (state is DocumentUploadSuccessState) ...[
                                  OsmeaComponents.text(
                                    'Documents count: ${state.documents.length}',
                                    color: Colors.white,
                                    fontSize: context.fontSizeSmall,
                                  ),
                                  OsmeaComponents.text(
                                    'Text length: ${state.extractedText.length}',
                                    color: Colors.white,
                                    fontSize: context.fontSizeSmall,
                                  ),
                                ],
                              ],
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
        'Starting document processing with OCR',
        category: LogCategory.document,
        data: {'count': documents.length},
      );

      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Processing documents with OCR...'),
              ],
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Process documents with OCR using the ViewModel
      await context.read<DocumentUploadViewModel>().processDocuments(documents);

      // Check if processing was successful
      final currentState = context.read<DocumentUploadViewModel>().state;

      if (currentState is DocumentUploadSuccessState) {
        Logger.success(
          'Documents processed successfully',
          category: LogCategory.document,
          data: {'textLength': currentState.extractedText.length},
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully processed ${documents.length} document(s)',
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to lesson creation with extracted text
          context.go(
            AppRouter.lessonCreation,
            extra: {
              'documents': documents,
              'extractedText': currentState.extractedText,
            },
          );
        }
      } else if (currentState is DocumentUploadErrorState) {
        Logger.error(
          'Document processing failed',
          category: LogCategory.document,
          data: {'error': currentState.error},
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to process documents: ${currentState.error}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      Logger.error(
        'Document processing failed',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process documents: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPDFPreview(BuildContext context, DocumentUploadSuccessState state) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.9),
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
                  'Creating PDF preview...',
                  color: Colors.white,
                  fontSize: context.fontSizeMedium,
                ),
              ],
            ),
          );
        },
      );

      // Create PDF
      final pdfBytes = await PDFService.createPDF(
        title: 'Document ${DateTime.now().millisecondsSinceEpoch}',
        subject: 'General',
        extractedText: state.extractedText,
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Show PDF preview dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: OsmeaComponents.text(
                'PDF Preview',
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: Colors.white,
                textAlign: context.textCenter,
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    OsmeaComponents.text(
                      'PDF created successfully!',
                      fontSize: context.fontSizeMedium,
                      color: Colors.white,
                      textAlign: context.textCenter,
                    ),
                    const SizedBox(height: 16),
                    OsmeaComponents.text(
                      'Size: ${(pdfBytes.length / 1024).toStringAsFixed(1)} KB',
                      fontSize: context.fontSizeSmall,
                      color: Colors.white70,
                      textAlign: context.textCenter,
                    ),
                    const SizedBox(height: 20),
                    OsmeaComponents.text(
                      'Extracted Text Preview:',
                      fontSize: context.fontSizeMedium,
                      fontWeight: context.semiBold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: OsmeaComponents.text(
                            state.extractedText.length > 200 
                                ? '${state.extractedText.substring(0, 200)}...'
                                : state.extractedText,
                            fontSize: context.fontSizeSmall,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: OsmeaComponents.text(
                    'Close',
                    color: Colors.white,
                    fontWeight: context.semiBold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await PDFService.sharePDF(
                      title: 'Document ${DateTime.now().millisecondsSinceEpoch}',
                      subject: 'General',
                      extractedText: state.extractedText,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withValues(alpha: 0.8),
                    foregroundColor: Colors.white,
                  ),
                  child: OsmeaComponents.text('Download PDF'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create PDF preview: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
