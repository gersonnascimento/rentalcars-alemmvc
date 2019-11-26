class RentalPresenter < SimpleDelegator
  delegate :content_tag, to: :helper

  def status_badge
    content_tag :span, class: "badge badge-#{status}" do
      I18n.t(status)
    end
  end

  private

  def helper
    @helper ||= ApplicationController.helpers
  end
end
