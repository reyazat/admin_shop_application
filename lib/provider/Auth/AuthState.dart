
abstract class AuthState  {
  List<Object> get props;
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLogined extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoaded extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthNetworkError extends AuthState {
  @override
  List<Object> get props => [];
}
