import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loading.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectAudio() {}

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  void selectaudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewmodelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref.read(homeViewmodelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text,
                      artist: artistController.text,
                      selectedColor: selectedColor,
                    );
              } else {
                showSnackBar(context, 'Missing Fields!');
              }
            },
            icon: Icon(Icons.check),
          )
        ],
        title: const Text('Upload Song'),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                radius: Radius.circular(10),
                                borderType: BorderType.RRect,
                                dashPattern: [10, 4],
                                color: Pallete.borderColor,
                                strokeCap: StrokeCap.round,
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Select the thumbnail for your song',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedAudio != null
                          ? AudioWave(path: selectedAudio!.path)
                          : CustomField(
                              hinttext: 'Pick Song',
                              controller: null,
                              isreadOnly: true,
                              onTap: () {
                                selectaudio();
                              },
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                          hinttext: 'Artist', controller: artistController),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                          hinttext: 'Song Name',
                          controller: songNameController),
                      const SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                        pickersEnabled: {
                          ColorPickerType.wheel: true,
                        },
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
