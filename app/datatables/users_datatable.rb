class UsersDatatable < TemplateDatatable


private

  def sort_columns_collection
    columns = [
      "id", "nome", "email", "perfis.nome"
    ]
  end

  def prefix_path(object)
    "controle_de_usuarios"
  end

  def data
    objects.map do |user|
      [
        user.id,
        user.nome,
        user.email,
        user.perfil_nome,
        links(user)
      ]
    end
  end

  def fetch_objects
    users = User.left_joins(:perfil).order("#{sort_column} #{sort_direction}")

    if params[:search][:value].present?
      conditions = []

      conditions << "(CAST(users.id AS TEXT) = ?)"
      conditions << "(users.nome LIKE ?)"
      conditions << "(email LIKE ?)"
      conditions << "(perfis.nome LIKE ?)"


      values = []
      values <<  params[:search][:value]

      3.times do
        values << "%" + params[:search][:value] + "%"
      end

      conditions = ["(#{conditions.join(" or ")})"] + values
    end

    users.distinct.where(conditions).paginate(page: page, per_page: per_page).to_a
  end


end

