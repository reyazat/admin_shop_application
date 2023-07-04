
abstract class HomeState  {
  List<Object> get props;
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLogOut extends HomeState {
  @override
  List<Object> get props => [];
}


class HomeNetworkError extends HomeState {
  @override
  List<Object> get props => [];
}
