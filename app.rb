# frozen_string_literal: true

require 'sinatra'

require_relative 'memo_list'

memo_list = MemoList.new("#{settings.root}/memos.yaml")

get '/' do
  @page_title = 'Memoアプリ'
  @titles = memo_list.data.map { |memo| memo['title'] }
  erb :index
end
