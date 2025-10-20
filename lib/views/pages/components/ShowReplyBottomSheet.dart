import 'package:flutter/material.dart';
import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Reply.dart';
import 'package:fv2/providers/ReplyProvider.dart';
import 'package:provider/provider.dart';

Future<String?> ShowReplyBottomSheet(
  {
    required BuildContext context,
    bool isEdit = false,
    Function? editContent,
    int? id,
    String? content
}
) {
  final TextEditingController _replyController = TextEditingController(text: content ?? '');
  // final replyProvider = Provider.of<ReplyProvider>(context, listen: false);
  ValueNotifier<bool> isChanged = ValueNotifier(false);
  return showModalBottomSheet<String>(
    
    context: context,
    isScrollControlled: true, // so keyboard pushes up
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value)=>{
                if(isEdit){
                isChanged.value = value.trim().isNotEmpty && value.trim() != (content ?? '')
                }
              },
              controller: _replyController,

              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Write a reply...",
                border: OutlineInputBorder(),
                
              ),
              maxLines: null,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Cancel"),
                ),
                ValueListenableBuilder(
                  valueListenable: isChanged,
                  builder: (context, value, child) {
                    if (!value && isEdit) {
                      return ElevatedButton(
                        onPressed: null,
                        child: const Text("Send"),
                      );
                    }
                    
                    return ElevatedButton(
                    onPressed: () async{
                      if (_replyController.text.trim().isNotEmpty){
                        String message = _replyController.text.trim();
                        if(isEdit){
                        
                          String? result = await editContent!(replyId:id,content:message,context:context);
                          Navigator.pop(context, result);
                          return;
                        }
                      
                        Navigator.pop(context, message);
                      }
                    },
                    child: const Text("Send"),
                  );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
