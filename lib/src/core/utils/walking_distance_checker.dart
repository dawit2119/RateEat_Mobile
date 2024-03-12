bool isFeasibleWalkingTime({required String walkingTime}) {
  var parsedTime = walkingTime.split(" ");
  var time = parsedTime[0];
  var measurement = parsedTime.length > 1 ? parsedTime[1] : "m";
  var parsedWalkingTime = double.parse(time);
  return parsedWalkingTime <= 40 && measurement == "min";
}
