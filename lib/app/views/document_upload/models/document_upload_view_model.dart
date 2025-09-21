import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/services/ocr_service.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/document_upload/models/module/state.dart';

class DocumentUploadViewModel
    extends Bloc<DocumentUploadEvent, DocumentUploadState> {
  DocumentUploadViewModel() : super(const DocumentUploadInitialState()) {
    on<DocumentUploadInitialEvent>(_onInitial);
    on<DocumentUploadDocumentsSelectedEvent>(_onDocumentsSelected);
    on<DocumentUploadDocumentRemovedEvent>(_onDocumentRemoved);
    on<DocumentUploadClearDocumentsEvent>(_onClearDocuments);
    on<DocumentUploadProcessingStartedEvent>(_onProcessingStarted);
    on<DocumentUploadProcessingCompletedEvent>(_onProcessingCompleted);
    on<DocumentUploadProcessingFailedEvent>(_onProcessingFailed);
  }

  /// Handle initial event
  void _onInitial(
    DocumentUploadInitialEvent event,
    Emitter<DocumentUploadState> emit,
  ) {
    Logger.info(
      'DocumentUploadViewModel initialized',
      category: LogCategory.document,
    );
    emit(const DocumentUploadLoadedState(documents: []));
  }

  /// Handle documents selected event
  void _onDocumentsSelected(
    DocumentUploadDocumentsSelectedEvent event,
    Emitter<DocumentUploadState> emit,
  ) {
    Logger.info(
      'Documents selected',
      category: LogCategory.document,
      data: {'count': event.documents.length},
    );

    if (state is DocumentUploadLoadedState) {
      final currentState = state as DocumentUploadLoadedState;
      final updatedDocuments = List<DocumentFile>.from(currentState.documents)
        ..addAll(event.documents);

      emit(currentState.copyWith(documents: updatedDocuments));
    } else {
      emit(DocumentUploadLoadedState(documents: event.documents));
    }
  }

  /// Handle document removed event
  void _onDocumentRemoved(
    DocumentUploadDocumentRemovedEvent event,
    Emitter<DocumentUploadState> emit,
  ) {
    Logger.info(
      'Document removed',
      category: LogCategory.document,
      data: {'documentName': event.documentName},
    );

    if (state is DocumentUploadLoadedState) {
      final currentState = state as DocumentUploadLoadedState;
      final updatedDocuments = currentState.documents
          .where((doc) => doc.name != event.documentName)
          .toList();

      emit(currentState.copyWith(documents: updatedDocuments));
    }
  }

  /// Handle clear documents event
  void _onClearDocuments(
    DocumentUploadClearDocumentsEvent event,
    Emitter<DocumentUploadState> emit,
  ) {
    Logger.info('All documents cleared', category: LogCategory.document);
    emit(const DocumentUploadLoadedState(documents: []));
  }

  /// Handle processing started event
  void _onProcessingStarted(
    DocumentUploadProcessingStartedEvent event,
    Emitter<DocumentUploadState> emit,
  ) {
    Logger.info('Document processing started', category: LogCategory.document);

    if (state is DocumentUploadLoadedState) {
      final currentState = state as DocumentUploadLoadedState;
      emit(currentState.copyWith(isProcessing: true));
    }
  }

  /// Handle processing completed event
  void _onProcessingCompleted(
    DocumentUploadProcessingCompletedEvent event,
    Emitter<DocumentUploadState> emit,
  ) {
    Logger.info(
      'Document processing completed',
      category: LogCategory.document,
      data: {'textLength': event.result.length},
    );

    if (state is DocumentUploadLoadedState) {
      final currentState = state as DocumentUploadLoadedState;
      emit(
        DocumentUploadSuccessState(
          documents: currentState.documents,
          extractedText: event.result,
        ),
      );
    }
  }

  /// Handle processing failed event
  void _onProcessingFailed(
    DocumentUploadProcessingFailedEvent event,
    Emitter<DocumentUploadState> emit,
  ) {
    Logger.error(
      'Document processing failed',
      category: LogCategory.document,
      data: {'error': event.error},
    );

    if (state is DocumentUploadLoadedState) {
      final currentState = state as DocumentUploadLoadedState;
      emit(
        DocumentUploadErrorState(
          error: event.error,
          documents: currentState.documents,
        ),
      );
    } else {
      emit(DocumentUploadErrorState(error: event.error));
    }
  }

  /// Process documents with OCR
  Future<void> processDocuments(List<DocumentFile> documents) async {
    try {
      add(const DocumentUploadProcessingStartedEvent());

      Logger.info(
        'Starting OCR processing',
        category: LogCategory.ocr,
        data: {'documentCount': documents.length},
      );

      String extractedText = '';

      for (int i = 0; i < documents.length; i++) {
        final document = documents[i];

        try {
          Logger.info(
            'Processing document ${i + 1}/${documents.length}',
            category: LogCategory.ocr,
            data: {'document': document.name},
          );

          final text = await OCRService.extractTextFromFile(document.path);
          extractedText += '--- ${document.name} ---\n$text\n\n';
        } catch (e) {
          Logger.warning(
            'Failed to process document',
            category: LogCategory.ocr,
            data: {'document': document.name, 'error': e.toString()},
          );
          extractedText +=
              '--- ${document.name} ---\n[Error processing this document: $e]\n\n';
        }
      }

      add(DocumentUploadProcessingCompletedEvent(extractedText.trim()));
    } catch (e) {
      Logger.error(
        'OCR processing failed',
        category: LogCategory.ocr,
        data: {'error': e.toString()},
      );
      add(DocumentUploadProcessingFailedEvent(e.toString()));
    }
  }

  /// Remove document by name
  void removeDocument(String documentName) {
    add(DocumentUploadDocumentRemovedEvent(documentName));
  }

  /// Clear all documents
  void clearDocuments() {
    add(const DocumentUploadClearDocumentsEvent());
  }
}
