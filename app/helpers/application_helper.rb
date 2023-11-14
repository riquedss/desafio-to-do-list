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

  def mostra_erro(user)
    erros = format_array_erros(user)
    tam = erros.count

    part = erros.slice(0, tam - 1)
    part = part.join(', ')
    part += ' e ' unless part.blank?
    part + erros[tam - 1]
  end

  private

  def format_array_erros(user)
    erros = []

    user.errors.messages.each do |k, v|
      erros.push("#{I18n.t("activerecord.user.#{k}")} #{v[0]}")
    end

    erros
  end
end
