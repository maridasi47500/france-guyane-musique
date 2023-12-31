require 'rubygems'
require "active_record"
require 'sqlite3'
#require 'pry'
ActiveRecord::Base.establish_connection(
adapter: 'sqlite3',
database: 'mydb1.db')
ActiveRecord::Schema.define do
  create_table :cats, if_not_exists: true do |t|
    t.string :name
    t.string :url
  end
  create_table :posts, if_not_exists: true do |t|
    t.integer :cat_id
    t.string :title
    t.string :url
    t.string :image
    t.text :content
  end
end
class Cat < ActiveRecord::Base
has_many :posts

end
class Post < ActiveRecord::Base
belongs_to :cat
def self.mypost
all.limit(1).offset(0)
end
def self.otherpost(mypage = nil)
myoffset=1
all.limit(8).offset(myoffset)
end
def title
read_attribute(:title)
end
def content
read_attribute(:content)
end

end
x=Cat.find_or_create_by(name: "Musique", url: "musique")
x.posts.create(title: "hi",content:"howare ou?")
x.posts.create(title: "hello",content:"wats ur name???")
