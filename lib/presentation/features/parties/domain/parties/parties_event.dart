part of 'parties_bloc.dart';

sealed class PartiesEvent extends Equatable {
  const PartiesEvent();

  @override
  List<Object> get props => [];
}

class OnValidateGSTNumber extends PartiesEvent {
  final String gstin;

  const OnValidateGSTNumber({required this.gstin});
}

class OnGetParties extends PartiesEvent {
  const OnGetParties();
}

class OnPartiesLoaded extends PartiesEvent {
  const OnPartiesLoaded();
}

class OnAddParty extends PartiesEvent {
  final PartyModel partyModel;

  const OnAddParty({
    required this.partyModel,
  });
}

class OnUpdateParty extends PartiesEvent {
  final PartyModel partyModel;

  const OnUpdateParty({
    required this.partyModel,
  });
}

class OnDeleteParty extends PartiesEvent {
  final PartyModel partyModel;

  const OnDeleteParty({
    required this.partyModel,
  });
}
