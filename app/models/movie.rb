class Movie < ApplicationRecord
  has_many :bookmarks
  has_many :lists, through: :bookmarks
  validates :title, uniqueness: true
  validates :title, presence: true
  validates :overview, presence: true
  validates :overview, uniqueness: true
end
