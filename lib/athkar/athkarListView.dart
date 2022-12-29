import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'athkar.dart';
import 'athkarListItem.dart';

class AthkarList extends StatefulWidget {
  List<Athkar> athkars;
  double fontSize;
  List<Athkar> removedItems;
  AthkarList(
      {required this.athkars,
      required this.fontSize,
      required this.removedItems});
  @override
  _AthkarListState createState() => _AthkarListState();
}

class _AthkarListState extends State<AthkarList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var _type = FeedbackType.light;
        Vibrate.feedback(_type);
        // Check if the list is not empty
        if (widget.athkars.isNotEmpty) {
          setState(() {
            if (widget.athkars[0].counter > 1) {
              widget.athkars[0].counter--;
            } else {
              widget.removedItems.add(widget.athkars[0]);

              widget.athkars.removeAt(0);
            }
          });
        }
      },
      child: RefreshIndicator(
        onRefresh: _undoRemove,
        child: ListView.builder(
          physics:
              const AlwaysScrollableScrollPhysics(), // Make the list scrollable
          itemCount: widget.athkars.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(widget.athkars[index].paragraph),
              onDismissed: (direction) {
                setState(() {
                  widget.removedItems.add(widget.athkars[index]);

                  widget.athkars.removeAt(index);
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AthkarListItem(
                    text1: widget.athkars[index].paragraph,
                    text2: "التكرار: ${widget.athkars[index].counter}",
                    fontSize: widget.fontSize,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _undoRemove() async {
    if (widget.removedItems.isNotEmpty) {
      setState(() {
        widget.athkars.insert(0, widget.removedItems.removeLast());
      });
    }
    return;
  }
}