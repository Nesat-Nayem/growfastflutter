import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grow_first/app/di/app_injections.dart';
import 'package:grow_first/core/utils/extensions/context_extensions.dart';
import 'package:grow_first/core/utils/sizing.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_cubit.dart';
import 'package:grow_first/features/auth/presentation/bloc/country/country_state.dart';

class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({super.key});

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  String _query = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select Country",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            verticalMargin16,
            Expanded(
              child: BlocBuilder<CountryCubit, CountryState>(
                bloc: sl<CountryCubit>(),
                builder: (context, state) {
                  if (state is CountryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CountryError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is CountryLoaded) {
                    final filtered = state.countries.where((c) {
                      final name = c.name.toLowerCase();
                      final code = c.code.toLowerCase();
                      final q = _query.toLowerCase();

                      return name.contains(q) || code.contains(q);
                    }).toList();

                    return Column(
                      children: [
                        SearchBar(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.grey.shade200,
                          ),
                          shadowColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _query = value;
                            });
                          },
                          textStyle: WidgetStatePropertyAll(
                            context.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          hintText: "Search country...",
                          leading: const Icon(Icons.search),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                        verticalMargin24,
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                Divider(color: Colors.grey.shade300),
                            itemBuilder: (context, index) {
                              final c = filtered[index];

                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Text(
                                    c.flag,
                                    style: context.bodyMedium,
                                  ),
                                ),
                                title: Text(c.name, style: context.labelLarge),
                                trailing: Text(
                                  "+${c.dialCode}",
                                  style: context.labelLarge,
                                ),
                                onTap: () => Navigator.pop(context, c),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
