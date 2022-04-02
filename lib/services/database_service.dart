import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';

class DatabaseService {

  _initDatabase () async {
    //await deleteDatabase(join(await getDatabasesPath(), 'contacts_database.db'));
    // Open the database and store the reference.
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'contacts_database.db'),
      // When the database is first created, create a table to store Contacts.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, fullName TEXT, phoneNumber TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts Contacts into the database
  Future<void> insertContact(Contact contact) async {

    Database database = await _initDatabase();

    // Insert the Contact into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Contact is inserted twice.
    //
    // In this case, replace any previous data.
    await database.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateContact(Contact contact) async {

    Database database = await _initDatabase();

    await database.update(
      'contacts',
      contact.toMap(),
      // Ensure that the Contact has a matching id.
      where: 'id = ?',
      // Pass the Contact's id as a whereArg to prevent SQL injection.
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(Contact contact) async {

    Database database = await _initDatabase();

    // Remove the Contact from the database.
    await database.delete(
      'contacts',
      // Use a `where` clause to delete a specific Contact.
      where: 'id = ?',
      // Pass the Contact's id as a whereArg to prevent SQL injection.
      whereArgs: [contact.id],
    );
  }

  // A method that retrieves all the Contacts from the Contacts table.
  Future<List<Contact>> fetchContacts() async {
    // Get a reference to the database.
    Database database = await _initDatabase();

    // Query the table for all The Contacts.
    final List<Map<String, dynamic>> maps = await database.query('contacts');

    // Convert the List<Map<String, dynamic> into a List<Contact>.
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        fullName: maps[i]['fullName'],
        phoneNumber: maps[i]['phoneNumber'],
      );
    });
  }

  Future<Contact?> getContactById(int id) async {

    Database database = await _initDatabase();

    // Remove the Contact from the database.
    final List<Map<String, dynamic>> maps = await database.query(
      'contacts',

      limit: 1,
      // Use a `where` clause to delete a specific Contact.
      where: 'id = ?',
      // Pass the Contact's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return new Contact(id: maps[0]['id'], fullName: maps[0]['fullName'], phoneNumber: maps[0]['phoneNumber']);
    }
    return null;
  }

}