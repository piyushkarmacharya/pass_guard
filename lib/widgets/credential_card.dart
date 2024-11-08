import 'package:flutter/material.dart';
import 'package:pass_guard/database/credentials_table.dart';
import 'package:pass_guard/models/credential.dart';

class CredentialCard extends StatefulWidget {
  final Credential cred;
  final CredentialsTable credentialsTable;
  final Function onDelete;
  const CredentialCard(
      {super.key,
      required this.cred,
      required this.credentialsTable,
      required this.onDelete});

  @override
  State<CredentialCard> createState() => _CredentialCardState();
}

class _CredentialCardState extends State<CredentialCard> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final credential = widget.cred;
    final credentialsTable = widget.credentialsTable;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.grey,
        elevation: 10,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        credential.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email : ${credential.email}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Password : ${credential.password}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 0.11 * screenSize.width,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.grey,
                              title: Text(
                                  "Delete credentials for ${credential.title}?",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      height: 28 / 18)),
                              contentPadding: EdgeInsets.zero,
                              buttonPadding: EdgeInsets.zero,
                              actionsPadding: const EdgeInsets.all(8),
                              titlePadding:
                                  const EdgeInsets.fromLTRB(24, 20, 20, 0),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      credentialsTable.delete(credential.id);
                                      widget.onDelete();
                                    },
                                    child: Text(
                                      "Yes",
                                      style:
                                          TextStyle(color: Colors.red.shade900),
                                    )),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade900,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
