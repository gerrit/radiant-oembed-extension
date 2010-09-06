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
    tag.locals.oembed_url, tag.locals.oembed_opts = tag.attr.delete('url'), tag.attr
    tag.locals.debug = 'here'
    if tag.double?
      tag.expand
    else
      oembed(tag).html
    end
  end
  
=begin
  # Not documented as its a somewhat advanced usage
  # also not sure about the design of this yet.
  
  desc %{
    Set the URL of the embedded object.
    
    Can be used as an alternative to the +url+ attribute on +r:oembed+.
    It should be the first child element of r:oembed in that case.
  
    *Usage:*
    
    <pre><code>
      <r:oembed>
        <r:source><r:content part="flickr_url" /></r:source>
        <r:html />
      </r:oembed>
    </pre></code>
  }
=end
  tag 'oembed:source' do |tag|
    tag.locals.object.oembed_url = tag.expand.strip
    ''
  end
  
  desc %{
    Renders a thumbnail image for the parent r:oembed tag
  }
  tag 'oembed:thumbnail' do |tag|
    url, width = oembed(tag).thumbnail_url, oembed(tag).thumbnail_width
    %{<img src="#{url}" width="#{width}">}
  end
  
  desc %{
    Renders the default representation for the parent embedded object sent by the provider
  }
  tag 'oembed:html' do |tag|
    oembed(tag).html
  end
  
  %w[title description html
    url width height
    thumbnail_url thumbnail_width thumbnail_height
    author_name author_url
    provider_name provider_url].each do |attr|
    desc %{
      Renders the #{attr.humanize} sent by the provider of the embedded object
      
      Not all attributes will be present for all providers.
      (see +r:if_#{attr}+ and +r:unless_#{attr}+)
    }
    tag "oembed:#{attr}" do |tag|
      oembed(tag).send(attr)
    end
    
    desc %{
      Renders its contents only if the #{attr.humanize} attribute is present for this oembed object
    }
    tag "oembed:if_#{attr}" do |tag|
      tag.expand if oembed(tag).send(attr)
    end

    desc %{
      Renders its contents only if the #{attr.humanize} attribute is not present for this oembed object
    }
    tag "oembed:unless_#{attr}" do |tag|
      tag.expand unless oembed(tag).send(attr)
    end
  end

private
  def oembed(tag)
    url, opts = tag.locals.oembed_url, tag.locals.oembed_opts
    raise TagError, 'please specify a url attribute on the r:oembed tag' unless url
    tag.locals.oembed ||= OEmbed::Providers::Embedly.get(url, opts)
  end
end
