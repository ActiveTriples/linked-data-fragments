class RootConstraint

  def matches?(request)
    return (!request.params.has_key?('s') and !request.params.has_key?('q'))
  end
end