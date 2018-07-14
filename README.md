# The ABC of Rails Engines
 > 本文內容主要參考自 http://guides.rubyonrails.org/engines.html


本文會以下列三個段落來介紹 Rails Engine 的基礎知識及用法

* Rails Engine 是什麼?
* 打造一個 Rails Engine
* 在主程式中使用 Rails Engine


## Rails Engine 是什麼？

Rails Engine 主要的目的是透過簡單易用的程式介面 (interface) 來提供主程式 (Host) 額外功能，筆者認為可以把主程式 (Host) 想像成原型機器人，Rails Engine 則可視為具有不同能力的裝甲，只要將具有特殊能力的裝甲，適當地裝備 (hook) 在原型機器人身上，就可以組裝出具有各式能力的裝甲機器人，而程式介面 (interface) 就是相同的裝甲可裝載在不同機器人上的關鍵，當然組裝不好時也會造成效能不佳或容易故障的問題，亦或是選用設計不佳的裝甲 (Rails Engine) 也可能影響原機體 (Host) 的正常運作。
  
由此可看得出來裝甲之裝載並非是絕對必要的，如果你的團隊有足夠的能力、時間及資源，當然可以將所需要的功能直接「內建」在原型機器人裡，所以裝甲的選用與團隊的現況有直接的關係。

雖然每個裝甲都有既定的能力，但這並非完全不能改動的，技術人員仍然可以依照實際的需求，調整強化 (override) 裝甲原本的行為，使得改良過後的裝甲更為適用，這是因為原型機器人 (Host) 的優先權高於機甲 (Rails Engine) 的關係。

這邊的原型機器人(Host/ a rails application) 是指透過 Rails 框架所建造出來的，而原型機器人基本上就是一個強化版本 (a supercharged engine)，因此 Rails applications 與 Rails Engines 且有很高的共通性，Rails engines 亦可看成是小型的應用程式 (miniature applications)。

## 打造一個 Rails Engine

要打造一個 Rails Engine 很簡單，只要透過 `rails plugin new` 指令就可以產生一個 engine 的雛形。 這邊要特別說明的是 Engines 與 Plugins 是很相似的，相同的是他們都有一個 `lib` 資料夾，也都是透過 `rails plugin new` 指所產生的，不同是當我們提及 engine 時，通常指的是一個完整的 plugin (full plugin)，需要在產生時傳入 `--full` 或 `--mountable` 參數。

指令如下:

* `rails plugin new YOUR_ENGINE_NAME --full` 或 
* `rails plugin new YOUR_ENGINE_NAME --mountable`

下列比較表將以 **blorgh** 做為 engine name，主要以 `--full` 與 `--mountable` 參數所產生的 engines 為比較基準

|   |NO OPTION|`--full` | `--mountable` |
|---|--------|---------|---------------|
|app/ 資料夾|╳|〇|〇|
|bin/ 資料夾|〇|〇|〇|〇|
|config/ 資料夾|╳|〇|〇|
|lib/ 資料夾|〇|〇|〇|
|test/ 資料夾|〇|〇|〇|
|config/<br>routes.rb|╳|Rails.application.routes.draw do<br>end|**Blorgh::Engine**.routes.draw do<br>end|
|lib/<br>blorgh/<br>engine.rb|╳|module Blorgh<br>&nbsp;&nbsp;class Engine < ::Rails::Engine<br>&nbsp;&nbsp;end<br>end|module Blorgh<br>&nbsp;&nbsp;class Engine < ::Rails::Engine<br>&nbsp;&nbsp;&nbsp;&nbsp;**isolate_namespace Blorgh**<br>&nbsp;&nbsp;end<br>end|
|app/<br>helpers/<br>**blorgh**/<br>application_helper.rb|╳|╳|module Blorgh<br>&nbsp;&nbsp;module ApplicationHelper<br>&nbsp;&nbsp;end<br>end|
|app/<br>views/<br>layouts/<br>**blorgh**/<br>application.html.erb|╳|╳|〇|
|app/<br>javascripts/<br>**blorgh**/<br>application.js|╳|╳|〇|
|app/<br>javascripts/<br>**blorgh**/<br>application.css|╳|╳|〇|
|app/<br>javascripts/<br>**blorgh**/<br>application_controller.rb|╳|╳|module Blorgh<br>&nbsp;&nbsp;class ApplicationController < ActionController::Base<br>&nbsp;&nbsp;&nbsp;&nbsp;protect_from_forgery with: :exception<br>&nbsp;&nbsp;end<br>end|
|test/<br>dummy/<br>config/<br>routes.rb|Rails.application.routes.draw do<br>end|Rails.application.routes.draw do<br>end|Rails.application.routes.draw do<br>&nbsp;&nbsp;**mount Blorgh::Engine => "/blorgh"**<br>end|

### 實作即將開始
### 這個 Rails Engine (blorgh) 將提供主程式 (host) 一個基本的部落格功能:

* 文章列表
* 新增文章
* 編輯文章
* 刪除文章
* 留言評論

