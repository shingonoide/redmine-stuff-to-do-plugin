# Redmine Shams
Sham.mail { Faker::Internet.email }
Sham.name { Faker::Name.name }
Sham.firstname { Faker::Name.first_name }
Sham.lastname { Faker::Name.last_name }
Sham.login { Faker::Internet.user_name }
Sham.project_name { Faker::Company.name[0..29] }
Sham.identifier { Faker::Internet.domain_word.downcase }
Sham.message { Faker::Company.bs }
Sham.position {|index| index }
Sham.single_name { Faker::Internet.domain_word.capitalize }

Sham.permissions(:unique => false) {
  [
  ]
}

# Redmine specific blueprints
User.blueprint do
  mail
  firstname
  lastname
  login
end

Project.blueprint do
  name { Sham.project_name }
  identifier
  enabled_modules
end

def make_project_with_enabled_modules(attributes = {})
  Project.make(attributes) do |project|
    ['issue_tracking'].each do |name|
      project.enabled_modules.make(:name => name)
    end
  end
end

EnabledModule.blueprint do
  project
  name { 'issue_tracking' }
end

Member.blueprint do
  project
  user
  role
end

Role.blueprint do
  name { Sham.single_name }
  position
  permissions
end

Enumeration.blueprint do
  name { Sham.single_name }
  opt { 'IPRI' }
end

IssueStatus.blueprint do
  name { Sham.single_name }
  is_closed { false }
end

Tracker.blueprint do
  name { Sham.single_name }
  position { Sham.position }
end

def make_tracker_for_project(project, attributes = {})
  Tracker.make(attributes) do |tracker|
    project.trackers << tracker
    project.save!
  end
end

Issue.blueprint do
  project
  subject { Sham.message }
  tracker { Tracker.make }
  description { Shame.message }
  priority { Enumeration.make(:opt => 'IPRI') }
  status { IssueStatus.make }
  author { User.make }
end

# Plugin specific
StuffToDo.blueprint do
  user
  stuff
end
