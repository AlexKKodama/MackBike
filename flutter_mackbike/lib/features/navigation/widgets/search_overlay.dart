import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final _originSubject = BehaviorSubject<String>();
  final _destinationSubject = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    _originSubject.debounceTime(const Duration(milliseconds: 500)).listen((
      query,
    ) {
      if (!mounted) return;
      if (query.isNotEmpty) {
        Provider.of<NavigationViewModel>(
          context,
          listen: false,
        ).searchLocation(query, isOrigin: true);
      } else {
        Provider.of<NavigationViewModel>(
          context,
          listen: false,
        ).clearSearchResults(isOrigin: true);
      }
    });

    _destinationSubject.debounceTime(const Duration(milliseconds: 500)).listen((
      query,
    ) {
      if (!mounted) return;
      if (query.isNotEmpty) {
        Provider.of<NavigationViewModel>(
          context,
          listen: false,
        ).searchLocation(query, isOrigin: false);
      } else {
        Provider.of<NavigationViewModel>(
          context,
          listen: false,
        ).clearSearchResults(isOrigin: false);
      }
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _originSubject.close();
    _destinationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NavigationViewModel>(context);

    return Positioned(
      top: 16.0,
      left: 16.0,
      right: 16.0,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _originController,
                decoration: InputDecoration(
                  labelText: 'Origem',
                  prefixIcon: const Icon(Icons.my_location),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _originSubject.add,
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Destino',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _destinationSubject.add,
              ),
              if (viewModel.originSearchResults.isNotEmpty ||
                  viewModel.destinationSearchResults.isNotEmpty)
                Column(
                  children: [
                    const Divider(),
                    if (viewModel.originSearchResults.isNotEmpty)
                      ...viewModel.originSearchResults.map(
                        (result) => ListTile(
                          title: Text(result.displayName),
                          onTap: () {
                            _originController.text = result.displayName;
                            viewModel.setOrigin(result.latLng);
                            viewModel.clearSearchResults(isOrigin: true);
                          },
                        ),
                      ),
                    if (viewModel.destinationSearchResults.isNotEmpty)
                      ...viewModel.destinationSearchResults.map(
                        (result) => ListTile(
                          title: Text(result.displayName),
                          onTap: () {
                            _destinationController.text = result.displayName;
                            viewModel.setDestination(result.latLng);
                            viewModel.clearSearchResults(isOrigin: false);
                          },
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
