require 'happymapper'
require 'yaml'
#

class Header
  include HappyMapper
  has_one :Action, String
  has_one :ServiceType, String
  has_one :ContentID, String
  has_one :SendDate, String
  has_one :SendTime, String

  def to_hash
    h = {}
    h[:action] = self.Action if self.Action
    h[:service_type] = self.ServiceType if self.ServiceType
    h[:content_id] = self.ContentID if self.ContentID
    h[:date] = self.SendDate if self.SendDate
    h[:time] = self.SendTime if self.SendTime
    h
  end
end
#
class Metadata
  include HappyMapper
  tag 'Metadata'
  has_one :Urgency, String
  has_one :Category, String
  has_one :Region, String
  has_many :Class, String, tag: 'Class'
  has_one :Credit, String
  has_one :Source, String

  def to_hash
    h = {}
    h[:urgency] = self.Urgency if self.Urgency
    h[:category] = self.Category if self.Category
    h[:region] = self.Region if self.Region
    h[:class_code] = self.Class if self.Class
    h[:credit] = self.Credit if self.Credit
    h[:source] = self.Source if self.Source
    h
  end
end

class NewsContent
  include HappyMapper
  tag 'NewsContent'
  has_one :Title, String
  has_one :Subtitle, String
  has_one :Body, String
  has_one :MultiMedia, String

  def to_hash
    h = {}
    h[:title]     = self.Title if self.Title
    h[:subtitle]  = self.Subtitle if self.Subtitle
    h[:body]      = self.Body if self.Body
    h[:picture]   = self.MultiMedia if self.MultiMedia
    h
  end
end

class YNewsML
  include HappyMapper
  tag 'YNewsML'
  has_one :Header, Header
  has_one :Metadata, Metadata
  has_one :NewsContent, NewsContent
  # has_one :link, String, xpath: 'Header'

  def to_hash
    h = self.Header.to_hash
    h.merge! self.Metadata.to_hash
    h.merge! self.NewsContent.to_hash
    h
  end
end

source = "#{Rails.root}/public/wire_source/101_KOR/20181010"
puts "parsing 101_KOR/20181010..."
Dir.glob("#{source}/*.xml").each do |f|
  xml = File.open(f, 'r'){|f| f.read}
  h = YNewsML.parse(xml).to_hash
#   puts "f:#{f}"
  YhArticle.create!(h)
end


source = "#{Rails.root}/public/wire_source/201_PHOTO_YNA/20181010"
puts "parsing 201_PHOTO_YNA/20181010..."
Dir.glob("#{source}/*.xml").each do |f|
  xml = File.open(f, 'r'){|f| f.read}
  h = YNewsML.parse(xml).to_hash
#   puts "f:#{f}"
  YhPicture.create!(h)
end

require 'csv'


User.create!(name: "김민수", email: "mskimsid@gmail.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
User.create!(name: "김형규", email: "hgkim@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
User.create!(name: "양유미", email: "biny@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 3)
User.create!(name: "안상현", email: "shahn@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "한승효", email: "shhan@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "반수희", email: "shban@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
# User.create!(name: "이지혜", email: "jhlee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "지선미", email: "smjee@naeil.com", password: 'itis1234', password_confirmation: "itis1234", role: 2)
User.create!(name: "이동명", email: "leedongmyeong@gmail.com", password: 'itis1234', password_confirmation: "itis1234",)

reporter_csv_path = "#{Rails.root}/public/reporter/reporters.csv"
csv_text = File.read(reporter_csv_path)
csv = CSV.parse(csv_text, :headers => true)
current_section = ''
csv.each do |row|
  h = row.to_hash
  h = Hash[h.map{ |key, value| [key.to_sym, value] }]
  section = h.delete(:section)
  if section && section != current_section
    current_section = section
  end
  h[:group]  = current_section
  h[:role]                  = 0
  h[:password]              = "itis" + h[:cell].split("-").last
  h[:password_confirmation] = h[:password]
  User.create!(h) unless User.where(email: h[:email]).first
end

