module MenuHelper

  # Array para os menus com as permissões
  def menu_data
    return [] if !current_user || request.xhr?

    arr = []

    # Menus principais
    arr << menu_link(id: :cadastros, text: I18n.t("permissions.context.cadastros.name"), icon: 'fa fa-check-square-o')

    arr << menu_link(
      id: :index, text: I18n.t("activerecord.models.user.other"),
      icon: 'fa fa-users', link: users_path,
      controller: :users,
      permission: can?(:index, User), parent: :cadastros
    )

    # Permissões finais
    [:cadastros].each do |menu|
      arr.find { |x| x[:id] == menu }[:permission] = arr.select { |x| x[:parent] == menu }.map { |x| x[:permission] }.include?(true)
    end

    @menu_data = arr.select { |x| x[:permission] == true }
    @menu_data = @menu_data.sort_by { |k| k[:text].upcase }
    @menu_data
  end

  def menu_link(options={})
    {
      id: options[:id], text: options[:text], icon: options[:icon],
      link: options[:link], options_link: options[:options_link],
      permission: options[:permission], parent: options[:parent],
      controller: options[:controller]
    }
  end

  def controller_name_sym
    controller_name = params.to_h["controller"].to_sym
  end

  def menu_active(menu, submenus)
    menu_ativo = controller_name_sym == menu[:id]
    submenu_current_controller = submenus.select{|x| (x[:controller]||x[:parent])==controller_name_sym}.first
    submenu_ativo = submenu_current_controller && submenu_current_controller[:parent] == menu[:id]
    menu_ativo || submenu_ativo ? "active" : ""
  end

  def generate_menu(data)
    html = ""
    return html if !current_user || data.nil?
    main_menu = data.select { |x| x[:parent].nil? }
    submenus = data.select { |x| !x[:parent].nil? }
    main_menu.each do |menu|
      sub_menu_childs = submenus.select{|x| x[:parent]==menu[:id]}.count > 0 ? true : false
      html << content_tag(:li, class: "#{menu_active(menu, submenus)}") do
        icolink_to(menu_name(menu[:text]), menu[:link], menu[:icon].to_s, {childs: sub_menu_childs, nav_label: true}) +
        generate_submenu(submenus, menu[:id])
      end
    end
    html.html_safe
  end


  def submenu_active(submenu)
    controller = submenu[:controller] || submenu[:parent]
    (controller_name_sym == controller && params.to_h[:action].to_sym == submenu[:id]) || (params.permit(:tipo_relatorio).to_h[:tipo_relatorio].try(:to_sym) == submenu[:id]) ? "active" : ""
  end

  def generate_submenu(data, parent, counter = 0)

    submenu = data.select { |x| x[:parent] == parent }
    return "" if submenu.count == 0
    content_tag(:ul, class: "nav nav-second-level collapse", role: "menu", "aria-labelledby" => "dLabel") do
      html = ""
      submenu.each do |menu|
        if menu[:link]
          html << content_tag(:li, icolink_to(menu[:text], menu[:link], menu[:icon].to_s, menu[:options_link]), class: "#{submenu_active(menu)}")
        else
          html << content_tag(:li) do
            icomenu(menu[:text], menu[:icon].to_s) + generate_submenu(data, menu[:id], counter + 1)
          end
        end
      end
      html.html_safe
    end

  end


  def menu_name(name)
    " #{t('menu.' << name.to_s)}"
  end

  def icolink_to(text, path, icon="", options={nav_label: false})
    options ||= {}
    text = icon.blank? ? text :
      content_tag(:i, "", class: icon.to_s) +
      (options[:nav_label] ? "<span class='nav-label'> #{text} </span>".html_safe : text)
    text += content_tag(:span, "", class: "fa arrow") if options[:childs]
    link_to(text.html_safe, path, options)
  end

  def icomenu(text, icon="")
    return content_tag(:a, menu_name(text), "data-toggle" => "dropdown", href: "#") if icon.empty?
    content_tag(:a, "data-toggle" => "dropdown", href: "#") do
      (content_tag(:div, content_tag(:p, "", class: icon), class: "wrap-icon") + menu_name(text)).html_safe
    end
  end


end