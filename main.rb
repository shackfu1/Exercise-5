# Exercise 5

class Participants
  def initialize(participants_email_string)
    return if participants_email_string.blank?
    participants_email_string.split.uniq.map do |email_address|
      User.create(email: email_address.downcase, password: Devise.friendly_token)
    end
  end
end

class LaunchDiscussionWorkflow

  def initialize(discussion, host, participants)
    @discussion = discussion
    @host = host
    @participants = participants
  end

  # Expects @participants array to be filled with User objects
  def run
    return unless valid?
    run_callbacks(:create) do
      ActiveRecord::Base.transaction do
        discussion.save!
        create_discussion_roles!
        @successful = true
      end
    end
  end
end


discussion = Discussion.new(title: "fake", ...)
host = User.find(42)
participants = Participants.new("fake1@example.com\nfake2@example.com\nfake3@example.com")

workflow = LaunchDiscussionWorkflow.new(discussion, host, participants)
workflow.run