import 'package:flutter/foundation.dart';

import '../../domain/entities/mapping_activity_entity.dart';
import '../../domain/repositories/mapping_activity_repository.dart';

/// Controller for mapping activity list, detail, create, and edit.
/// Assumes caller is authenticated; route guard and API layer enforce auth.
class MappingActivityController extends ChangeNotifier {
  final MappingActivityRepository _repository;

  MappingActivityController({required MappingActivityRepository repository})
      : _repository = repository;

  List<MappingActivityEntity> _activities = [];
  MappingActivityEntity? _selectedActivity;
  bool _isLoading = false;
  String? _errorMessage;

  List<MappingActivityEntity> get activities => List.unmodifiable(_activities);
  MappingActivityEntity? get selectedActivity => _selectedActivity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearSelection() {
    if (_selectedActivity != null) {
      _selectedActivity = null;
      notifyListeners();
    }
  }

  Future<void> loadActivities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _activities = await _repository.getActivities();
    } catch (e, st) {
      _errorMessage = e.toString();
      if (kDebugMode) debugPrintStack(stackTrace: st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadActivityById(String id) async {
    if (id.isEmpty) return;
    _isLoading = true;
    _errorMessage = null;
    _selectedActivity = null;
    notifyListeners();
    try {
      _selectedActivity = await _repository.getActivityById(id);
    } catch (e, st) {
      _errorMessage = e.toString();
      if (kDebugMode) debugPrintStack(stackTrace: st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MappingActivityEntity?> createActivity(MappingActivityEntity activity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final created = await _repository.createActivity(activity);
      _activities = [created, ..._activities];
      _isLoading = false;
      notifyListeners();
      return created;
    } catch (e, st) {
      _errorMessage = e.toString();
      if (kDebugMode) debugPrintStack(stackTrace: st);
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<MappingActivityEntity?> updateActivity(String id, MappingActivityEntity activity) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final updated = await _repository.updateActivity(id, activity);
      final index = _activities.indexWhere((a) => a.id == id);
      if (index >= 0) {
        _activities = List.from(_activities)..[index] = updated;
      } else {
        _activities = [updated, ..._activities];
      }
      if (_selectedActivity?.id == id) _selectedActivity = updated;
      _isLoading = false;
      notifyListeners();
      return updated;
    } catch (e, st) {
      _errorMessage = e.toString();
      if (kDebugMode) debugPrintStack(stackTrace: st);
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteActivity(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.deleteActivity(id);
      _activities = _activities.where((a) => a.id != id).toList();
      if (_selectedActivity?.id == id) _selectedActivity = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, st) {
      _errorMessage = e.toString();
      if (kDebugMode) debugPrintStack(stackTrace: st);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _selectedActivity = null;
    _activities = [];
    super.dispose();
  }
}
