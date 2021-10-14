import 'package:rider_app/app/widgets/stars.dart';

stars({int? votes, double? rating}) {
  if (votes == 0) {
    return const StarsWidget(
      numberOfStars: 0,
    );
  } else {
    double? finalRate = rating; // votes;
    return StarsWidget(
      numberOfStars: finalRate!.floor(),
    );
  }
}
