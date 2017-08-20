module PathsControllerHelper
  def include_traceable_type(traceables)
    traceables.map { |traceable| insert_traceable_type(traceable) }
  end

  def insert_traceable_type(traceable)
    { traceable_type: traceable.class.to_s, traceable: traceable }
  end
end
