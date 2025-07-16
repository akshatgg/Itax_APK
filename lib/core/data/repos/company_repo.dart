import 'dart:async';

import '../../utils/list_extenstion.dart';
import '../apis/models/company/company_model.dart';
import 'shared_prefs/shared_pref_repo.dart';
import 'storage/company_storage.dart';

class CompanyRepo {
  final CompanyStorage storageService;
  final SharedPrefRepository sharedPrefRepo;

  CompanyRepo({required this.storageService, required this.sharedPrefRepo});

  final List<CompanyModel> _companies = List.empty(growable: true);
  CompanyModel? _currentCompany;
  final _companyStreamController = StreamController<void>.broadcast();

  Stream<void> get companyStream => _companyStreamController.stream;

  List<CompanyModel> get companies => _companies;

  CompanyModel? get currentCompany => _currentCompany;

  void notifyItemUpdated() {
    _companyStreamController.add(null);
  }

  void dispose() {
    _companyStreamController.close();
  }

  String? errorMessage;

  Future<List<CompanyModel>> getAllCompany({bool notify = true}) async {
    final response = await storageService.getAllCompany();
    if (response.isEmpty) {
      _currentCompany = null;
      _companies.clear();
      sharedPrefRepo.saveCurrentCompany('');
      if (notify) notifyItemUpdated();
      return [];
    }
    final currentCompanyId = await sharedPrefRepo.getCurrentCompany();
    if (currentCompanyId.isNotEmpty) {
      _currentCompany = response.firstWhereOrNull(
        (element) => element.id == currentCompanyId,
      );
      if (_currentCompany == null) {
        _currentCompany = response.last;
        sharedPrefRepo.saveCurrentCompany(_currentCompany!.id);
      }
    } else {
      _currentCompany = response.last;
      sharedPrefRepo.saveCurrentCompany(_currentCompany!.id);
    }
    _biffercateListData(response);
    if (notify) notifyItemUpdated();
    return response;
  }

  Future<CompanyModel?> getCompany() async {
    try {
      final user = await storageService.getCompany();
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<CompanyModel?> createCompany(CompanyModel company) async {
    try {
      final response = await storageService.createCompany(company);
      if (response) {
        getAllCompany();
        return company;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<CompanyModel?> updateCompany(CompanyModel company) async {
    try {
      final response = await storageService.updateCompany(company);
      if (response) {
        getAllCompany();
        return company;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteCompany(
    String companyId,
  ) async {
    final response = await storageService.deleteCompany(companyId);
    if (response) {
      await getAllCompany();
      return true;
    }
    return false;
  }

  void _biffercateListData(List<CompanyModel> company) {
    if (company.isEmpty) return;
    _companies.clear();
    for (var item in company) {
      _companies.add(item);
    }
  }

  void updateCurrentCompany(int index) {
    _currentCompany = _companies[index];
    sharedPrefRepo.saveCurrentCompany(_currentCompany!.id);
  }
}
