import 'package:equatable/equatable.dart';

class SelectedTagState extends Equatable {
  final List<String> selectedTags;

  const SelectedTagState(this.selectedTags);

  @override
  List<Object> get props => [selectedTags];
}
