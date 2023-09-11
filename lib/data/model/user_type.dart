


class UserType{

  String type;
  int id;

  UserType({
    required this.id,
    required this.type
});

  @override
  bool operator ==(o) => o is UserType && type == o.type;

  @override
  int get hashCode => Object.hash(id, type);

}