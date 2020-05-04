# frozen_string_literal: true

require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test 'should get index' do
    get api_v1_articles_url, as: :json
    assert_response :success
  end

  test 'should create article' do
    assert_difference('Article.count') do
      post api_v1_articles_url, params: { article: { content: @article.content, slug: @article.slug, title: @article.title } }, as: :json
    end

    assert_response 201
  end

  test 'should show article' do
    get api_v1_article_url(@article), as: :json
    assert_response :success
  end

  test 'should update article' do
    patch api_v1_article_url(@article), params: { article: { content: @article.content, slug: @article.slug, title: @article.title } }, as: :json
    assert_response 200
  end

  test 'should destroy article' do
    assert_difference('Article.count', -1) do
      delete api_v1_article_url(@article), as: :json
    end

    assert_response 204
  end
end
