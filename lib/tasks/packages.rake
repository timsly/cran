namespace :packages do
  desc 'Index CRAN packages'
  task index: :environment do
    RemotePackage.all.each_slice(100) do |remote_packages|
      Package.except_existing(remote_packages) do |remote_package|
        begin
          Package.create_from_remote remote_package
          puts "#{remote_package.full_name} was indexed"
        rescue
          puts "Error during #{remote_package.full_name} indexation"
        end
      end
    end
  end
end
