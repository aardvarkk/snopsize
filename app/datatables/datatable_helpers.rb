module DatatableHelpers
  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column

    # These must match the column ordering in the list view shared partial!
    columns = %w[snops.title user domain snops.created_at category]

    # Sort by a given column by default -- in this case created_at
    return columns[params[:iSortCol_0].to_i] if params[:iSortCol_0]
    return columns[3]

  end

  def sort_direction
    # Sort descending by default
    return params[:sSortDir_0] if params[:sSortDir_0]
    return "desc"
  end

end