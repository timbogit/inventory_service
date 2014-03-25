# Lookup presenters given an API version and an Entity class.
class PresenterFinder

  # The Presenter class that was loaded.
  attr_reader :presenter_class

  # Look up a presenter class given API version and an Entity class.
  def initialize(requested_version, presentable, qualifier='')
    class_name = "Presenters::V#{requested_version}::#{qualifier.to_s.camelize}#{presentable.try(:name)}Presenter"
    @presenter_class = class_name.safe_constantize
  end
end
