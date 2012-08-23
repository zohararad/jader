# Jader - Share your Jade templates between client and server

Jade is a very popular templating engine for Node.js. This gem gives
you ability to easily use Jade templates for both server and client side in your Rails project.

On the client-side your templates should be used with Rails' JST engine. On the server side, you can render your
Jade templates as Rails views (similar to how you'd render ERB or HAML templates).

## Writing your templates

Lets assume you have a users controller `app/controllers/users_controller.rb` which in turn renders a list of users.
We'd like to share that view between the client and the server.

### Server-Side code

```ruby
class UsersController < ApplicationController

  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

end
```

To share our template between client and server, we need to place it under `app/assets/javascripts` for Sprockets' JST engine.

Lets create a views directory for our shared templates `app/assets/javascripts/views` and add our template there, following Rails' naming convensions.

The full template path should look like this: `app/assets/javascripts/views/users/index.jst.jade`

### Template code

The most significant differences between using standard server-side Ruby-based engines like ERB or HAML and using Jader are:

* No access to server-side view helpers (such as url_for)
* No ruby-style instance variable like `@users`
* Template code is Javascript, not Ruby and has to follow Jade's syntax rather than embedded Ruby syntax
* No partials or includes

Our template code should look like this:

```
ul.users
  each user in users
    li.user= user.name
```

Note that rendering this template server-side, will be done inside your application's layout. You can write your views layout file in ERB / HAML
and the call to `=yield` will render your Jade template above.

### Sharing template code

Since Rails doesn't expect server-side templates to live under `app/assets` we need to add our client-side views path to Rails views lookup path.

Inside your `application_controller.rb` add the following:

```
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :prepend_view_paths

  # .... application controller code

  private

  # Adds Client-Side views to render path
  def prepend_view_paths
    prepend_view_path Rails.root.join('app', 'assets', 'javascripts', , 'views')
  end

end

```

This is a ad-hoc solution that should change in the near future.

### Client-side code

To render the same template from the client, we need to fetch our users list from the server and then call our JST template with that list.

First, lets change our controller to return a JSON formatted list of users when called from the client:

```ruby
class UsersController < ApplicationController

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json {
        render :json => @users.to_jade
      }
    end
  end

end
```

Note the call to `to_jade` on the `@users` collection. This ensures our users are properly serialized for use inside our template.
See the **Serialization** section below for more details.

In our `application.js` file lets write the following:

```javascript
//= require jade/runtime
//= require views/users/index

$.getJSON('/users', function(users){
  $('body').html(JST['views/users/index']({users:users}));
});
```

## Serialization

To help Jader access Ruby and Rails variables inside the template, we need to employ some sort of JSON serializing before passing
these variables to the template. On the server-side, this happens automagically before the template is rendered.

Internally, Jader will try to call the `to_jade` method on each instance variable that's passed to the template. Ruby's Hash, Array and Object classes have been extended
to support this functionality. Arrays and Hashes will attempt to call the `to_jade` method on their members when `to_jade` is invoked on their instances. For
other collection-like variables, the `to_jade` method will only be invoked if they respond to a `to_a` method. This allows ActiveModel / ActiveRecord instance variables to
automatically serialize their members before rendering.

### Serializing models

Jader does not assume your Rails models should be serialized by default. Instead, it expects you to enable serializing on desired models explicitly.

To enable this behaviour, consider the following example:

```
class User < ActiveRecord::Base

  include Jader::Serialize

  jade_serializable :name, :email, :favorites, :merge => false

end
```

The call to `include Jader::Serialize` mixes Jader::Serializer capabilities into our model class.

We can then tell the serializer which attributes we'd like to serialize, and how we'd like the serialization to work.

By default, calling `jade_serializable` with no arguments will serialize all your model attributes. Lets look at two examples:

Consider the following code:

```
# define our model
class User < ActiveRecord::Base

  include Jader::Serialize

  jade_serializable

end

# access in controller
class UsersController < ApplicationController

  def index
    @users = User.all
    @users.to_jade # => all available user attributes (users table columns) will be serialized
  end

  def active
    @users = User.where('active = 1').select('name, email')
    @users.to_jade # => only name and email attributes are serialized
  end
end
```

For better control over which attributes are serialized, and when serializing model relationships, we can tell the serializer
which attributes should always be serialized, and whether we'd like these attributes to be merged with the default attributes or not.

Consider the following code:


```
# define our models

class Favorite < ActiveRecord::Base

  include Jader::Serialize

  jade_serializable

  belongs_to :user

end

class User < ActiveRecord::Base

  include Jader::Serialize

  jade_serializable :favorites, :merge => true

  has_many :favorites
end

# access in controller
class UsersController < ApplicationController

  def active
    @users = User.where('active = 1').select('name, email')
    @users.to_jade # => only name, email and favorites attributes are serialized
  end
end
```

In the above, we defined serialization for the `User` model to include the `:favorites` attribute, which is available because of the `has_many` relationship
to the `Favorite` model. Additionally, we specified that serialization should merge model default attributes with the specified attributes, by setting `:merge => true` .

This will result in merging `self.attributes` and `self.favorites` on any instance of the `User` model when calling the `to_jade` method on it.

To only serialize the specified attributes, call `jade_serializable` with `:merge => false` .

Invokation format for `jade_serializable` is:

```
jade_serializable :attr1, :attr2, :attr3 ...., :merge => true/false
```

By default, `jade_serializable` will operate with `:merge => true` and merge instnace attributes with specified attributes.

## Mixins

Jade has built in support for template mixins. Jader allows you to define and share mixins inside your templates.

Following Rails helpers conventions, your Jade mixins can be defined either as application-level mixins or as controller-level mixins.

Assuming we have a users controller, we can add mixins by creating a mixins folder under `app/assets/javascripts` and adding:

* `app/assets/javascripts/helpers/application_mixins.jade`
* `app/assets/javascripts/helpers/users_mixins.jade`

Mixins that are defined inside `application_mixins.jade` will be available in all templates. This is a perfect place for example to add a pagination mixin.

Controller-level mixins are defined inside `CONTROLLER_NAME_mixins.jade` and are available only inside the relevant controller. Since the
client-side has no notion of which controller is currently being rendered, we need to strictly follow Rails naming conventions as follows:

* Client-side views subdirectories are named after their controller. For example, for `UsersController` we will have `app/assets/javascripts/views/users`
* Client-side Jade mixins files are resolved based on view name. `mixins/users_mixins.jade` will be available for views inside `views/users` folder

To enable Jader's mixins capabilities we need to configure Jader and tell it where to look for mixins files:

```ruby
Jader.configure do |config|
  config.mixins_path = Rails.root.join('app','assets','javascripts','mixins')
end
```

### Notes on performance

On the client-side, Jader will add the mixins code into your Jade template. This can potentially increase your client-side file size dramatically. Since application-level
mixins are included in each and every template, please be sure to keep them to a bare minimum.

## Javascript inclusion

Often we'll have additional Javascript that is included client-side and adds more functionality to our client-side application. Two such examples could be
using `I18n.js` for internationalization, or `Date.js` for better date handling.

Since our server-side templates cannot access this code, we need to figure out a way to share arbitrary Javascript from our client in the server.

This is where inclusions come in.

We can tell Jader to add arbitrary pieces of raw Javascript to the server-side rendering context before evaluating our template like so:

```ruby
Jader.configure do |config|
  config.includes << IO.read(Rails.root.join('app','assets','javascripts','includes','util.js'))
end
```

`Jader::Configuration.includes` is an array that accepts raw Javascript strings and is passed to the server-side template evaluation context.

To give a more pragmatic example of using `I18n.js` on both server and client, lets assume we have `gem 'i18n-js'` installed.

Our `application.js` file will then include:

```
//= require i18n
//= require i18n/translations
```

The first require is made available via `i18n-js` vendorized assets while the second require is a translations file inside our `app/assets/javascripts/i18n` folder.

To enable I18n support when rendering templates on the server, we configure Jader as follows:

```ruby
Jader.configure do |config|
  # wait for assets to be ready
  Rails.application.config.after_initialize do
    # inject assets source into Jader's includes array
    config.includes << Rails.application.assets['i18n'].source
    config.includes << Rails.application.assets['i18n/translations'].source
    config.includes << "I18n.defaultLocale = 'en'; I18n.locale = 'en';"
  end
end
```

## Configuration

Its recommended to configure Jader inside a Rails initializer so that configuration is defined at boot time.

Assuming we have an initializer `app/config/initializers/jader.rb` it should include:

```ruby
Jader.configure do |config|
  config.mixins_path = Rails.root.join('app','assets','javascripts','mixins')
  # Use some javascript from a file that's not available in the asset pipeline
  config.includes << IO.read(Rails.root.join('app','assets','javascripts','includes','util.js'))
  # wait for assets to be ready
  Rails.application.config.after_initialize do
    # include javascripts available only from asset pipeline
    config.includes << Rails.application.assets['util'].source
  end
end
```

## Kudos

Jader is built upon the wonderful work of [Boris Staal](https://github.com/roundlake/jade/) and draws heavily from:

  - [ice](https://github.com/ludicast/ice)
  - [ruby-haml-js](https://github.com/dnagir/ruby-haml-js)
  - [tilt-jade](https://github.com/therabidbanana/tilt-jade)
  
Boris Staal's Jade Rubygem It was developed as a successor to tilt-jade to improve following:

  * Add debugging capabilities (slightly different build technique)
  * Support exact Jade.JS lib without modifications
  * Do not hold 3 copies of Jade.JS internally
  * Be well-covered with RSpec

## Credits

<img src="http://roundlake.ru/assets/logo.png" align="right" />

* Boris Staal ([@_inossidabile](http://twitter.com/#!/_inossidabile))

# License

Copyright (c) 2012 Zohar Arad <zohar@zohararad.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.