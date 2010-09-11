# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class OembedExtension < Radiant::Extension
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
