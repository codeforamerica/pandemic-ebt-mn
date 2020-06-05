require 'thor'
require 'yaml'
require 'csv'
# DO NOT load rails

class Translation < Thor
  desc 'compare TO FROM', 'Compares TO file to the FROM file (default en)'
  def compare(to_lang = 'es', from_lang = 'en')
    @from = YAML.load(File.read("config/locales/#{from_lang}.yml"))[from_lang]
    @to = YAML.load(File.read("config/locales/#{to_lang}.yml"))[to_lang]
    @output = []

    @from.each do |page, c|
      c.each do |key, value|
        @output << issue_report(key, page, "Missing #{@to['shared']['language']}") if @to[page][key].nil?
        @output << issue_report(key, page, "Identical Copy") if @to[page][key] == @from[page][key]
      end
    end

    @to.each do |page, content|
      content.each do |key, value|
        @output << issue_report(key, page, "Extra key in #{@to['shared']['language']}") if @from[page][key].nil?
      end
    end

    column_names = @output.first.keys

    s=CSV.generate do |csv|
      csv << column_names
      @output.each do |x|
        csv << x.values
      end
    end

    File.delete('tmp/comp.csv') if File.exists?('tmp/comp.csv')
    File.write('tmp/comp.csv', s)

    puts 'WOOHOO I am done!'
  end

  protected

  def issue_report(key, page, note)
    return {
      "page" => page,
      "key" => key,
      @from['shared']['language'] => @from[page][key],
      @to['shared']['language'] => @to[page][key],
      'note' => note
    }
  end
end
