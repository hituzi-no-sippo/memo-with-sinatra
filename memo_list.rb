# frozen_string_literal: true

require 'erb'

require_relative 'memo_db'

class MemoList
  def initialize
    sync_with_db
  end

  def data
    @memos
  end

  def add(title, body)
    MemoDB.add(html_escape(title), html_escape(body))
    sync_with_db
  end

  def update(id, title, body)
    return unless exist?(id)

    MemoDB.update(id, html_escape(title), html_escape(body))
    sync_with_db
  end

  def delete(id)
    return unless exist?(id)

    MemoDB.delete(id)
    sync_with_db
  end

  private

  def html_escape(str)
    ERB::Util.html_escape(str)
  end

  def sync_with_db
    @memos = MemoDB.fetch_all
  end

  def exist?(id)
    @memos.key?(id)
  end
end
