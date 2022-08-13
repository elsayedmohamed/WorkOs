
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workos/constants.dart';

import '../widgets/drawer_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController categoryController =
      TextEditingController(text: 'Task category');
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deadLineDateController =
      TextEditingController(text: 'Pick up a date');
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void formLoginSubmit() {
    var isValid = _formKey.currentState!.validate();
    if (isValid) {
      print(' form   Valid ');
    } else {
      print(' form  not Valid ');
    }
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate!=null) {
  setState(() {
    deadLineDateController.text =
        '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
  });
}
  }

  @override
  void dispose() {
    categoryController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    deadLineDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: AppConstants.kDarkBlue,
        ),
        primary: true,
        //foregroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'All fields are required',
                    style: TextStyle(
                      fontSize: 25,
                      color: AppConstants.kDarkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 5,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(text: 'Task category*'),
                      TextFormFieldAddTask(
                        valueKey: 'TaskCategory',
                        controller: categoryController,
                        enabled: false,
                        onTap: () {
                          showCategoriesDialog(context);
                          setState(() {});
                        },
                        maxLines: 1,
                        maxLength: 100,
                      ),
                      const TextWidget(text: 'Task title*'),
                      TextFormFieldAddTask(
                        valueKey: 'TaskTitle',
                        controller: titleController,
                        enabled: true,
                        onTap: () {},
                        maxLines: 1,
                        maxLength: 100,
                      ),
                      const TextWidget(text: 'Task description*'),
                      TextFormFieldAddTask(
                        valueKey: 'TaskDescription',
                        controller: descriptionController,
                        enabled: true,
                        onTap: () {},
                        maxLines: 3,
                        maxLength: 1000,
                      ),
                      const TextWidget(text: 'Task deadline date*'),
                      TextFormFieldAddTask(
                        valueKey: 'DeadlineDate',
                        controller: deadLineDateController,
                        enabled: false,
                        onTap: () {
                          _showDatePicker();
                        },
                        maxLines: 1,
                        maxLength: 1000,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    child: MaterialButton(
                      height: 55,
                      color: Colors.pink.shade600,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: BorderSide.none,
                      ),
                      onPressed: () {
                        formLoginSubmit();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.upload_file_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCategoriesDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Task category',
              style: TextStyle(color: Colors.pink.shade800),
            ),
            content: Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AppConstants.category.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        categoryController.text = AppConstants.category[index];
                        Navigator.pop(context);
                      });
                      print(AppConstants.category[index]);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.red[200],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(AppConstants.category[index]),
                      ],
                    ),
                  );
                }),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel filter'),
              ),
            ],
          );
        });
  }
}

class TextFormFieldAddTask extends StatelessWidget {
  const TextFormFieldAddTask({
    Key? key,
    required this.valueKey,
    required this.enabled,
    required this.controller,
    required this.maxLength,
    required this.maxLines,
    this.onTap,
  }) : super(key: key);

  final String valueKey;
  final bool enabled;
  final TextEditingController controller;
  final int maxLength;
  final int maxLines;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        validator: ((value) {
          if (value!.isEmpty) {
            return 'Field is missing';
          }
          return null;
        }),
        controller: controller,
        enabled: enabled,
        key: ValueKey(valueKey),
        style: TextStyle(
          color: AppConstants.kDarkBlue,
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.pink.shade800,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class TextWidget extends StatelessWidget {
  final String text;
  const TextWidget({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.pink.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
