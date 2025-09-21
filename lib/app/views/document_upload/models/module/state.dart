import 'package:equatable/equatable.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';

/// Base state class for DocumentUpload
abstract class DocumentUploadState extends Equatable {
  const DocumentUploadState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DocumentUploadInitialState extends DocumentUploadState {
  const DocumentUploadInitialState();
}

/// Loading state
class DocumentUploadLoadingState extends DocumentUploadState {
  const DocumentUploadLoadingState();
}

/// Loaded state with documents
class DocumentUploadLoadedState extends DocumentUploadState {
  final List<DocumentFile> documents;
  final bool isProcessing;

  const DocumentUploadLoadedState({
    required this.documents,
    this.isProcessing = false,
  });

  @override
  List<Object?> get props => [documents, isProcessing];

  /// Copy with updated values
  DocumentUploadLoadedState copyWith({
    List<DocumentFile>? documents,
    bool? isProcessing,
  }) {
    return DocumentUploadLoadedState(
      documents: documents ?? this.documents,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

/// Processing state
class DocumentUploadProcessingState extends DocumentUploadState {
  final List<DocumentFile> documents;
  final String currentDocument;
  final double progress;

  const DocumentUploadProcessingState({
    required this.documents,
    required this.currentDocument,
    required this.progress,
  });

  @override
  List<Object?> get props => [documents, currentDocument, progress];
}

/// Success state
class DocumentUploadSuccessState extends DocumentUploadState {
  final List<DocumentFile> documents;
  final String extractedText;

  const DocumentUploadSuccessState({
    required this.documents,
    required this.extractedText,
  });

  @override
  List<Object?> get props => [documents, extractedText];
}

/// Error state
class DocumentUploadErrorState extends DocumentUploadState {
  final String error;
  final List<DocumentFile>? documents;

  const DocumentUploadErrorState({required this.error, this.documents});

  @override
  List<Object?> get props => [error, documents];
}
