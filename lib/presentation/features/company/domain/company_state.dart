part of 'company_bloc.dart';

class CompanyState extends Equatable {
  final List<CompanyModel> company;

  const CompanyState({
    this.company = const [],
  });

  @override
  List<Object> get props => [company];
}

final class CompanyInitial extends CompanyState {}

class ProcessLoadingCompany extends CompanyState {}

class CompanyList extends CompanyState {
  const CompanyList({
    super.company = const [],
  });
}

class CompanyOperationFailed extends CompanyList {
  final String reason;

  const CompanyOperationFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.company, reason];
}

class CompanyOperationSuccess extends CompanyState {
  final String message;

  const CompanyOperationSuccess({this.message = ''});
}

class CompanyDeleteOperationSuccess extends CompanyState {}

class CompanyDeleteOperationFailed extends CompanyState {
  final String reason;

  const CompanyDeleteOperationFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.company, reason];
}

class CompanyUpdateCurrentCompany extends CompanyState {
  final String companyId;

  const CompanyUpdateCurrentCompany({required this.companyId});
}
