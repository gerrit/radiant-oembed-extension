# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class OembedExtension < Radiant::Extension
  cattr_writer :cache_timeout
  def self.cache_timeout
    @@cache_timeout ||= SiteController.cache_timeout + 1.hour
  end
  
  version "0.1"
  description "Easy embedding of arbitrary content (youtube, vimeo, flickr, …) using the oEmbed protocol and the embed.ly API"
  url "http://github.com/gerrit/radiant-oembed-extension"
  
  extension_config do |config|
    config.gem 'ruby-oembed', :version => '>=0.7.0', :lib => 'oembed'
    Page.send :include, OembedTags
  end
  
  def activate
  end
end
