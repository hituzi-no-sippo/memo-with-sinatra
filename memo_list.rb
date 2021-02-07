# frozen_string_literal: true

require 'yaml'

class MemoList
  def initialize(storage_path)
    @memos = File.file?(storage_path) ? YAML.load_file(storage_path) : []
  end

  def data
    @memos
  end
end
