import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupilica_hackathon/core/helpers/logger.dart';
import 'package:pupilica_hackathon/core/helpers/local_storage_helper.dart';
import 'package:pupilica_hackathon/core/models/lesson_note.dart';
import 'package:pupilica_hackathon/core/services/document_service.dart';
import 'package:pupilica_hackathon/app/views/lesson_creation/models/module/event.dart';
import 'package:pupilica_hackathon/app/views/lesson_creation/models/module/state.dart';

class LessonCreationViewModel
    extends Bloc<LessonCreationEvent, LessonCreationState> {
  LessonCreationViewModel() : super(const LessonCreationInitialState()) {
    on<LessonCreationInitialEvent>(_onInitial);
    on<LessonCreationSaveEvent>(_onSave);
    on<LessonCreationUpdateTextEvent>(_onUpdateText);
    on<LessonCreationUpdateTitleEvent>(_onUpdateTitle);
    on<LessonCreationUpdateSubjectEvent>(_onUpdateSubject);
    on<LessonCreationUpdateDescriptionEvent>(_onUpdateDescription);
  }

  /// Handle initial event
  void _onInitial(
    LessonCreationInitialEvent event,
    Emitter<LessonCreationState> emit,
  ) {
    Logger.info(
      'LessonCreationViewModel initialized',
      category: LogCategory.ui,
      data: {
        'documentCount': event.documents.length,
        'textLength': event.extractedText.length,
      },
    );

    emit(
      LessonCreationLoadedState(
        documents: event.documents,
        extractedText: event.extractedText,
      ),
    );
  }

  /// Handle save event
  Future<void> _onSave(
    LessonCreationSaveEvent event,
    Emitter<LessonCreationState> emit,
  ) async {
    Logger.info(
      'Saving lesson',
      category: LogCategory.document,
      data: {
        'title': event.title,
        'subject': event.subject,
        'textLength': event.extractedText.length,
      },
    );

    emit(const LessonCreationLoadingState());

    try {
      // Create lesson note
      final now = DateTime.now();
      final lessonNote = LessonNote(
        id: now.millisecondsSinceEpoch.toString(),
        title: event.title.trim(),
        subject: event.subject.trim(),
        description: event.description.trim(),
        documents: event.documents,
        extractedText: event.extractedText.trim(),
        isProcessed: true,
        createdAt: now,
        updatedAt: now,
      );

      // Save to local storage
      await LocalStorageHelper.saveLessonNote(lessonNote);

      Logger.success(
        'Lesson saved successfully',
        category: LogCategory.document,
        data: {'lessonId': lessonNote.id},
      );

      if (!isClosed) {
        emit(LessonCreationSuccessState('Lesson saved successfully!'));
      }
    } catch (e) {
      Logger.error(
        'Failed to save lesson',
        category: LogCategory.document,
        data: {'error': e.toString()},
      );

      if (!isClosed) {
        emit(LessonCreationErrorState('Failed to save lesson: $e'));
      }
    }
  }

  /// Handle update text event
  void _onUpdateText(
    LessonCreationUpdateTextEvent event,
    Emitter<LessonCreationState> emit,
  ) {
    Logger.info(
      'Updating extracted text',
      category: LogCategory.ui,
      data: {'textLength': event.extractedText.length},
    );

    if (state is LessonCreationLoadedState) {
      final currentState = state as LessonCreationLoadedState;
      emit(currentState.copyWith(extractedText: event.extractedText));
    }
  }

  /// Handle update title event
  void _onUpdateTitle(
    LessonCreationUpdateTitleEvent event,
    Emitter<LessonCreationState> emit,
  ) {
    Logger.debug(
      'Updating title',
      category: LogCategory.ui,
      data: {'title': event.title},
    );

    if (state is LessonCreationLoadedState) {
      final currentState = state as LessonCreationLoadedState;
      emit(currentState.copyWith(title: event.title));
    }
  }

  /// Handle update subject event
  void _onUpdateSubject(
    LessonCreationUpdateSubjectEvent event,
    Emitter<LessonCreationState> emit,
  ) {
    Logger.debug(
      'Updating subject',
      category: LogCategory.ui,
      data: {'subject': event.subject},
    );

    if (state is LessonCreationLoadedState) {
      final currentState = state as LessonCreationLoadedState;
      emit(currentState.copyWith(subject: event.subject));
    }
  }

  /// Handle update description event
  void _onUpdateDescription(
    LessonCreationUpdateDescriptionEvent event,
    Emitter<LessonCreationState> emit,
  ) {
    Logger.debug(
      'Updating description',
      category: LogCategory.ui,
      data: {'description': event.description},
    );

    if (state is LessonCreationLoadedState) {
      final currentState = state as LessonCreationLoadedState;
      emit(currentState.copyWith(description: event.description));
    }
  }
}

/// Extension to add copyWith method
extension LessonCreationLoadedStateExtension on LessonCreationLoadedState {
  LessonCreationLoadedState copyWith({
    List<DocumentFile>? documents,
    String? extractedText,
    String? title,
    String? subject,
    String? description,
  }) {
    return LessonCreationLoadedState(
      documents: documents ?? this.documents,
      extractedText: extractedText ?? this.extractedText,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
    );
  }
}
