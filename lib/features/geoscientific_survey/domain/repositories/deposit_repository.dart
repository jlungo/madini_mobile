import '../entities/deposit_entity.dart';

abstract class DepositRepository {
  Future<List<DepositEntity>> getDeposits();
  Future<DepositEntity?> getDepositById(String id);
  Future<DepositEntity?> createDeposit(DepositEntity deposit);
  Future<DepositEntity?> updateDeposit(String id, DepositEntity deposit);
  Future<bool> deleteDeposit(String id);
}
