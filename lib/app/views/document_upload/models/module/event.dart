import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';

/// Base event class for DocumentUpload
abstract class DocumentUploadEvent extends Equatable {
  const DocumentUploadEvent();

  @override
  List<Object?> get props => [];
}

/// Initial event to initialize the DocumentUpload
class DocumentUploadInitialEvent extends DocumentUploadEvent {
  final BuildContext context;

  const DocumentUploadInitialEvent(this.context);

  @override
  List<Object?> get props => [context];
}

/// Event when documents are selected
class DocumentUploadDocumentsSelectedEvent extends DocumentUploadEvent {
  final List<DocumentFile> documents;

  const DocumentUploadDocumentsSelectedEvent(this.documents);

  @override
  List<Object?> get props => [documents];
}

/// Event when documents are removed
class DocumentUploadDocumentRemovedEvent extends DocumentUploadEvent {
  final String documentName;

  const DocumentUploadDocumentRemovedEvent(this.documentName);

  @override
  List<Object?> get props => [documentName];
}

/// Event to clear all documents
class DocumentUploadClearDocumentsEvent extends DocumentUploadEvent {
  const DocumentUploadClearDocumentsEvent();
}

/// Event when processing starts
class DocumentUploadProcessingStartedEvent extends DocumentUploadEvent {
  const DocumentUploadProcessingStartedEvent();
}

/// Event when processing completes
class DocumentUploadProcessingCompletedEvent extends DocumentUploadEvent {
  final String result;

  const DocumentUploadProcessingCompletedEvent(this.result);

  @override
  List<Object?> get props => [result];
}

/// Event when processing fails
class DocumentUploadProcessingFailedEvent extends DocumentUploadEvent {
  final String error;

  const DocumentUploadProcessingFailedEvent(this.error);

  @override
  List<Object?> get props => [error];
}
