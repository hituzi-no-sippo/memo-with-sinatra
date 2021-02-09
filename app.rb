# frozen_string_literal: true

require 'sinatra'

require_relative 'memo_list'

memo_list = MemoList.new("#{settings.root}/memos.yaml")

get "/\(memos\)?" do
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
  redirect '/memos'
end

get '/memos/:index' do |index|
  @page_title = '詳細'
  @memo = memo_list.data[index.to_i]

  redirect '/memos' if @memo.nil?

  @index = index
  erb :detail
end

get '/memos/:index/edit' do |index|
  @page_title = '編集'
  memo = memo_list.data[index.to_i]

  redirect '/memos/' if memo.nil?

  @title = memo['title']
  @body = memo['body']
  @index = index
  erb :edit
end

patch '/memos/:index' do |index|
  memo_list.update(index.to_i, params[:title], params[:body])
  redirect '/memos'
end

delete '/memos/:index' do |index|
  memo_list.delete(index.to_i)
  redirect '/memos'
end

not_found do
  @page_title = 'ファイルが存在しません'
  erb :not_found
end
