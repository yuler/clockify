module Taskable
  extend ActiveSupport::Concern

  TYPES = %w[ NumericalTask ProgressTask DurationTask ReductionTask CustomTask ].freeze

  included do
    has_one :task, as: :taskable, inverse_of: :taskable, touch: true
    has_one :user, through: :task

    delegate :name, to: :task
  end

  class_methods do
    def taskable_name
      @taskable_name ||= ActiveModel::Name.new(self).inquiry
    end
  end

  def taskable_name
    self.class.taskable_name
  end
end
