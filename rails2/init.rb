# require 'experimental/modules_in_render_hierarchy'

require 'extensions/active_record'
require 'extensions/model_reader'

require 'view_models'
require 'view_models/render_options'
require 'view_models/controller_extractor'
require 'view_models/path_store'
require 'view_models/base'
require 'view_models/view'

require 'helpers/view'
require File.join(File.dirname(__FILE__), '/../shared/init')

ActionController::Base.send :include, ViewModels::Helpers::Mapping
ActionView::Base.send       :include, ViewModels::Helpers::Mapping