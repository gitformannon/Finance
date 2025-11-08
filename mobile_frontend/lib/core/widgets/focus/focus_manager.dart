import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced focus management utilities for better keyboard navigation
class AppFocusManager {
  static final AppFocusManager _instance = AppFocusManager._internal();
  factory AppFocusManager() => _instance;
  AppFocusManager._internal();

  /// Focus nodes registry for managing multiple focus nodes
  final Map<String, FocusNode> _focusNodes = {};
  
  /// Current focus scope
  FocusScopeNode? _currentScope;

  /// Register a focus node with a unique key
  FocusNode registerFocusNode(String key) {
    if (_focusNodes.containsKey(key)) {
      return _focusNodes[key]!;
    }
    
    final focusNode = FocusNode();
    _focusNodes[key] = focusNode;
    return focusNode;
  }

  /// Get a registered focus node
  FocusNode? getFocusNode(String key) {
    return _focusNodes[key];
  }

  /// Dispose a focus node
  void disposeFocusNode(String key) {
    _focusNodes[key]?.dispose();
    _focusNodes.remove(key);
  }

  /// Dispose all focus nodes
  void disposeAll() {
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    _focusNodes.clear();
  }

  /// Set current focus scope
  void setCurrentScope(FocusScopeNode scope) {
    _currentScope = scope;
  }

  /// Get current focus scope
  FocusScopeNode? get currentScope => _currentScope;

  /// Move focus to next field
  void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to previous field
  void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Unfocus all fields
  void unfocusAll(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Focus on specific field by key
  void focusField(String key) {
    final focusNode = _focusNodes[key];
    if (focusNode != null && focusNode.canRequestFocus) {
      focusNode.requestFocus();
    }
  }

  /// Handle keyboard shortcuts
  void handleKeyboardShortcuts(BuildContext context, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle Tab key for navigation
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        if (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
            HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftRight)) {
          previousFocus(context);
        } else {
          nextFocus(context);
        }
      }
      
      // Handle Escape key to unfocus
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        unfocusAll(context);
      }
      
      // Handle Enter key to submit forms
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _handleEnterKey(context);
      }
    }
  }

  /// Handle Enter key press
  void _handleEnterKey(BuildContext context) {
    final currentFocus = FocusScope.of(context).focusedChild;
    if (currentFocus != null) {
      // If focused on a text field, move to next field
      if (currentFocus.context?.widget is EditableText) {
        nextFocus(context);
      }
    }
  }
}

/// Focus-aware widget that automatically handles focus management
class FocusAwareWidget extends StatefulWidget {
  const FocusAwareWidget({
    super.key,
    required this.child,
    this.onFocusChanged,
    this.autofocus = false,
    this.focusKey,
  });

  final Widget child;
  final ValueChanged<bool>? onFocusChanged;
  final bool autofocus;
  final String? focusKey;

  @override
  State<FocusAwareWidget> createState() => _FocusAwareWidgetState();
}

class _FocusAwareWidgetState extends State<FocusAwareWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusKey != null 
        ? AppFocusManager().registerFocusNode(widget.focusKey!)
        : FocusNode();
    
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
    
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusKey != null) {
      AppFocusManager().disposeFocusNode(widget.focusKey!);
    } else {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      widget.onFocusChanged?.call(_isFocused);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: widget.child,
    );
  }
}

/// Enhanced form field with better focus management
class EnhancedFormField extends StatefulWidget {
  const EnhancedFormField({
    super.key,
    required this.child,
    this.nextFocusKey,
    this.previousFocusKey,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.focusKey,
  });

  final Widget child;
  final String? nextFocusKey;
  final String? previousFocusKey;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final String? focusKey;

  @override
  State<EnhancedFormField> createState() => _EnhancedFormFieldState();
}

class _EnhancedFormFieldState extends State<EnhancedFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusKey != null 
        ? AppFocusManager().registerFocusNode(widget.focusKey!)
        : FocusNode();
    
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusKey != null) {
      AppFocusManager().disposeFocusNode(widget.focusKey!);
    } else {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleSubmitted(String value) {
    widget.onSubmitted?.call(value);
    
    // Move to next field if specified
    if (widget.nextFocusKey != null) {
      AppFocusManager().focusField(widget.nextFocusKey!);
    } else {
      AppFocusManager().nextFocus(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        // Handle keyboard shortcuts
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            if (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
                HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftRight)) {
              // Move to previous field
              if (widget.previousFocusKey != null) {
                AppFocusManager().focusField(widget.previousFocusKey!);
              } else {
                AppFocusManager().previousFocus(context);
              }
            } else {
              // Move to next field
              if (widget.nextFocusKey != null) {
                AppFocusManager().focusField(widget.nextFocusKey!);
              } else {
                AppFocusManager().nextFocus(context);
              }
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}

/// Focus scope wrapper for modals and forms
class FocusScopeWrapper extends StatefulWidget {
  const FocusScopeWrapper({
    super.key,
    required this.child,
    this.autofocus = true,
    this.onFocusChanged,
  });

  final Widget child;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChanged;

  @override
  State<FocusScopeWrapper> createState() => _FocusScopeWrapperState();
}

class _FocusScopeWrapperState extends State<FocusScopeWrapper> {
  late FocusScopeNode _focusScope;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusScope = FocusScopeNode();
    AppFocusManager().setCurrentScope(_focusScope);
    
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusScope.requestFocus();
      });
    }
    
    _focusScope.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusScope.removeListener(_onFocusChanged);
    _focusScope.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_hasFocus != _focusScope.hasFocus) {
      setState(() {
        _hasFocus = _focusScope.hasFocus;
      });
      widget.onFocusChanged?.call(_hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScope,
      child: widget.child,
    );
  }
}

/// Keyboard shortcut handler widget
class KeyboardShortcutHandler extends StatefulWidget {
  const KeyboardShortcutHandler({
    super.key,
    required this.child,
    this.shortcuts = const {},
    this.onEscape,
    this.onEnter,
    this.onTab,
  });

  final Widget child;
  final Map<LogicalKeySet, Intent> shortcuts;
  final VoidCallback? onEscape;
  final VoidCallback? onEnter;
  final VoidCallback? onTab;

  @override
  State<KeyboardShortcutHandler> createState() => _KeyboardShortcutHandlerState();
}

class _KeyboardShortcutHandlerState extends State<KeyboardShortcutHandler> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        ...widget.shortcuts,
        LogicalKeySet(LogicalKeyboardKey.escape): const _EscapeIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const _EnterIntent(),
        LogicalKeySet(LogicalKeyboardKey.tab): const _TabIntent(),
      },
      child: Actions(
        actions: {
          _EscapeIntent: CallbackAction<_EscapeIntent>(
            onInvoke: (_) => widget.onEscape?.call(),
          ),
          _EnterIntent: CallbackAction<_EnterIntent>(
            onInvoke: (_) => widget.onEnter?.call(),
          ),
          _TabIntent: CallbackAction<_TabIntent>(
            onInvoke: (_) => widget.onTab?.call(),
          ),
        },
        child: Focus(
          autofocus: true,
          child: widget.child,
        ),
      ),
    );
  }
}

class _EscapeIntent extends Intent {
  const _EscapeIntent();
}

class _EnterIntent extends Intent {
  const _EnterIntent();
}

class _TabIntent extends Intent {
  const _TabIntent();
}
