class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :category, inclusion: {in: ["Fiction", "Non-Fiction"]}
  validate :content_is_at_least_100

  def content_is_at_least_100
  	if content.length < 100
  	  errors.add(:content, "Your content is less than 100 characters.")
  	end
  end

  def create
  	@post = Post.new(post_params)
 
    # Run the validations WITHOUT attempting to save to the database, returning
    # true if the Post is valid, and false if it's not.
    if @post.valid?
      # If--and only if--the post is valid, do what we usually do.
      @post.save
      # This returns a status_code of 302, which instructs the browser to
      # perform a NEW REQUEST! (AKA: throw @post away and let the show action
      # worry about re-reading it from the database)
      redirect_to post_path(@post)
    else
      # If the post is invalid, hold on to @post, because it is now full of
      # useful error messages, and re-render the :new page, which knows how
      # to display them alongside the user's entries.
      render :new
    end
  end
end
