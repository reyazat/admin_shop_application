
abstract class ClientsState  {
  List<Object> get props;
  const ClientsState();
}

class ClientsInitial extends ClientsState {
  @override
  List<Object> get props => [];
}

class ClientsLoading extends ClientsState {
  @override
  List<Object> get props => [];
}

class ClientsLoaded extends ClientsState {
  @override
  List<Object> get props => [];
}