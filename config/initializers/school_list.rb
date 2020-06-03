SCHOOL_LIST = YAML.safe_load(File.read(Rails.root.join('config', 'mnschoollist.yml'))).freeze
