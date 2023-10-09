class EditProfileEvent {
}

class EditProfileEventSave extends EditProfileEvent {
  final Map<String, dynamic> data;
  EditProfileEventSave(this.data);
}