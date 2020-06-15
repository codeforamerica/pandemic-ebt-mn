require 'rails_helper'

RSpec.describe 'Exporting Children as CSV', type: :feature do
  SUCCESS_MESSAGE = 'Upload Complete!'.freeze
  REDIRECT_STDERR = '2>&1'.freeze

  before(:all) do
    @aws_vars = %w[AWS_REGION AWS_EXPORT_UPLOAD_BUCKET AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY]
    @file_name = Rails.root.join('tmp', 'testcsv.csv')
    File.open(@file_name, 'w') { |f| f.write('a,b,c') }
  end

  after(:all) do
    File.delete(@file_name) if File.exist?(@file_name)
  end

  before do
    @aws_vars.each { |var| ENV[var] = 'Dummy Value' }
  end

  def run_command_redirected(cmd)
    `#{cmd} #{REDIRECT_STDERR}`
  end

  # Note the use of `2>&1` which forces STDERR to STDOUT to let us check failures

  it 'raises an error if no file name passed' do
    captured_stdout = `thor export:upload_export_to_aws 2>&1`
    expect(captured_stdout).not_to include(SUCCESS_MESSAGE)
    expect(captured_stdout).to include('was called with no arguments')
  end

  it 'raises an error if the AWS ENV Variables are not set' do
    @aws_vars.each { |var| ENV.delete(var) }
    captured_stdout = `thor export:upload_export_to_aws #{@file_name} 2>&1`
    expect(captured_stdout).not_to include(SUCCESS_MESSAGE)
    expect(captured_stdout).to include('is required to be set as an environment variable')
  end

  it 'raises an error if the file does not exist' do
    captured_stdout = `thor export:upload_export_to_aws dummyfile.csv 2>&1`
    expect(captured_stdout).not_to include(SUCCESS_MESSAGE)
    expect(captured_stdout).to include('does not exist')
  end
end
