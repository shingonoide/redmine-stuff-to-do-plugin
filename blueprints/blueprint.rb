# Redmine Shams
Sham.mail { Faker::Internet.email }
Sham.name { Faker::Name.name }
Sham.firstname { Faker::Name.first_name }
Sham.lastname { Faker::Name.last_name }
Sham.login { Faker::Internet.user_name }
Sham.project_name { Faker::Company.name }
Sham.identifier { Faker::Internet.domain_word.downcase }
Sham.message { Faker::Company.bs }
Sham.position {|index| index }

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
  name
  position
  permissions
end
