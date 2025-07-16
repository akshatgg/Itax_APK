import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/utils/logger.dart';

class AutoCompleteInput extends StatelessWidget {
  const AutoCompleteInput({
    super.key,
    this.validator,
    required this.items,
    this.type,
    required this.label,
    required this.initialValue,
    required this.onSelected,
    this.hint = 'Search...',
    this.direction = OptionsViewOpenDirection.down,
    this.showPrefix = true,
    this.fillColor,
    this.showAvatar = true,
    this.textInputAction,
  });

  final String? Function(String?)? validator;
  final List<String> items;
  final TextInputType? type;
  final String label;
  final String initialValue;
  final void Function(String) onSelected;
  final String hint;
  final OptionsViewOpenDirection direction;
  final bool showPrefix;
  final bool showAvatar;
  final Color? fillColor;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final outline = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(8),
    );
    final focusOutline = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(8),
    );

    return Autocomplete<String>(
      onSelected: onSelected,
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (value) {
            onFieldSubmitted();
            onSelected(value);
          },
          textInputAction: textInputAction,
          keyboardType: type ?? TextInputType.name,
          decoration: InputDecoration(
            prefixIcon: showPrefix
                ? const Icon(Icons.search, color: Colors.grey)
                : null,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
            border: outline,
            focusedBorder: focusOutline,
            enabledBorder: outline,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            filled: true,
            fillColor: fillColor ?? Colors.grey.shade200,
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) return const Iterable.empty();
        var where = items.where(
          (t) => t.toLowerCase().contains(textEditingValue.text.toLowerCase()),
        );
        logger.d('${textEditingValue.text} ${where.length}');
        return where;
      },
      initialValue: TextEditingValue(text: initialValue),
      optionsViewOpenDirection: direction,
      optionsMaxHeight: 50.h,
      optionsViewBuilder: (context, onSelected, options) {
        final AlignmentDirectional optionsAlignment =
            direction == OptionsViewOpenDirection.up
                ? AlignmentDirectional.bottomStart
                : AlignmentDirectional.topStart;
        return Align(
          alignment: optionsAlignment,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 50.h),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        final bool highlight =
                            AutocompleteHighlightedOption.of(context) == index;
                        if (highlight) {
                          SchedulerBinding.instance.addPostFrameCallback(
                            (Duration timeStamp) {
                              Scrollable.ensureVisible(context, alignment: 0.5);
                            },
                            debugLabel: 'AutocompleteOptions.ensureVisible',
                          );
                        }
                        return Container(
                          color: highlight ? Colors.grey.shade300 : null,
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      /*  optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: options.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final option = options.elementAt(index);
                return InkWell(
                  hoverColor: Colors.grey,
                  onTap: () => onSelected(option),
                  child: Builder(
                    builder: (context) {
                      final bool highlight =
                          AutocompleteHighlightedOption.of(context) == index;
                      return Container(
                        color: highlight ? Colors.grey.shade300 : null,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Text(
                                option[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Wrap(
                              children: [
                                Text(
                                  option,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      }, */
    );
  }
}
