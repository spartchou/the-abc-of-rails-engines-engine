module Blorgh
  class Article < ActiveRecord::Base
    has_many :comments
    belongs_to :author, class_name: "User"

    before_validation :set_author

    private

    def set_author
      self.author = User.find_or_create_by(name: author_name)
    end
  end
end
