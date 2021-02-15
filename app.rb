# frozen_string_literal: true

require 'sinatra'
require 'erb'

require_relative 'memo_list'

helpers do
  def html_escape(str)
    ERB::Util.html_escape(str)
  end
end

memo_list = MemoList.new

get "/\(memos\)?" do
  @page_title = 'Memoアプリ'
  @memos = memo_list.data
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

get '/memos/:id' do |id|
  @page_title = '詳細'
  @memo = memo_list.data[id.to_sym]

  redirect '/memos' if @memo.nil?

  @id = id
  erb :detail
end

get '/memos/:id/edit' do |id|
  @page_title = '編集'
  memo = memo_list.data[id.to_sym]

  redirect '/memos/' if memo.nil?

  @title = memo[:title]
  @body = memo[:body]
  @id = id
  erb :edit
end

patch '/memos/:id' do |id|
  memo_list.update(id.to_sym, params[:title], params[:body])
  redirect '/memos'
end

delete '/memos/:id' do |id|
  memo_list.delete(id.to_sym)
  redirect '/memos'
end

not_found do
  @page_title = 'ファイルが存在しません'
  erb :not_found
end
