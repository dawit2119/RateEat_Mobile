import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_event.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_state.dart';

void main() {
  late TagBloc tagBloc;

  setUp(() {
    tagBloc = TagBloc();
  });

  group('TagBloc', () {
    test('initial state is SelectedTagState', () {
      expect(tagBloc.state, const SelectedTagState([]));
    });

    blocTest<TagBloc, SelectedTagState>(
      'should emit [SelectedTagState("tag")] when the call to the SelectTag(tag: tag) event is successful',
      build: () => tagBloc,
      act: (bloc) => bloc.add(const SelectTag(tag: 'tag')),
      expect: () => [
        const SelectedTagState(['tag'])
      ],
    );

    blocTest<TagBloc, SelectedTagState>(
      'should emit [SelectedTagState("")] when the call to the UnselectTag() event is successful',
      build: () => tagBloc,
      act: (bloc) => bloc.add(const UnselectTag(tag: 'tag')),
      expect: () => [const SelectedTagState([])],
    );
  });
}
