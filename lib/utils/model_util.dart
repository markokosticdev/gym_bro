import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

Widget wrapWithModel<T extends BaseModel>({
  required T model,
  required Widget child,
  required VoidCallback updateCallback,
  bool updateOnChange = false,
}) {
  model.setOnUpdate(
    onUpdate: updateCallback,
    updateOnChange: updateOnChange,
  );

  model.disposeOnWidgetDisposal = false;

  return Provider<T>.value(
    value: model,
    child: child,
  );
}

T createModel<T extends BaseModel>(
  BuildContext context,
  T Function() defaultBuilder,
) {
  final model = context.read<T?>() ?? defaultBuilder();
  model._init(context);
  return model;
}

abstract class BaseModel<W extends Widget> {
  bool _isInitialized = false;
  void initState(BuildContext context);
  void _init(BuildContext context) {
    if (!_isInitialized) {
      initState(context);
      _isInitialized = true;
    }
    if (context.widget is W) _widget = context.widget as W;
  }

  W? _widget;
  W? get widget => _widget;

  bool disposeOnWidgetDisposal = true;
  void dispose();
  void maybeDispose() {
    if (disposeOnWidgetDisposal) {
      dispose();
    }

    _widget = null;
  }

  bool updateOnChange = false;

  VoidCallback _updateCallback = () {};
  void onUpdate() => updateOnChange ? _updateCallback() : () {};
  BaseModel setOnUpdate({
    bool updateOnChange = false,
    required VoidCallback onUpdate,
  }) =>
      this
        .._updateCallback = onUpdate
        ..updateOnChange = updateOnChange;

  void updatePage(VoidCallback callback) {
    callback();
    _updateCallback();
  }
}

class AppDynamicModels<T extends BaseModel> {
  AppDynamicModels(this.defaultBuilder);

  final T Function() defaultBuilder;
  final Map<String, T> _childrenModels = {};
  final Map<String, int> _childrenIndexes = {};
  Set<String>? _activeKeys;

  T getModel(String uniqueKey, int index) {
    _updateActiveKeys(uniqueKey);
    _childrenIndexes[uniqueKey] = index;
    return _childrenModels[uniqueKey] ??= defaultBuilder();
  }

  List<S> getValues<S>(S? Function(T) getValue) {
    return _childrenIndexes.entries
        .sorted((a, b) => a.value.compareTo(b.value))
        .where((e) => _childrenModels[e.key] != null)
        .map((e) => getValue(_childrenModels[e.key]!) ?? _getDefaultValue<S>()!)
        .toList();
  }

  S? getValueAtIndex<S>(int index, S? Function(T) getValue) {
    final uniqueKey =
        _childrenIndexes.entries.firstWhereOrNull((e) => e.value == index)?.key;
    return getValueForKey(uniqueKey, getValue);
  }

  S? getValueForKey<S>(String? uniqueKey, S? Function(T) getValue) {
    final model = _childrenModels[uniqueKey];
    return model != null ? getValue(model) : null;
  }

  void dispose() => _childrenModels.values.forEach((model) => model.dispose());

  void _updateActiveKeys(String uniqueKey) {
    final shouldResetActiveKeys = _activeKeys == null;
    _activeKeys ??= {};
    _activeKeys!.add(uniqueKey);

    if (shouldResetActiveKeys) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _childrenIndexes.removeWhere((k, _) => !_activeKeys!.contains(k));
        _childrenModels.keys
            .toSet()
            .difference(_activeKeys!)
            .forEach((k) => _childrenModels.remove(k)?.maybeDispose());
        _activeKeys = null;
      });
    }
  }
}

T? _getDefaultValue<T>() {
  switch (T) {
    case int:
      return 0 as T;
    case double:
      return 0.0 as T;
    case String:
      return '' as T;
    case bool:
      return false as T;
    default:
      return null as T;
  }
}

extension TextValidationExtensions on String? Function(BuildContext, String?)? {
  String? Function(String?)? asValidator(BuildContext context) =>
      this != null ? (val) => this!(context, val) : null;
}
