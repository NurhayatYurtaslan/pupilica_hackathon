import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:pupilica_hackathon/core/helpers/file_download_helper.dart';
import 'package:pupilica_hackathon/core/services/pdf_service.dart';

class PDFPreviewView extends StatefulWidget {
  final String extractedText;
  final List<String> documentNames;
  final Uint8List? pdfBytes;

  const PDFPreviewView({
    super.key,
    required this.extractedText,
    required this.documentNames,
    this.pdfBytes,
  });

  @override
  State<PDFPreviewView> createState() => _PDFPreviewViewState();
}

class _PDFPreviewViewState extends State<PDFPreviewView> {
  late TextEditingController _titleController;
  late TextEditingController _subjectController;
  Uint8List? _generatedPdfBytes;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: 'Document ${DateTime.now().millisecondsSinceEpoch}',
    );
    _subjectController = TextEditingController(text: 'General');
    _generatedPdfBytes = widget.pdfBytes;

    print('PDF Preview initialized:');
    print('- Extracted text length: ${widget.extractedText.length}');
    print('- Document names: ${widget.documentNames}');
    print('- PDF bytes: ${widget.pdfBytes?.length ?? 'null'}');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.nordicBlue,
      appBar: AppBar(
        backgroundColor: OsmeaColors.nordicBlue,
        foregroundColor: Colors.white,
        title: OsmeaComponents.text(
          'PDF Preview',
          fontSize: context.fontSizeLarge,
          fontWeight: context.bold,
          color: Colors.white,
        ),
        actions: [
          if (_generatedPdfBytes != null)
            IconButton(
              onPressed: () => _showPDFOptions(context),
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
        ],
      ),
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
                  // PDF Info Form
                  _buildPDFInfoForm(context),

                  OsmeaComponents.sizedBox(height: context.height20),

                  // Extracted Text Preview
                  _buildExtractedTextPreview(context),

                  OsmeaComponents.sizedBox(height: context.height20),

                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPDFInfoForm(BuildContext context) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.text(
            'PDF Information',
            fontSize: context.fontSizeLarge,
            fontWeight: context.bold,
            color: Colors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height16),

          // Title Field
          OsmeaComponents.text(
            'Title',
            fontSize: context.fontSizeMedium,
            fontWeight: context.semiBold,
            color: Colors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height8),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter PDF title',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
          OsmeaComponents.sizedBox(height: context.height16),

          // Subject Field
          OsmeaComponents.text(
            'Subject',
            fontSize: context.fontSizeMedium,
            fontWeight: context.semiBold,
            color: Colors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height8),
          TextField(
            controller: _subjectController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter PDF subject',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedTextPreview(BuildContext context) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Extracted Text (${widget.extractedText.length} characters)',
            fontSize: context.fontSizeMedium,
            fontWeight: context.semiBold,
            color: Colors.white,
          ),
          OsmeaComponents.sizedBox(height: context.height12),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: OsmeaComponents.text(
                widget.extractedText,
                fontSize: context.fontSizeSmall,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        // Generate PDF Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isGenerating ? null : _generatePDF,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isGenerating
                ? const CircularProgressIndicator(color: Colors.white)
                : OsmeaComponents.text(
                    'Generate PDF',
                    fontSize: context.fontSizeMedium,
                    fontWeight: context.semiBold,
                    color: Colors.white,
                  ),
          ),
        ),

        if (_generatedPdfBytes != null) ...[
          OsmeaComponents.sizedBox(height: context.height12),

          // Download PDF Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _downloadPDF(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: OsmeaComponents.text(
                'Download PDF',
                fontSize: context.fontSizeMedium,
                fontWeight: context.semiBold,
                color: Colors.white,
              ),
            ),
          ),

          OsmeaComponents.sizedBox(height: context.height12),

          // Open PDF Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openPDF(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: OsmeaComponents.text(
                'Open PDF',
                fontSize: context.fontSizeMedium,
                fontWeight: context.semiBold,
                color: Colors.white,
              ),
            ),
          ),

          OsmeaComponents.sizedBox(height: context.height12),

          // Share PDF Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _sharePDF(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: OsmeaComponents.text(
                'Share PDF',
                fontSize: context.fontSizeMedium,
                fontWeight: context.semiBold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _generatePDF() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final pdfBytes = await PDFService.createPDF(
        title: _titleController.text,
        subject: _subjectController.text,
        extractedText: widget.extractedText,
        documentCount: widget.documentNames.length,
      );

      setState(() {
        _generatedPdfBytes = pdfBytes;
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadPDF(BuildContext context) async {
    if (_generatedPdfBytes == null) return;

    try {
      final fileName = '${_titleController.text.replaceAll(' ', '_')}.pdf';

      // Show save location picker
      final savedPath = await FileDownloadHelper.savePDFWithLocationPicker(
        pdfBytes: _generatedPdfBytes!,
        fileName: fileName,
      );

      if (mounted) {
        if (savedPath != null) {
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text('PDF saved successfully to: $savedPath'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(
              content: Text('PDF save cancelled by user'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text('Failed to save PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openPDF(BuildContext context) async {
    if (_generatedPdfBytes == null) return;

    try {
      final fileName = '${_titleController.text.replaceAll(' ', '_')}.pdf';
      await FileDownloadHelper.saveAndOpenPDF(
        pdfBytes: _generatedPdfBytes!,
        fileName: fileName,
        title: _titleController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(
            content: Text('PDF opened successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text('Failed to open PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sharePDF(BuildContext context) async {
    if (_generatedPdfBytes == null) return;

    try {
      final fileName = '${_titleController.text.replaceAll(' ', '_')}.pdf';
      await FileDownloadHelper.saveAndSharePDF(
        pdfBytes: _generatedPdfBytes!,
        fileName: fileName,
        title: _titleController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(
            content: Text('PDF shared successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text('Failed to share PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPDFOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: OsmeaComponents.padding(
          padding: EdgeInsets.all(context.spacing20),
          child: OsmeaComponents.column(
            children: [
              OsmeaComponents.text(
                'PDF Options',
                fontSize: context.fontSizeLarge,
                fontWeight: context.bold,
                color: Colors.white,
                textAlign: context.textCenter,
              ),
              OsmeaComponents.sizedBox(height: context.height20),

              // Download Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _downloadPDF(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: OsmeaComponents.text(
                    'Download PDF',
                    fontSize: context.fontSizeMedium,
                    fontWeight: context.semiBold,
                    color: Colors.white,
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(height: context.height12),

              // Open Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _openPDF(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: OsmeaComponents.text(
                    'Open PDF',
                    fontSize: context.fontSizeMedium,
                    fontWeight: context.semiBold,
                    color: Colors.white,
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(height: context.height12),

              // Share Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _sharePDF(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: OsmeaComponents.text(
                    'Share PDF',
                    fontSize: context.fontSizeMedium,
                    fontWeight: context.semiBold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
