import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/helpers/file_download_helper.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';
import 'package:pupilica_hackathon/core/services/pdf_service.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/module/state.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/document_upload_view_model.dart';
import 'package:pupilica_hackathon/app/routes/app_router.dart';
import 'package:go_router/go_router.dart';

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
            backgroundColor: OsmeaColors.nordicBlue,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    OsmeaColors.nordicBlue,
                    OsmeaColors.blue,
                    OsmeaColors.nordicBlue,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: OsmeaComponents.padding(
                    padding: EdgeInsets.all(context.spacing20),
                    child: OsmeaComponents.column(
                      children: [
                        // Header
                        _buildHeader(context),

                        OsmeaComponents.sizedBox(height: context.height40),

                        // Upload buttons
                        OsmeaComponents.container(
                          padding: EdgeInsets.all(context.spacing16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: OsmeaComponents.column(
                            children: [
                              // Pick files button
                              _buildActionButton(
                                context,
                                'Pick Documents',
                                Icons.upload_file,
                                () => _pickDocuments(context),
                              ),

                              OsmeaComponents.sizedBox(
                                height: context.height20,
                              ),

                              // Take photo button
                              _buildActionButton(
                                context,
                                'Take Photo',
                                Icons.camera_alt,
                                () => _takePhoto(context),
                              ),

                              OsmeaComponents.sizedBox(
                                height: context.height20,
                              ),

                              // Pick from gallery button
                              _buildActionButton(
                                context,
                                'Pick from Gallery',
                                Icons.photo_library,
                                () => _pickImageFromGallery(context),
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
                                  child: SizedBox(
                                    height:
                                        200, // Fixed height for scrollable area
                                    child: SingleChildScrollView(
                                      child: OsmeaComponents.text(
                                        state.extractedText,
                                        fontSize: context.fontSizeSmall,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                OsmeaComponents.sizedBox(
                                  height: context.height16,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _showPDFPreview(context, state),
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
                                    child: OsmeaComponents.text('Create PDF'),
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

  Widget _buildHeader(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.sizedBox(height: context.height20),
        Image.asset('assets/images/rocket-lica.png', height: 60, width: 60),
        OsmeaComponents.sizedBox(height: context.height16),
        OsmeaComponents.text(
          'Upload Documents',
          fontSize: context.fontSizeExtraLarge,
          fontWeight: context.extraBold,
          letterSpacing: context.letterSpacingWide,
          color: Colors.white,
        ),
        OsmeaComponents.sizedBox(height: context.height8),
        OsmeaComponents.text(
          'Upload images or PDFs to extract text',
          fontSize: context.fontSizeMedium,
          fontWeight: context.light,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: OsmeaComponents.row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 12),
            OsmeaComponents.text(
              title,
              fontSize: context.fontSizeSmall,
              fontWeight: context.medium,
              color: Colors.white,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.white70,
            ),
            const SizedBox(width: 16),
          ],
        ),
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

        // Check if any PDF files were selected
        final pdfDocuments = documents
            .where((doc) => doc.name.toLowerCase().endsWith('.pdf'))
            .toList();

        if (pdfDocuments.isNotEmpty) {
          // Show PDF save location dialog
          await _showPDFSaveLocationDialog(context, pdfDocuments);
        } else {
          // Process as normal documents
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
      if (context.mounted) {
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

            // Stay on document upload page to show PDF creation option
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

  void _showPDFPreview(
    BuildContext context,
    DocumentUploadSuccessState state,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: OsmeaColors.nordicBlue.withValues(alpha: 0.9),
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

        Logger.info(
          'Navigating to PDF Preview',
          category: LogCategory.document,
          data: {
            'extractedTextLength': state.extractedText.length,
            'documentCount': state.documents.length,
            'pdfBytesSize': pdfBytes.length,
          },
        );

        // Navigate to PDF Preview page
        context.go(
          AppRouter.pdfPreview,
          extra: {
            'extractedText': state.extractedText,
            'documentNames': state.documents.map((doc) => doc.name).toList(),
            'pdfBytes': pdfBytes,
          },
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

  /// Shows dialog to ask user where to save PDF files
  Future<void> _showPDFSaveLocationDialog(
    BuildContext context,
    List<DocumentFile> pdfDocuments,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: OsmeaColors.nordicBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: OsmeaComponents.text(
            'PDF Files Selected',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: Colors.white,
            textAlign: context.textCenter,
          ),
          content: OsmeaComponents.column(
            children: [
              OsmeaComponents.text(
                'You have selected ${pdfDocuments.length} PDF file(s). What would you like to do?',
                fontSize: context.fontSizeMedium,
                color: Colors.white,
                textAlign: context.textCenter,
              ),
              OsmeaComponents.sizedBox(height: context.height16),
              OsmeaComponents.text(
                'Selected PDFs:',
                fontSize: context.fontSizeSmall,
                fontWeight: context.semiBold,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              OsmeaComponents.sizedBox(height: context.height8),
              ...pdfDocuments
                  .take(3)
                  .map(
                    (doc) => Padding(
                      padding: EdgeInsets.only(bottom: context.height4),
                      child: OsmeaComponents.text(
                        '• ${doc.name}',
                        fontSize: context.fontSizeSmall,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
              if (pdfDocuments.length > 3)
                OsmeaComponents.text(
                  '... and ${pdfDocuments.length - 3} more',
                  fontSize: context.fontSizeSmall,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
            ],
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: OsmeaComponents.text(
                'Cancel',
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: context.semiBold,
              ),
            ),
            // Process as documents button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Process PDFs as normal documents for OCR
                context.read<DocumentUploadViewModel>().add(
                  DocumentUploadDocumentsSelectedEvent(pdfDocuments),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${pdfDocuments.length} PDF(s) selected for text extraction',
                    ),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.8),
                foregroundColor: Colors.white,
              ),
              child: OsmeaComponents.text('Extract Text'),
            ),
            // Save to device button
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _savePDFsToDevice(context, pdfDocuments);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withValues(alpha: 0.8),
                foregroundColor: Colors.white,
              ),
              child: OsmeaComponents.text('Save to Device'),
            ),
          ],
        );
      },
    );
  }

  /// Saves selected PDF files to device
  Future<void> _savePDFsToDevice(
    BuildContext context,
    List<DocumentFile> pdfDocuments,
  ) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: OsmeaColors.nordicBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: OsmeaComponents.column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 16),
                OsmeaComponents.text(
                  'Saving PDFs to device...',
                  color: Colors.white,
                  fontSize: context.fontSizeMedium,
                ),
              ],
            ),
          );
        },
      );

      // Save each PDF to device with location picker
      for (final document in pdfDocuments) {
        // Read PDF bytes from file
        final file = File(document.path);
        final pdfBytes = await file.readAsBytes();

        final savedPath = await FileDownloadHelper.savePDFWithLocationPicker(
          pdfBytes: pdfBytes,
          fileName: document.name,
        );

        if (savedPath == null) {
          // User cancelled, break the loop
          break;
        }
      }

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: OsmeaColors.nordicBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: OsmeaComponents.text(
                'PDFs Saved Successfully!',
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: Colors.white,
                textAlign: context.textCenter,
              ),
              content: OsmeaComponents.column(
                children: [
                  OsmeaComponents.text(
                    '${pdfDocuments.length} PDF file(s) have been saved to your device.',
                    fontSize: context.fontSizeMedium,
                    color: Colors.white,
                    textAlign: context.textCenter,
                  ),
                  OsmeaComponents.sizedBox(height: context.height16),
                  OsmeaComponents.text(
                    'You can find them in the Files app > On My iPhone.',
                    fontSize: context.fontSizeSmall,
                    color: Colors.white.withValues(alpha: 0.8),
                    textAlign: context.textCenter,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withValues(alpha: 0.8),
                    foregroundColor: Colors.white,
                  ),
                  child: OsmeaComponents.text('OK'),
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
            content: Text('Failed to save PDFs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
