
abstract class SettingsState  {
  List<Object> get props;
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoading extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLoaded extends SettingsState {
  @override
  List<Object> get props => [];
}

class SettingsLogOut extends SettingsState {
  @override
  List<Object> get props => [];
}


class SettingsNetworkError extends SettingsState {
  @override
  List<Object> get props => [];
}
