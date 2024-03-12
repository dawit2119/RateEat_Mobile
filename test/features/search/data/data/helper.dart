sortByRating(dynamic dummyLists) {
  dummyLists.sort(
    (a, b) => a.averageRating!.compareTo(b.averageRating!),
  );
  return dummyLists;
}

sortByPrice(dynamic dummyLists) {
  dummyLists.sort(
    (a, b) => a.price!.compareTo(b.price!),
  );
  return dummyLists;
}

sortByPopularity(dynamic dummyLists) {
  dummyLists.sort(
    (a, b) => a.popularityIndex!.compareTo(b.popularityIndex!),
  );
  return dummyLists;
}

sortByDistance(dynamic dummyLists) {
  dummyLists.sort((a, b) {
    var aDistance = double.parse(
      a.distance.split(" ")[0],
    );
    var bDistance = double.parse(
      b.distance.split(" ")[0],
    );
    return aDistance.compareTo(bDistance);
  });
  return dummyLists;
}
