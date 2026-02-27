import 'package:flutter/foundation.dart';
import '../../domain/entities/deposit_entity.dart';
import '../../domain/repositories/deposit_repository.dart';

class DepositController extends ChangeNotifier {
  final DepositRepository _repository;

  DepositController({required DepositRepository repository})
      : _repository = repository;

  List<DepositEntity> _deposits = [];
  DepositEntity? _selectedDeposit;
  bool _isLoading = false;
  String? _errorMessage;

  List<DepositEntity> get deposits => List.unmodifiable(_deposits);
  DepositEntity? get selectedDeposit => _selectedDeposit;
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
    if (_selectedDeposit != null) {
      _selectedDeposit = null;
      notifyListeners();
    }
  }

  Future<void> loadDeposits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _deposits = await _repository.getDeposits();
    } catch (e, st) {
      _errorMessage = e.toString();
      if (kDebugMode) debugPrintStack(stackTrace: st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDepositById(String id) async {
    if (id.isEmpty) return;
    _isLoading = true;
    _errorMessage = null;
    _selectedDeposit = null;
    notifyListeners();
    try {
      _selectedDeposit = await _repository.getDepositById(id);
    } catch (e, st) {
      _errorMessage = e.toString();
      if (kDebugMode) debugPrintStack(stackTrace: st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<DepositEntity?> createDeposit(DepositEntity deposit) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final created = await _repository.createDeposit(deposit);
      if (created != null) {
        _deposits = [created, ..._deposits];
      }
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

  Future<DepositEntity?> updateDeposit(String id, DepositEntity deposit) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final updated = await _repository.updateDeposit(id, deposit);
      if (updated != null) {
        final index = _deposits.indexWhere((d) => d.id == id);
        if (index >= 0) {
          _deposits = List.from(_deposits)..[index] = updated;
        } else {
          _deposits = [updated, ..._deposits];
        }
        if (_selectedDeposit?.id == id) _selectedDeposit = updated;
      }
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

  Future<bool> deleteDeposit(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final success = await _repository.deleteDeposit(id);
      if (success) {
        _deposits = _deposits.where((d) => d.id != id).toList();
        if (_selectedDeposit?.id == id) _selectedDeposit = null;
      }
      _isLoading = false;
      notifyListeners();
      return success;
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
    _selectedDeposit = null;
    _deposits = [];
    super.dispose();
  }
}
