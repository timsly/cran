namespace :packages do
  def final_banner(total, indexed, failed)
    puts "Processed #{total} packages:"
    puts "  * Indexed: #{indexed}"
    puts "  * Failed: #{failed}"
    puts "  * Skipped: #{total - indexed - failed}"
  end

  desc 'Index CRAN packages'
  task index: :environment do
    indexed = failed = total = 0

    begin
      RemotePackage.all.each_slice(100) do |remote_packages|
        total += remote_packages.size
        Package.except_existing(remote_packages) do |remote_package|
          begin
            Package.create_from_remote remote_package
            puts "#{remote_package.full_name} was indexed"
            indexed += 1
          rescue StandardError => e
            puts "Error during #{remote_package.full_name} indexation: #{e.message}"
            failed += 1
          end
        end
      end

      final_banner total, indexed, failed
    rescue Interrupt
      final_banner total, indexed, failed
    end

  end
end
