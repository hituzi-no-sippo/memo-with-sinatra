# frozen_string_literal: true

require 'yaml'
require 'erb'

class MemoList
  def initialize(storage_path)
    @memos = File.file?(storage_path) ? YAML.load_file(storage_path) : []
    @storage_path = storage_path
  end

  def data
    @memos
  end

  def add(title, body)
    @memos.push(convert_to_valid_format(title, body))
    write_storage
  end

  def delete(index)
    @memos.delete_at(index)
    write_storage
  end

  private

  def convert_to_valid_format(title, body)
    { 'title' => html_escape(title), 'body' => html_escape(body) }
  end

  def html_escape(str)
    ERB::Util.html_escape(str)
  end

  def write_storage
    YAML.dump(@memos, File.open(@storage_path, 'w'))
  end
end
