abstract class ProductsState  {
  List<Object> get props;
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  @override
  List<Object> get props => [];
}

class ProductsLoading extends ProductsState {
  @override
  List<Object> get props => [];
}

class ProductsLoaded extends ProductsState {
  @override
  List<Object> get props => [];
}