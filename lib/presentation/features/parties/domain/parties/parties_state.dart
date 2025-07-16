part of 'parties_bloc.dart';

class PartiesState extends Equatable {
  final List<PartyModel> customers;
  final List<PartyModel> suppliers;

  const PartiesState({
    this.customers = const [],
    this.suppliers = const [],
  });

  @override
  List<Object> get props => [customers, suppliers];
}

class GSTValidationFailed extends PartiesState {
  final String reason;

  const GSTValidationFailed({
    this.reason = '',
  });
}

class GSTValidationSuccess extends PartiesState {
  final GSTResponse data;
  const GSTValidationSuccess({
    required this.data,
  });
}

final class PartiesInitial extends PartiesState {}

class ProcessLoading extends PartiesState {}

class PartiesList extends PartiesState {
  const PartiesList({
    super.customers = const [],
    super.suppliers = const [],
  });
}

class PartyOperationFailed extends PartiesState {
  final String reason;

  const PartyOperationFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.customers, super.suppliers, reason];
}

class PartyUpdateOperationFailed extends PartiesState {
  final String reason;

  const PartyUpdateOperationFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.customers, super.suppliers, reason];
}

class PartyDeleteOperationFailed extends PartiesState {
  final String reason;

  const PartyDeleteOperationFailed({
    this.reason = '',
  });

  @override
  List<Object> get props => [super.customers, super.suppliers, reason];
}

class PartyOperationSuccess extends PartiesState {
  const PartyOperationSuccess();
}

class PartyUpdateOperationSuccess extends PartiesState {
  const PartyUpdateOperationSuccess();
}

class PartyDeleteOperationSuccess extends PartiesState {
  const PartyDeleteOperationSuccess();
}
