require 'test_helper'

module Blorgh
  class ArticlesControllerTest < ActionController::TestCase
    setup do
      @article = blorgh_articles(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:articles)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create article" do
      assert_difference('Article.count') do
        post :create, params: { article: { text: @article.text, title: @article.title, author_name: 'author'}}
      end

      assert_redirected_to article_path(assigns(:article))
    end

    test "should show article" do
      get :show, params: { id: @article }
      assert_response :success
    end

    test "should get edit" do
      get :edit, params: { id: @article }
      assert_response :success
    end

    test "should update article" do
      patch :update, params: { id: @article, article: { text: @article.text, title: @article.title } }
      assert_redirected_to article_path(assigns(:article))
    end

    test "should destroy article" do
      assert_difference('Article.count', -1) do
        delete :destroy, params: { id: @article }
      end

      assert_redirected_to articles_path
    end
  end
end
