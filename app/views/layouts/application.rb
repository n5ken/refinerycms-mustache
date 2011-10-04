class Layouts::Application < Mustache::Rails

  # html_tag

  # head start
  def meta_description
    "<meta name=\"description\" content=\"#{@meta.meta_description}\" />" if @meta.meta_description.present?
  end

  def meta_keywords
    "<meta name=\"keywords\" content=\"#{@meta.meta_keywords}\">" if @meta.meta_keywords.present?
  end

  # here will have a stack to deep error
  #def csrf_meta_tag
  #  csrf_meta_tag if RefinerySetting.find_or_set(:authenticity_token_on_frontend, true)
  #end

  def stylesheets_for_headx
    stylesheet_tags = ""

    stylesheets_for_head(stylesheets||=%w(application formatting theme), theme ||= nil).each do |ss|
      stylesheet_tags += (stylesheet_link_tag ss) + "\n"
    end

    return stylesheet_tags
  end

  def stylesheet_links
    stylesheet_link_tag "home", :theme => @theme if home_page?
  end

  def javascript_modernizr
    javascript_include_tag 'modernizr-min' 
  end
  # head end

  # header start
  def link_to_root
    link_to RefinerySetting.find_or_set(:site_name, "Company Name"), root_path
  end

  def menus
    if (@roots = (collection ||= @menu_pages).roots).present?
      @dom_id ||= 'menu'
      @css = [(@css || 'menu'), 'clearfix'].flatten.join(' ')
      @hide_children = RefinerySetting.find_or_set(:menu_hide_children, false) if @hide_children.nil?
      @apply_css = true
      @sibling_count = @roots.length - 1

      new_roots = []

      # if the menu hide children setting is false, then hide all sub menus of root menu
      @roots.each do |item|
        new_roots << item.merge({ :pure_url => url_for(item.url), 
                                  :children => (@hide_children ? [] : sub_menus(item)),
                                  :selected => selected_page_or_descendant_page_selected?(item) ? "selected" : "" })
      end

      return new_roots
    else
      return false
    end
  end
  # header end

  # footer start
  def copyright
    I18n.t('shared.footer.copyright', :year => Time.now.year,
                         :site_name => RefinerySetting.find_or_set(:site_name, "Company Name"))
  end
  # footer end

private

  def sub_menus item
    if item.children.empty?
      return []
    else
      children = item.children.map do |child|
        child.merge({ :pure_url => url_for(child.url), 
                      :children => sub_menus(child),
                      :selected => selected_page_or_descendant_page_selected?(child) ? "selected" : "" })
      end

      return children
    end
  end
end




















