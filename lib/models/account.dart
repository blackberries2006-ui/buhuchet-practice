class SubAccount {
  final String num;
  final String name;

  SubAccount({required this.num, required this.name});
}

class Account {
  final String num;
  final String name;
  final String type; // А, П, АП, З
  final String section;
  final List<SubAccount> subAccounts;

  Account({
    required this.num,
    required this.name,
    required this.type,
    required this.section,
    this.subAccounts = const [],
  });
}
