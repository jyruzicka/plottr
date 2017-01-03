# This indicates that the given object can render,
# by responding to the `render` method.
module Plottr::Renderable

  def before_render(); end
  def render(); end
  def after_render(); end
end