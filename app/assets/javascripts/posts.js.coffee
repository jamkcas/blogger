# Ajax call function
ajaxCall = (url, type, data) ->
  $.ajax(url, {
    data: data,
    type: type
  })

# Append comment function
appended = (data, test) ->
  entry = JST['templates/comment_list']({
    content: data.content,
    id: data.id
  })
  test.append(entry)
  test.append('<button class="button">Add Comment</button>')


# On load function
$ ->

  # Populating the list
  start = $.ajax('/posts.json', {
      type: 'GET'
    })

  start.done (data) ->
    posts = data.slice(0, 5)
    _.each(posts, (p) ->

      if(p.content)
        entry = "<li data-id='#{p.id}' data-type='2' class='entry clearfix'>
          <h3>#{p.title}</h3>
          <p>#{p.content}</p>
        </li>"

      else if(p.image)
        entry = "<li data-id='#{p.id}' data-type='2' class='entry clearfix'>
          <h3>#{p.title}</h3>
          <img src='#{p.image}' />
        </li>"

      $('.postList').append(entry)
      _.each p.comments.slice(-4,-1), (c) ->
        $('.postList').children().last().append("<li><p>#{c.content}</p></li>")
      $('.postList').children().last().append('<button class="button">Add Comment</button>')

    )


  # When add comment button is clicked
  $('.postList').on 'click', '.button', ->
    event.preventDefault()
    # Grab the associated list item it belongs too
    list = $(this).parent()
    # Determining the type of the entry
    if list.data('type') == 1
      type = 'Post'
    else if list.data('type') == 2
      type = 'Photo'
    # Getting the is of the post or photo
    id = list.data('id')
    # Building the new comment form
    comment = JST['templates/comment_form']({
      id: id,
      type: type
    })
    # Hiding the add comment button
    $(this).remove()
    # Appending the new comment form to its corresponding list entry
    list.append(comment)

  # New form submission
  $('.postList').on 'submit', '.commentForm', ->
    event.preventDefault()

    # Grabbing form values
    comment = $('#comment').val()
    commentable_id = $('#commentable_id').val()
    commentable_type = $('#commentable_type').val()

    # Grabbing parent element for appending comments
    test = $(this).parent()
    console.log test

    # Configuring the data to be sent in ajax call
    data = {
      content: comment,
      commentable_id: commentable_id,
      commentable_type: commentable_type
    }

    # Checking what type the comment is appending to to determine where to route the ajax call
    if(commentable_type == 'Photo')
      # Setting the url for ajax call
      url = '/photos/' + commentable_id + '/comments'
      # Making the ajax call
      call = ajaxCall(url, 'POST', data)
      # Appending the data to its parent list item after the ajax call is done
      call.done (data) ->
        appended(data, test)
    else
      # Setting the url for ajax call
      url = '/posts/' + commentable_id + '/comments'
      # Making the ajax call
      call = ajaxCall(url, 'POST', data)
      # Appending the data to its parent list item after the ajax call is done
      call.done (data) ->
        appended(data, test)

    # Showing the button and removing this form
    # test.children()[2].style.display = 'inline'

    $(this).remove()


  # Displaying proper text field depending on which radial button is pressed in the newPost form
  $('#photo').click ->
    if(!($('#content').hasClass('display')))
      $('#content').addClass('display')
    $('#url').removeClass('display')

  $('#post').click ->
    if(!($('#url').hasClass('display')))
      $('#url').addClass('display')
    $('#content').removeClass('display')


  # New post form
  $('#newPost').submit ->
    event.preventDefault()

    # Getting input values from form
    title = $('#title').val()

    # Ajax call for saving and appending a new photo
    if($('#photo').is(':checked'))
      # Getting form values
      type = $('#photo').val()
      image = $('#url').val()
      # Configuring data for the ajax call
      data = {
        title: title,
        image: image
      }
      # Making the post call
      post = ajaxCall('/photos', 'POST', data)
      # Appending the data to the photo list
      post.done (data) ->
        entry = JST['templates/photo_list']({
          title: data.title,
          id: data.id,
          image: data.image
        })
        $('.postList').prepend(entry)
    # Ajax call for saving and appending a new post
    else
      # Getting form values
      type = $('#post').val()
      content = $('#content').val()
      # Configuring data for the ajax call
      data = {
        title: title,
        content: content
      }
      # Making the post call
      post = ajaxCall('/posts', 'POST', data)
      # Appending the data to the post list
      post.done (data) ->
        entry = JST['templates/post_list']({
          title: data.title,
          id: data.id,
          content: data.content
        })
        $('.postList').prepend(entry)

    # Reset the form values
    $('#title').val('')
    $('#url').val('')
    $('#content').val('')








