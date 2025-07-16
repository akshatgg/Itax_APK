part of 'company_bloc.dart';

sealed class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class OnGetCompany extends CompanyEvent {
  const OnGetCompany();
}

class OnCompanyLoaded extends CompanyEvent {}

class OnAddCompany extends CompanyEvent {
  final CompanyModel companyModel;
  final File? companyImage;
  const OnAddCompany({
    required this.companyModel,
    this.companyImage,
  });
}

class OnDeleteCompany extends CompanyEvent {
  final CompanyModel companyModel;

  const OnDeleteCompany({
    required this.companyModel,
  });
}

class OnUpdateCompany extends CompanyEvent {
  final CompanyModel companyModel;
  final File? companyImage;
  const OnUpdateCompany({
    required this.companyModel,
    this.companyImage,
  });
}

class OnUpdateCurrentCompany extends CompanyEvent {
  final int index;

  const OnUpdateCurrentCompany({
    required this.index,
  });
}
