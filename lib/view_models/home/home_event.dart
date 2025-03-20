part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class LoadHomeData extends HomeEvent {
  const LoadHomeData();

  @override
  List<Object> get props => [];
}