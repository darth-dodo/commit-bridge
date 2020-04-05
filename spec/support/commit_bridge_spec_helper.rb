module CommitBridgeSpecHelper
  def load_json_from_fixture(fixture_path)
    JSON.parse(File.read(fixture_path))
  end
end
