# frozen_string_literal: true

module FileHelper
  module_function

  def fixture_path
    @fixture_path ||= File.expand_path('../fixtures/files', __dir__)
  end

  def file_fixture(name)
    File.read(File.join(fixture_path, name))
  end
end
