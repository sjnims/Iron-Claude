# Turbo Frame: Inline Editing

Classic pattern for editing content without page reload.

## Use Case

User clicks "Edit" and form appears inline, submits without full page reload.

## Code

### View (index.html.erb)
```erb
<% @articles.each do |article| %>
  <%= turbo_frame_tag dom_id(article) do %>
    <h2><%= article.title %></h2>
    <p><%= article.body %></p>
    <%= link_to "Edit", edit_article_path(article) %>
  <% end %>
<% end %>
```

### Edit View (edit.html.erb)
```erb
<%= turbo_frame_tag dom_id(@article) do %>
  <%= form_with model: @article do |f| %>
    <%= f.text_field :title %>
    <%= f.text_area :body %>
    <%= f.submit "Save" %>
    <%= link_to "Cancel", article_path(@article), data: { turbo_frame: "_top" } %>
  <% end %>
<% end %>
```

### Controller
```ruby
def edit
  # Renders edit form inside turbo frame
end

def update
  if @article.update(article_params)
    redirect_to article_path(@article)  # Frame navigates to show
  else
    render :edit, status: :unprocessable_entity
  end
end
```

## Progressive Enhancement

Without JavaScript: Links navigate normally, forms submit with full page reload.

## Benefits

- No JavaScript needed
- Works with standard Rails patterns
- Screen reader friendly
- Keyboard navigation intact
