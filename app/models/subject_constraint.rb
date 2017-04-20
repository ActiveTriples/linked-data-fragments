class SubjectConstraint

  def matches?(request)
    request.params.has_key?('s')
  end
end