module ApplicationHelper
  def text_field_with_label(form, attribute, label_text)
    form.label(label_text) + form.text_field(attribute)
  end

  def password_field_with_label(form, attribute, label_text)
    form.label(label_text) + form.password_field(attribute)
  end

  def date_field_with_label(form, attribute, label_text)
    form.label(label_text) + form.date_field(attribute)
  end
end
