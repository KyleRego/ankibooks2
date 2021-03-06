class Article < ApplicationRecord
  ANKI_NOTE_REGEX = /\[\[(.*?)\]\]/

  belongs_to :book
  has_many :children, class_name: "Article", foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: "Article", foreign_key: 'parent_id', optional: true

  validates :name, presence: true
  validates :content, presence: true

  has_many_attached :images

  def subarticles
    subarticles = Article.where(parent_id: self.id)
  end

  def has_children?
    subarticles.count != 0
  end

  def to_s
    "==Article #{self.id}: name: #{self.name}; content: #{self.content}; is_locked: #{self.is_locked}=="
  end

  # returns a list of the raw content of the Anki notes of the article
  # for example if the article has [[This is an {{c1::Anki note}}.]]
  # then the return value would be ['This is an {{c1::Anki note}}.']
  def raw_anki_notes
    matches = self.content.scan(ANKI_NOTE_REGEX)
    raw_notes = matches.map { |match| match[0] }
  end

  # returns parent article or nil
  def parent
    Article.find_by(id: self.parent_id)
  end

  # returns the corresponding anki deck title string to the article
  # in anki, a parent deck "deck" with child deck "child" would be
  # string "deck::child" and this method makes deck titles like these
  def anki_deck_title
    title = self.name
    current_article = self
    while current_article.parent
      title = current_article.parent.name + '::' + title
      current_article = current_article.parent
    end
    'AnkiBooks::' + title
  end

  def to_json_data
    my_hash = { title: anki_deck_title, notes: raw_anki_notes , images: [] }

    temp_folder = ActiveStorage::SendZipHelper.save_files_on_server(self.images)
    my_hash[:images_temp_folder_path] = temp_folder

    Dir.foreach(temp_folder) do |filename|
      next if filename == '.' || filename == '..'
      my_hash[:images] << filename.to_s
    end

    my_hash.to_json
  end
end
