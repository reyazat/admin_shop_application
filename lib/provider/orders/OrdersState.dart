
abstract class OrdersState  {
  List<Object> get props;
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLoading extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLogOut extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLoaded extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersNetworkError extends OrdersState {
  @override
  List<Object> get props => [];
}
