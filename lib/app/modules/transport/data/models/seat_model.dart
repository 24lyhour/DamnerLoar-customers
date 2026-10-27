/// Seat model for bus seat selection.
enum SeatStatus { available, booked, selected }

class SeatModel {
  SeatModel({
    required this.id,
    required this.row,
    required this.column,
    required this.label,
    this.status = SeatStatus.available,
    this.price,
  });

  final String id;
  final int row;
  final int column;
  final String label;
  SeatStatus status;
  final double? price;

  bool get isAvailable => status == SeatStatus.available;
  bool get isBooked => status == SeatStatus.booked;
  bool get isSelected => status == SeatStatus.selected;

  SeatModel copyWith({SeatStatus? status}) {
    return SeatModel(
      id: id,
      row: row,
      column: column,
      label: label,
      status: status ?? this.status,
      price: price,
    );
  }
}

/// Bus layout configuration.
class BusLayout {
  const BusLayout({
    required this.rows,
    required this.columnsLeft,
    required this.columnsRight,
    this.hasAisle = true,
  });

  final int rows;
  final int columnsLeft;
  final int columnsRight;
  final bool hasAisle;

  int get totalColumns => columnsLeft + columnsRight + (hasAisle ? 1 : 0);
}
