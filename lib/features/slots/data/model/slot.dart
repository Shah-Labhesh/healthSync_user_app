
class Slot {
  final String date;
  final int slots;
  bool isSelected;
  Slot({
    required this.date,
    required this.slots,
    required this.isSelected,
  });
}


class SlotList {
  final List<Slots> slots;
  SlotList({
    required this.slots,
  });

 
  factory SlotList.fromMap(List<dynamic> map) {
    return SlotList(
      slots: List<Slots>.from((map).map<Slots>((x) => Slots.fromMap(x as Map<String,dynamic>),),),
    );
  }

  
}

class Slots {
    String? slotId;
    String? slotDateTime;
    bool? isBooked;
    String? createdAt;
    String? updatedAt;

    Slots({
        this.slotId,
        this.slotDateTime,
        this.isBooked,
        this.createdAt,
        this.updatedAt,
    });



  factory Slots.fromMap(Map<String, dynamic> map) {
    return Slots(
      slotId: map['id'] != null ? map['id'] as String : null,
      slotDateTime: map['slotDateTime'] != null ? map['slotDateTime'] as String : null,
      isBooked: map['isBooked'] != null ? map['isBooked'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  
}
