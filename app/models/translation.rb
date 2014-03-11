class Translation < ActiveRecord::Base
  LANGUAGES = {'English' => :en,
               'български' => :bg,
               'Català' => :ca,
               'čeština' => :cs,
               'Deutsch' => :de,
               'Español' => :es,
               'ελληνικά' => :el,
               'Français' => :fr,
               'Indonesian' => :id,
               'magyar' => :hu,
               '日本語' => :ja,
                               'മലയാളം' => :ml,
               'Nederlands' => :nl,
               'Português (Brasil)' => :pt,
               'română' => :ro,
               'Tiếng Việt' => :vi,
               'Türkçe' => :tr}

  FRONTPAGE_SUPPORTED_LOCALES = [:en, :ca, :pt, :el, :cs, :fr, :es]

  EXPERIMENTAL_LANGUAGES = {'Chinese (Mandarin)' => :cmn,
                            'Italiano' => :it,
                                                                                                                 'తెలుగు' => :te,
                            'Gaelic (Irish)' => :ga,
                            'українська мова' => :uk}

  belongs_to :translatable, polymorphic: true
  
  serialize :fields, ActiveRecord::Coders::Hstore
  
  scope :to_language, ->(language) { where(language: language) }

  validates_presence_of :translatable, :language
  
  def as_json
    { id: translatable_id }.merge(fields)
  end
  
  def self.language(locale)
    LANGUAGES.key(locale.to_sym)
  end

  def self.locales
    LANGUAGES.values
  end

  def self.locale_strings
    LANGUAGES.values.map(&:to_s)
  end

  def self.frontpage_locales
    FRONTPAGE_SUPPORTED_LOCALES
  end

  def self.experimental_locales
    EXPERIMENTAL_LANGUAGES.values
  end

  def self.permitted_locale?(locale)
    return false if locale.blank?
    (LANGUAGES.values + EXPERIMENTAL_LANGUAGES.values).include? locale.to_sym
  end

  def self.language_link_attributes(language)
    { href: "?&locale=#{language[1]}"  ,
      title: "#{I18n.t(:change_language, language: language[0])}",
      text: "#{language[0]}" }
  end
  
end
