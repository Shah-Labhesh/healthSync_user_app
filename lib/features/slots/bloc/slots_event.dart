
abstract class SlotsEvent {}

class AddSlots extends SlotsEvent {
  final Map<String, dynamic> data;

  AddSlots({
    required this.data,
  });
}

class GetMySlots extends SlotsEvent {
  final String sort;

  GetMySlots({
    required this.sort,
  });
}

class GetSlotsOfDoctor extends SlotsEvent {}

class UpdateSlot extends SlotsEvent {
  final String slotId;
  Map<String, dynamic> data;

  UpdateSlot({
    required this.slotId,
    required this.data,
  });
}

class DeleteSlot extends SlotsEvent {
  final String slotId;

  DeleteSlot({
    required this.slotId,
  });
}

