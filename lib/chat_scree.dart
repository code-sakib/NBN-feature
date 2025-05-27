import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    ValueNotifier<List> msgList = ValueNotifier([]);
    int i = 0; // Counter to track the number of messages sent

    ScrollController scrollController = ScrollController();
    void scrollDown() {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    }

    addMessage(String text) {
      List otherMsgList = [
        'Same here. Actually, I also needed a friend to share this journey with.',
        "Don't worry, it just the feeling that'll pass soon,",
        "I was clean for 5 days and then messed up last night. Let’s make today count for both of us.",
        "SAME! I literally had to throw my phone across the bed 😭",
        "Remember who you were before this started? That version of you is still in there. Let’s bring him back.",
        "Legend! I did that two weeks ago, felt so freeing. Next level: remove triggers from socials.",
        "Yeah man. Even when we fall, we’re not the same as before. We're fighting now. That’s what counts.",
      ];
      if (text.isEmpty) return;
      //send message
      msgList.value = [...msgList.value, text]; // Triggers rebuild
      messageController.clear();

      Future.delayed(const Duration(seconds: 3), () {
        // Simulate other user response
        msgList.value = [
          ...msgList.value,
          otherMsgList[i],
        ];
        i++;
        scrollDown();
      });
    }

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            )),
        titleSpacing: -1,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOApFCSVByzhZorHUAP-J851JAYyOPtI1jdg&s'),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Harry'),
                Text(
                  'online',
                  style: TextStyle(fontSize: 10, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Widget rulePoint(String title, String description) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• $title",
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(description,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  );
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: SingleChildScrollView(
                        child: Card(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '📜 Community Guidelines & Safety Rules',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                rulePoint("Privacy First",
                                    "No identities will be shared unless both users have explicitly agreed, and only after a regulated time period has passed."),
                                rulePoint("Data Security",
                                    "All your data is securely encrypted and stored safely in the database. Your privacy and safety are our top priorities."),
                                rulePoint("Strict Moderation",
                                    "Any form of misbehavior will lead to account suspension or a permanent ban, under predefined community guidelines. The app reserves the right to take such action without prior notice or explanation."),
                                rulePoint("Regulatory Compliance",
                                    "All operations and interactions are aligned with prevailing IT and cyber safety guidelines."),
                                rulePoint("Respectful Environment",
                                    "Mutual respect is mandatory. This platform is for growth, not judgment. Any form of harassment, shaming, or triggering content is strictly prohibited."),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Got it"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.gpp_maybe_outlined,
                size: 25,
              ))
        ],
        foregroundColor: Colors.grey,
        elevation: 10,
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder(
            valueListenable: msgList,
            builder: (context, value, child) {
              final List when = [
                '12-5-25',
                '16-5-25',
                '20-5-25',
                '23-5-25',
                '26-5-25',
                '30-5-25',
                '2-6-25',
                '4-6-25'
              ];
              int j = 0; // Counter for when messages are shown
              return Flexible(
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: msgList.value.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: index % 2 != 0
                                      ? Alignment.bottomLeft
                                      : Alignment.bottomRight,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(20),
                                          topRight: const Radius.circular(20),
                                          bottomRight: index % 2 == 0
                                              ? const Radius.circular(0)
                                              : const Radius.circular(20),
                                          bottomLeft: index % 2 != 0
                                              ? const Radius.circular(0)
                                              : const Radius.circular(20)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          msgList.value[index],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          DateTime.now()
                                              .toString()
                                              .substring(11, 16),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (index == 2 || index == 5 || index == 6)
                                      ? Builder(builder: (context) {
                                          j++;
                                          return Text(when[j],
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10));
                                        })
                                      : const SizedBox.shrink(),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: messageController,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {},
                      onEditingComplete: () {},
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () => addMessage(messageController.text.trim()),
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
