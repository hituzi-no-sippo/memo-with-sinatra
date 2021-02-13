# frozen_string_literal: true

require 'pg'
require 'erb'

class MemoDB
  def initialize
    sync_memos
  end

  attr_reader :memos

  class << self
    def setup
      create_db unless exist_db?
      create_table
    end

    def exist_db?
      `psql -U postgres -l | grep memo_with_sinatra` != ''
    end

    def create_db
      `psql -U postgres -c '
        CREATE DATABASE memo_with_sinatra WITH OWNER postgres ENCODING = "UTF8"
      '`
    end

    def create_table
      connect.exec('
        CREATE TABLE IF NOT EXISTS memos
        ( id serial PRIMARY KEY, title text not null, body text not null)
      ')
    end

    def connect
      PG.connect(user: 'postgres', dbname: 'memo_with_sinatra')
    end
  end


  def add(title, body)
    execute_sql(
      'add',
      'INSERT INTO memos(title, body) values ($1, $2)',
      [title, body].map { |str| html_escape(str) }
    )
  end

  def delete(id)
    execute_sql('delete', 'DELETE FROM memos WHERE id=$1', [id])
  end

  def update(id, title, body)
    return if @memos[id].nil?

    execute_sql(
      'update',
      'UPDATE memos SET title=$1, body=$2 WHERE id=$3',
      [html_escape(title), html_escape(body), id]
    )
  end

  private

  def execute_sql(stmt_name, sql, params)
    connection = MemoDB.connect
    connection.prepare(stmt_name, sql)
    connection.exec_prepared(stmt_name, params)
    connection.finish
    sync_memos
  end

  def sync_memos
    connection = MemoDB.connect
    @memos = connection.exec('SELECT * FROM memos ORDER BY id ASC') do |records|
      records.to_h do |record|
        [record['id'].to_sym, { title: record['title'], body: record['body'] }]
      end
    end
    connection.finish
  end
end
