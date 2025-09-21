# Cursor Rules for Pupilica AI Hackathon

This folder contains rules for Cursor IDE to understand the project structure and coding standards. These rules enable Cursor to provide smarter code suggestions and generate code that follows the project architecture.

## 📁 File Structure

### `view_structure.cursorrules`
This file defines the view structure and BLoC pattern usage in the Flutter project:

- **View Folder Structure**: Each view has its own folder
- **BLoC Pattern**: Event, State, and ViewModel structure
- **OSM Components**: UI component usage
- **Logger Integration**: Logging standards
- **Navigation**: GoRouter usage

### `logger_usage.cursorrules`
This file defines comprehensive logging standards and best practices:

- **Logger Usage**: When and how to use Logger instead of print/debugPrint
- **Log Categories**: Proper categorization of different types of logs
- **Log Levels**: Debug, Info, Warning, Error, and Success levels
- **Code Examples**: Real-world examples of proper logging
- **Migration Guidelines**: How to refactor existing print statements

### `osmea_components_usage.cursorrules`
This file defines comprehensive UI component usage standards:

- **OsmeaComponents Usage**: When and how to use OsmeaComponents instead of standard Flutter widgets
- **Component Library**: Complete list of available OsmeaComponents (50+ components)
- **Layout Components**: Scaffold, Container, Column, Row, Stack, etc.
- **UI Components**: Text, Buttons, Forms, Lists, Cards, etc.
- **Color System**: OsmeaColors instead of standard Colors
- **Visual Effects**: BoxShadow usage is PROHIBITED - use borders and alpha values instead
- **Code Examples**: Real-world examples of proper component usage
- **Migration Guidelines**: How to refactor existing Flutter widgets

### `osmea-sizer-extensions.cursorrules`
This file defines responsive design and sizing standards:

- **Sizer Extensions**: 500+ utility methods for responsive design
- **Screen Dimensions**: Dynamic width/height calculations
- **Spacing System**: Consistent padding, margin, and spacing values
- **Animation Durations**: Predefined timing constants
- **Border Radius**: Standard radius values
- **Mobile-First**: Responsive design patterns

### `boxshadow-prohibition.cursorrules`
This file defines strict visual design standards:

- **BoxShadow Prohibition**: BoxShadow usage is STRICTLY PROHIBITED
- **Clean Flat Design**: Focus on borders, colors, and spacing
- **Alternative Techniques**: Border-based depth, alpha layering, color contrast
- **Performance Benefits**: No expensive shadow calculations
- **Code Examples**: Real-world examples of proper alternatives
- **Mobile-First**: Touch-friendly design principles

## 🎯 Purpose

With these rules, Cursor can:

1. **Code Generation**: Generate code that follows the project structure
2. **Refactoring**: Safely refactor existing code
3. **Debugging**: Better error detection
4. **Code Completion**: Provide smarter code completion suggestions
5. **Architecture Understanding**: Understand the project architecture

## 🚀 Usage

Cursor IDE automatically reads these rules and provides suggestions that follow these standards when working on the project. This ensures:

- Consistent code structure
- Fast development
- Fewer errors
- Professional code quality

## 📝 Note

These rules are specifically designed for the Pupilica AI Hackathon project and can be updated as the project evolves.
