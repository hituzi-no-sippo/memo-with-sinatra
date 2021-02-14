# frozen_string_literal: true

require_relative 'memo_db'

class MemoList
  def initialize
    sync_with_db
  end

  def data
    @memos
  end

  def add(title, body)
    p title
    p body
    MemoDB.add(title, body)
    sync_with_db
  end

  def update(id, title, body)
    p title
    p body
    return unless exist?(id)

    MemoDB.update(id, title, body)
    sync_with_db
  end

  def delete(id)
    return unless exist?(id)

    MemoDB.delete(id)
    sync_with_db
  end

  private

  def sync_with_db
    @memos = MemoDB.fetch_all
  end

  def exist?(id)
    @memos.key?(id)
  end
end
