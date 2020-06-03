class FormNavigation
  FLOW = [
    EligibleController,
    MealEligibilityController,
    SorryController,
    ChildrenController,
    AddStudentController,
    MailingAddressController,
    JustSoYouKnowController,
    ParentController,
    ContactController,
    SignatureController,
    SuccessController
  ].freeze

  class << self
    delegate :first, to: :controllers

    def controllers
      FLOW
    end
  end

  delegate :controllers, to: :class

  def initialize(controller)
    @controller = controller
  end

  def next
    return unless index

    controller_until_end = controllers[index + 1..]
    seek(controller_until_end)
  end

  def skip_to_next
    return unless index

    controller_until_end = controllers[index + 2..]
    seek(controller_until_end)
  end

  private

  def index
    controllers.index(@controller.class)
  end

  def seek(list)
    list.detect do |form_controller_class|
      form_controller_class.show?(@controller.current_household)
    end
  end
end
