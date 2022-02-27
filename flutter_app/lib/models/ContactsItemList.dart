class ContactsItemList extends StatelessWidget {
  final String _contactName;

  ContactsItemList(this._contactName);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.message),
        title: Text(_contactName),
      ),
    );
    throw UnimplementedError();
  }
}