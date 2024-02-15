
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_mobile_app/network/helper/network_helper.dart';

part 'network_event.dart';
part 'network_state.dart';

// enum NetworkStatus { connected, disconnected, unknown }
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkInitial()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }
  static final NetworkBloc _instance = NetworkBloc._();

  factory NetworkBloc() => _instance;

  void _observe(event, emit) {
    NetworkHelper.observeNetwork();
  }

  void _notifyStatus(NetworkNotify event, emit) {
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailure());
  }
}
