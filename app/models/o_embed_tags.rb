require 'oembed'

module OEmbedTags
  include Radiant::Taggable
  
  class TagError < StandardError;end
  
  desc %{
    Embed 
    
    If used as a single tag, it will simply 
    
    *Usage:*
    
    <pre><code><r:oembed url="http://www.flickr.com/photos/notsogoodphotography/503637906/" /></code></pre>
  }
  tag 'oembed' do |tag|
    raise TagError if tag.attr['url'].blank?
    provider = OEmbed::Providers::Embedly
    tag.locals.oembed = provider.get(tag.attr.delete('url'), tag.attr)
    if tag.double?
      tag.expand
    else
      tag.locals.oembed.html
    end
  end
  
  desc %{
    Renders a thumbnail image for the parent r:oembed tag
  }
  tag 'oembed:thumbnail' do |tag|
    url, width = tag.locals.oembed.thumbnail_url, tag.locals.oembed.thumbnail_width
    %{<img src="#{url}" width="#{width}">}
  end
  
  desc %{
    Renders the default representation for the parent embedded object sent by the provider
  }
  tag 'oembed:html' do |tag|
    tag.locals.oembed.html
  end
  
  %w[title description url html
    thumbnail_url thumbnail_width
    author_name author_url
    provider_name provider_url].each do |attr|
    desc %{
      Renders the #{attr.humanize} sent by the Provider
    }
    tag "oembed:#{attr}" do |tag|
      tag.locals.oembed.send(attr)
    end
  end
end
