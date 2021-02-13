# frozen_string_literal: true

require 'pg'

class MemoDB
  class << self
    def setup
      create_db unless exist_db?
      create_table
    end

    def fetch_all
      execute_sql(
        'select', 'SELECT * FROM memos ORDER BY id ASC', []
      ).to_h do |record|
        [record['id'].to_sym, { title: record['title'], body: record['body'] }]
      end
    end

    def add(title, body)
      execute_sql(
        'add',
        'INSERT INTO memos(title, body) values ($1, $2)',
        [title, body]
      )
    end

    def update(id, title, body)
      execute_sql(
        'update',
        'UPDATE memos SET title=$1, body=$2 WHERE id=$3',
        [title, body, id]
      )
    end

    def delete(id)
      execute_sql('delete', 'DELETE FROM memos WHERE id=$1', [id])
    end

    private

    def connect
      PG.connect(user: 'postgres', dbname: 'memo_with_sinatra')
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

    def execute_sql(stmt_name, sql, params)
      connection = connect
      connection.prepare(stmt_name, sql)
      result = connection.exec_prepared(stmt_name, params)
      connection.finish

      result
    end
  end
end
