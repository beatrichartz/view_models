# Base Module for ViewModels.
#
module ViewModels
  
  # Gets raised when render_as, render_the, or render_template cannot
  # find the named template, not even in the hierarchy.
  #
  class MissingTemplateError < StandardError; end
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    # Create a view_model. To create a view_model, you need to have a model (to present) and a context.
    # The context is usually a view, a controller, or an app, but doesn't need to be.
    # 
    def initialize model, app_or_controller_or_view
      @model   = model
      @context = ContextExtractor.new(app_or_controller_or_view).extract
    end
    
    class << self
      
      # Delegates method calls to the context.
      #
      # Examples:
      #   context_method :current_user
      #   context_method :current_user, :current_profile  # multiple methods to be delegated
      #
      # In the view_model:
      #   self.current_user
      # will call
      #   context.current_user
      #
      def context_method *methods
        delegate *methods << { :to => :context }
      end
      
      # Installs the model_reader Method for filtered
      # model method delegation.
      #
      include Extensions::ModelReader
      
      protected
        
        # Returns the next view model class in the render hierarchy.
        #
        # Note: Just returns the superclass.
        #
        # TODO Think about raising the MissingTemplateError here.
        #
        def next_in_render_hierarchy
          superclass
        end
        
        # Just raises a fitting template error.
        #
        def raise_template_error_with message
          raise MissingTemplateError.new "No template #{message} found."
        end
        
        # Check if the view lookup inheritance chain has ended.
        #
        # Raises a MissingTemplateError if yes.
        #
        def inheritance_chain_ends?
           self == ViewModels::Base
        end
        
    end
    
    # Delegate context methods.
    #
    context_method :logger
    
    # Renders the given partial in the view_model's view root in the format given.
    #
    # Example:
    #   views/view_models/this/view_model/_partial.haml
    #   views/view_models/this/view_model/_partial.text.erb
    #
    # The following options are supported: 
    # * :format - Calling view_model.render_as('partial') will render the haml
    #   partial, calling view_model.render_as('partial', :format => :text) will render
    #   the text erb.
    # * All other options are passed on to the render call. I.e. if you want to specify locals you can call
    #   view_model.render_as(:partial, :locals => { :name => :value })
    # * If no format is given, it will render the default format, which is (currently) html.
    #
    def render_as name, options = {}
      render_internal RenderOptions::Partial.new(name, options)
    end
    # render_the is used for small parts.
    #
    # Example:
    # # If the view_model is called window, the following
    # # is more legible than window.render_as :menubar
    # * window.render_the :menubar
    #
    alias render_the render_as
    
    # Renders the given template in the view_model's view root in the format given.
    #
    # Example:
    #   views/view_models/this/view_model/template.haml
    #   views/view_models/this/view_model/template name.text.erb
    #
    # The following options are supported: 
    # * :format - Calling view_model.render_template('template') will render the haml
    #   template, calling view_model.render_template('template', :format => :text) will render
    #   the text erb template.
    # * All other options are passed on to the render call. I.e. if you want to specify locals you can call
    #   view_model.render_template(:template, :locals => { :name => :value })
    # * If no format is given, it will render the default format, which is (currently) html.
    #
    def render_template name, options = {}
      render_internal RenderOptions::Template.new(name, options)
    end
    
    protected
      
      # Model and Context (Controller) are accessible from a view model.
      #
      # If you really need to call
      #   view_model.model.bla
      # in a view, I urge you to reconsider. But feel free to make
      # the methods model, controller, context public.
      #
      attr_reader :model, :context
      
      # Internal render method that uses the options to get a view instance
      # and then referring to its class for rendering.
      #
      def render_internal options
        options.view_model = self
        
        determine_and_set_format options
        
        render options
      end
      
      # Determines what format to use for rendering.
      #
      # Note: Uses the template format of the view model instance
      #       if none is explicitly set in the options.
      #       This propagates the format to further render_xxx calls.
      #
      def determine_and_set_format options
        options.format = @template_format = options.format || @template_format
      end
  end
end