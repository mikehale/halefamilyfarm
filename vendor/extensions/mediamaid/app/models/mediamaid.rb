 # Radiant-mediamaid-extension
 # @copyright (c) 2010 Blazing CLoud (http://www.blazingcloud.net)
 # @license MIT License
 #
class Mediamaid < ActiveRecord::Base 
  require "paperclip"

  thumb_size  = Radiant::Config['mediamaid.thumb'] + ">"
  small_size  = Radiant::Config['mediamaid.small'] + ">"
  medium_size = Radiant::Config['mediamaid.medium'] + ">"
  large_size  = Radiant::Config['mediamaid.large'] + ">"

  default_options = {
    :styles => {
      :thumb => thumb_size,
      :small => small_size,
      :medium => medium_size,
      :large => large_size
     },
    :whiny => false,
    :default_url => "/:class/:attachment/missing_:style.png",
  }

  if (Radiant::Config['mediamaid.s3.enabled'] == "true")
    has_attached_file :mediamaid, default_options.merge(
    :storage => :s3,
    :s3_credentials => { 
      :access_key_id => Radiant::Config['mediamaid.s3.access_key_id'], 
      :secret_access_key => Radiant::Config['mediamaid.s3.secret_access_key']
    },
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => Radiant::Config['mediamaid.s3.bucket'])
  else
    has_attached_file :mediamaid, default_options
  end

  validates_presence_of :mediamaid_file_name
  validates_attachment_content_type :mediamaid, :content_type => [ 'image/jpeg', 'image/gif', 'image/png', 'audio/x-wav', 'application/x-wav', 'application/x-shockwave-flash', 'application/pdf' ]
  # validates_attachment_size :mediamaid, :less_than => 10.megabytes
end