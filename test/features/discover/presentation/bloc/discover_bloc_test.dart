import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover/data/models/discover_restaurant_model.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_state.dart';
import 'package:rateeat_mobile/src/features/features.dart';

void main() {
  late DiscoveryStepsBloc discoveryStepsBloc;

  setUp(() {
    discoveryStepsBloc = DiscoveryStepsBloc();
  });

  group('DiscoveryStepsBloc', () {
    test('initial state should be DiscoverRestaurantState', () {
      // assert
      expect(
          discoveryStepsBloc.state,
          const DiscoverRestaurantState(
            discoverRestaurantProps: DiscoverRestaurantModel(),
          ));
    });

    group('filter update', () {
      blocTest<DiscoveryStepsBloc, DiscoverRestaurantState>(
        'should emit [ DiscoverRestaurantState] when DiscoveryFilterUpdate is called.',
        build: () {
          return discoveryStepsBloc;
        },
        act: (bloc) => bloc.add(const DiscoveryFilterUpdate()),
        expect: () => <DiscoverRestaurantState>[
          const DiscoverRestaurantState(
            discoverRestaurantProps: DiscoverRestaurantModel(),
          ),
        ],
      );
    });

    group('start flow', () {
      blocTest<DiscoveryStepsBloc, DiscoverRestaurantState>(
        'should emit [ DiscoverRestaurantState] when StartDiscoverFlowEvent is called.',
        build: () {
          return discoveryStepsBloc;
        },
        act: (bloc) => bloc.add(const StartDiscoverFlowEvent()),
        expect: () => <DiscoverRestaurantState>[
          const DiscoverRestaurantState(
            discoverRestaurantProps: DiscoverRestaurantModel(),
          ),
        ],
      );
    });
  });
}
