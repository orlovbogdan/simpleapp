module ApplicationHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end


  def nested_page_path(page)
    '/' + (page.ancestors + [page]).map(&:to_param).join('/')
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join('-') do
        Pygments.highlight(code, lexer: language)
      end
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def simple_error_messages_for(object_name)
    object = instance_variable_get("@#{object_name}")
    return if object.errors.empty?

    markaby do
      div.error_messages! do
        h2 "#{pluralize(object.errors.count, 'error')} occurred"
        p "There were problems with the following fields:"
        ul do
          object.errors.each_full do |msg|
            li msg
          end
        end
      end
    end
  end

  def markaby(&block)
    Markaby::Builder.new({}, self, &block)
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, page: nil), {:class => css_class}
  end

end
