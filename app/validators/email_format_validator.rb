# Email Format Regex Validator
class EmailFormatValidator < ActiveModel::EachValidator
  REGEX = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,8}$/i

  def validate_each(record, attribute, value)
    return if value.blank? || value =~ REGEX

    record.errors.add(attribute, options[:message] || I18n.t("activerecord.errors.email.format"))
  end
end
