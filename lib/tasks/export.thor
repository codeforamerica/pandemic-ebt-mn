require 'thor'
require 'csv'
require './config/environment' # Load Rails

class Export < Thor
  desc 'children FILE', 'Exports children from the database to FILE (defaults to tmp/all.csv)'
  method_option :after, aliases: '-a', desc: 'Export children submitted after AFTER.'
  method_option :before, aliases: '-b', desc: 'Export children submitted before BEFORE.'

  def children(file_name = Rails.root.join('tmp', 'all.csv'))
    children = Child.submitted
    if options['after'].present?
      children = children.submitted_after(DateTime.parse(options['after']))
      puts "Exporting children submitted after #{DateTime.parse(options['after']).strftime('%B %d %Y')}"
    end
    if options['before'].present?
      children = children.submitted_before(DateTime.parse(options['before']))
      puts "Exporting children submitted before #{DateTime.parse(options['before']).strftime('%B %d %Y')}"
    end
    export(children, file_name)
  end

  desc 'last_x_days DAYS FILE', 'Exports children from the database for the last DAYS days (defaults to 7) to FILE (defaults to tmp/all.csv). Does not include the day the script is run'
  def last_x_days(days = 7, file_name = Rails.root.join('tmp', 'all.csv'))
    children = Child.submitted
    children = children.submitted_after(DateTime.now.midnight - days.to_i.days)
    children = children.submitted_before(DateTime.now.midnight)
    export(children, file_name)
  end

  no_commands do
    def export(children, file_name)
      File.delete(file_name) if File.exist?(file_name)
      CSV.open(file_name, 'w') do |file|
        file << Child.csv_headers
        children.in_batches.each_record do |row|
          file << row.csv_row
        end
      end
      puts "EXPORT COMPLETE! Exported to #{file_name}"
    end
  end
end
