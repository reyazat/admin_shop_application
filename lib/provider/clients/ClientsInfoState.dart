
abstract class ClientsInfoState  {
  List<Object> get props;
  const ClientsInfoState();
}

class ClientsInfoInitial extends ClientsInfoState {
  @override
  List<Object> get props => [];
}

class ClientsInfoLoading extends ClientsInfoState {
  @override
  List<Object> get props => [];
}

class ClientsInfoLoaded extends ClientsInfoState {
  @override
  List<Object> get props => [];
}