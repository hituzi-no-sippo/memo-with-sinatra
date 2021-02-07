# frozen_string_literal: true

require 'sinatra'

require_relative 'memo_list'

memo_list = MemoList.new("#{settings.root}/memos.yaml")

get '/' do
  @page_title = 'Memoアプリ'
  @titles = memo_list.data.map { |memo| memo['title'] }
  erb :index
end

get '/memos/new' do
  @page_title = 'メモ追加'
  erb :edit
end

post '/memos/new' do
  memo_list.add(params[:title], params[:body])
  redirect '/'
end

get '/memos/:index' do |index|
  @page_title = '詳細'
  @memo = memo_list.data[index.to_i]

  redirect '/' if @memo.nil?

  erb :detail
end
