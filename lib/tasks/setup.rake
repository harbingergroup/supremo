namespace :supremo do
  desc "Runs basic setup for Supremo"
  task :setup => :environment do

    unless a=User.find_by_type('Admin')
      puts 'Creating Administrator User'
      a = Admin.create(:firstname=>'Admin',:lastname=>'Admin',:email=>'admin@admin.com',:password=>'test_1234',:password_confirmation=>'test_1234')
    end
    unless Department.find_by_name('Other')
      puts 'Creating Department'
      Department.create(:name=>'Other',:head_id=>a.id,:activated=>1)
    end
  end
end