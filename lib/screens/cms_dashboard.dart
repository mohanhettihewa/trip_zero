import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/cms_service.dart';
import '../widgets/add_destination_form.dart';

class CmsDashboard extends StatefulWidget {
  const CmsDashboard({super.key});

  @override
  State<CmsDashboard> createState() => _CmsDashboardState();
}

class _CmsDashboardState extends State<CmsDashboard> {
  final CmsService _cmsService = CmsService();

  void _showForm({Destination? destination}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AddDestinationForm(
            destination: destination,
            onSave: (newDestination) async {
              if (destination == null) {
                await _cmsService.addDestination(newDestination);
              } else {
                await _cmsService.updateDestination(newDestination);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMS Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showForm(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _cmsService,
        builder: (context, child) {
          return FutureBuilder<List<Destination>>(
            future: _cmsService.getDestinations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No destinations found.'));
              }

              final destinations = snapshot.data!;
              return ListView.builder(
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return ListTile(
                    leading: Image.network(
                      destination.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                    title: Text(destination.title),
                    subtitle: Text(
                      destination.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showForm(destination: destination),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Destination'),
                                content: const Text('Are you sure you want to delete this?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await _cmsService.deleteDestination(destination.id);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