> 此範例取自 [Getting Started with Engines](http://guides.rubyonrails.org/engines.html)

> 請使用 Rails 5.1+ 版本

#### Step1. 產生一個 mountable 的 rails engine 雛形
```ruby
$ bin/rails plugin new blorgh --mountable

```
#### Step2. 快速產出文章的 Scaffolding (CRUD)
```ruby
# engine 根目錄
$ bin/rails generate scaffold article title:string text:text
```
請切換目錄到 `test/dummy` 底下，鍵入 `rails s` 啟動 rails server，在瀏覽器中輸入 http://localhost:3000/blorgh/articles 可看到具有CRUD功能的文章管理畫面，此時你應該已經可以新增、編輯、刪除文章，並在新增文章後可以看到文章列表。這邊的 test/dummy 其實是一個簡化版的 rails application，可讓我們在開發 engine 的時候用來測試之用，模擬日後 Engine 被掛入主程式的行為。

#### Step3. 指定 engine 首頁路徑
```ruby
# 在 config/routes.rb
Blorgh::Engine.routes.draw do
  resources :articles

  root to: "articles#index"
end
```
重啟 rails server 後，瀏覽 http://localhost:3000/blorgh 將會顯示文章列表頁面

#### Step4. 產生評論 (comments) 資源
```ruby
# engine 根目錄
$ bin/rails generate model Comment article_id:integer text:text
 
# 在 blorgh/test/dummy/ 目錄下執行下列執令
$ bin/rails db:migrate
```
為了在文章下面顯示評論內容，需要在 app/views/blorgh/articles/show.html.erb 中的 `<%= link_to 'Edit'` 之前加上下列程式碼
```erb
<h3>Comments</h3>
<%= render @article.comments %>
```
由於一篇文章 (article) 可以有多則評論 (comments)，因此需要在 article model 中定義 `has_many :comments` 關聯
```ruby
module Blorgh
  class Article < ApplicationRecord
    has_many :comments
  end
end

```
#### Step5. 加入可新增評論的表單

為了要可以新增評論，我們需要一個表單，在 app/views/blorgh 目錄中建立一個 comments 資料夾，並建立一個 _form.html.erb 的檔案，表單的程式碼如下
```erb
<h3>New comment</h3>
<%= form_with(model: [@article, @article.comments.build], local: true) do |form| %>
  <p>
    <%= form.label :text %><br>
    <%= form.text_area :text %>
  </p>
  <%= form.submit %>
<% end %>
```
將表單放在文章評論 `<%= render @article.comments %>` 的下方，要修改的檔案是 app/views/blorgh/articles/show.html.erb
```erb
<%= render "blorgh/comments/form" %>
```
我們已經在 model 中定義了關聯，還需要定義對應文章-評論的巢狀路由 (Nested Resources)，在 config/routes.rb 中修改路由如下
```ruby
Blorgh::Engine.routes.draw do
  resources :articles do
    resources :comments
  end

  root to: "articles#index"
end
```
有了 model，也有了路由，我們還需要對應新增 comment 所需的控制器 (controller)，可透過下列指令建立一個空的控制器
```ruby
$ bin/rails g controller comments

```
找到剛產生的控制器檔案 app/controllers/blorgh/comments_controller.rb，定義 create 方法，這個方法用以對應新增評論表單中的 POST 請求，程式碼如下
```ruby

def create
  @article = Article.find(params[:article_id])
  @comment = @article.comments.create(comment_params)
  flash[:notice] = "Comment has been created!"
  redirect_to articles_path
end
 
private
  def comment_params
    params.require(:comment).permit(:text)
  end
```
最後一步我們需要在 app/views/blorgh/comments/ 新增一個 _comment.html.erb 用做評論呈現的畫面，這個畫面對應的是先前加入  app/views/blorgh/articles/show.html.erb 中的 `<%= render @article.comments %>` 部份，畫面所需的程式碼如下，代表的是「一則評論」的樣子
```erb

<%= comment_counter + 1 %>. <%= comment.text %>
```

目前 app/views/blorgh/articles/show.html.erb 中的程式碼應如下所示
```erb
<p id="notice"><%= notice %></p>

<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>

<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>

<h3>Comments</h3>
<%= render @article.comments %>
<%= render "blorgh/comments/form" %>

<%= link_to 'Edit', edit_article_path(@article) %> |
<%= link_to 'Back', articles_path %>

```


現在再瀏覽任一篇文章時，應該可以在下面看見一個表單，輸入評論後按下 Create Comment，就可以看到評論已經被新增並顯示在該文章的下方了。

完成上述的步驟便可以完成一個可提供發文與評論留言的簡單部落格 Rails Engine


## 在主程式中使用 Rails Engine

首先我們先用 Rails 建立一各新的 Rails application (unicorn)
```ruby
$ rails new unicorn
```

#### Step1. 安裝 Engine

在主程式中使用 Rails Engine 的方式很簡單，你應該也不會太陌生，只要找到主程式的 Gemfile 檔案並加入下列描述即可

```ruby
# 由於我們開發的 Rails Engine 是在本機中，因此要使用 path 指定所在路徑
gem 'blorgh', path: '../the-abc-of-rails-engines/blorgh'
```

接著記得下在主程式的根目錄下 `bundle install` 安裝我們的 engine


#### Step2. 掛載 Engine
然後我們還需要在主程式的 config/routes.rb 中將 engine 掛進來，如此主程式才可以存取 engine 中的路由
```ruby
# at: "/可依個人需求喜好命名"
mount Blorgh::Engine, at: "/blog"
```

#### Step3. 複製 Engine 的 migration 檔案
此指令可重覆執行，不會有重複複製的副作用
```ruby
# 在主程式的根目錄
$ bin/rails blorgh:install:migrations
```

#### Step4. DB migrate
```ruby
# 執行 migrate
$ bin/rails db:migrate
```

現在在主程式的根目錄中使用 `rails s` 指令啟動伺服器，並瀏覽 http://localhost:3000/blog 應該可以看見文章頁面，你此時應該已經可以新增、刪除、修改文章，還可以在文章下方新增評論了。

*如果沒有要針對 Engine 的既有行為做調整，基本上到這邊就可以告一個段落了。*

接下來要討論是如何讓 Engine 使用主程式所定義的類別，而為了滿足這個需求，我們還需要調整 Engine 最初的設計，這邊希望達成的主要目的是希望可以為文章增加作者的資訊，而這個「作者」類別是具有彈性，將由主程式來進行定義，也就是說在這個調整之後，要使用這個 Engine 的主程式，一律需要告訴 Engine「作者」代表的是主程式中的哪一個類別。

*文章與評論由 Engine 負責定義，作者則交給「主程式」來定義*

#### Step5. 在 Engine 中提供可由主程式定義「作者」類別的方法
修改 lib/blorgh.rb 的 Blorgh module 中加入下列程式碼
```ruby
module Blorgh
  # 此類別存取子將開放給主程式定義「作者」類別之用
  mattr_accessor :author_class

  # 覆寫原本的 author_class getter 方法，使回傳值為常數物件
  def self.author_class
    @@author_class.constantize
  end
end

```

#### Step6. Article 的作者
在 article (app/models/blorgh/article.rb) 定義與作者的關聯及參照來源
```ruby
module Blorgh
  class Article < ActiveRecord::Base
    # ... 略
    # 由於 Blorgh.author_class 會回傳常數物件，應轉型為字串 
    belongs_to :author, class_name: Blorgh.author_class.to_s
    # ... 略
  end
end

```

#### Step7. 新增 author_id 到 article 中的 migration 檔案
```ruby
$ bin/rails g migration add_author_id_to_blorgh_articles author_id:integer

```

#### Step8. 修改 article model 如下
```ruby
module Blorgh
  class Article < ActiveRecord::Base
  	# 新增 author_name 欄位供暫時存取之用
    attr_accessor :author_name
    has_many :comments
    belongs_to :author, class_name: Blorgh.author_class.to_s

    # 透過這個 callback 建立/修改文章所對應的作者 (Blorgh.author_class)
    before_validation :set_author

    private

    def set_author
      self.author = Blorgh.author_class.find_or_create_by(name: author_name)
    end
  end
end

```

#### Step9. 新增作者名稱欄位
在 Engine 中的文章表單中(app/views/blorgh/articles/_form.html.erb) 新增作者名稱欄位
```erb
  <div class="field">
    <%= f.label :author_name %><br>
    <%= f.text_field :author_name %>
  </div>
```

#### Step10. 允許 :author_name 參數的傳遞
在 Engine 的 app/controllers/blorgh/articles_controller.rb 中的私有方法 article_params 允許 :author_name 參數欄位的傳入
```ruby
  def article_params
    params.require(:article).permit(:title, :text, :author_name)
  end
```

#### Step11. 顯示作者資訊
於 Engine 的 views/blorgh/articles/show.html.erb 中，在 "Title" 的上方加入作者的資訊
```erb
<p>
  <b>Author:</b>
  <%= @article.author&.name %>
</p>
```

#### Step12. 用 test/dummy 來測試
```rb
# 新增 User 類別
$ rails g model user name:string

# 匯入 engine 的 migrations
$ bin/rails blorgh:install:migrations

# 執行 db:migrate
$ bin/rails db:migrate

```

#### Step13. 定義「作者」
在 test/dummy/config/initializers 中新增一個 blorgh.rb 的檔案，並加入下列程式碼指定「作者」的類別
```ruby
# 這邊一定要使用「字串型態」的類別名穩，不可直接類別物件來定義，不然 Rails 會試圖去載入該類別並參考與其對應的資料表，如果此資料表還不存在時，將會造成不必要的問題
Blorgh.author_class = "User"
```

一樣透過 rails s 啟動 server，現在新增文章時應該可同時加上作者資訊，成功新增後亦可顯示作者資訊，但若要正常地編輯作者資訊，則還需要調整一下 Engine 裡 articles_controller 中 edit 方法，完整程式碼請參閱這邊。

如果可以讓 test/dummy 運作正常，那麼在主程式中只要實作 Step12 及 Step13，就可以達到一樣的效果了。