class QueryConstraint

  def matches?(request)
    request.params.has_key?('q')
  end
end