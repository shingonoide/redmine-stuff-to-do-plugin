class StuffToDoFilter
  attr_accessor :users
  attr_accessor :priorities
  attr_accessor :statuses
  
  def initialize
    self.users = User.active
    self.priorities = get_priorites
    self.statuses = IssueStatus.find(:all)
  end
  
  def each
    if StuffToDo.using_issues_as_items?
      {
        :users => self.users.sort,
        :priorities => self.priorities.sort,
        :statuses => self.statuses.sort
      }.each do |group, items|
        yield group, items
      end
    end

    # Finally projects
    yield :projects if StuffToDo.using_projects_as_items?
  end

  private
  # Wrapper around Redmine's API since Enumerations changed in r2472
  def get_priorites
    if defined? ::IssuePriority
      return ::IssuePriority.all
    elsif Enumeration.respond_to?(:priorities)
      return Enumeration.priorities
    else
      return Enumeration::get_values('IPRI')
    end
  end
end
